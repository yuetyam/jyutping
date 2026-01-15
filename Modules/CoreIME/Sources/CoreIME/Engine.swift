import Foundation
import SQLite3
import CommonExtensions

// MARK: - Preparing Databases

public struct Engine {
        public static func prepare() {
                let statement = prepareAnchorsStatement()
                defer { sqlite3_finalize(statement) }
                let testCode: Int64 = 20
                sqlite3_reset(statement)
                sqlite3_bind_int64(statement, 1, testCode)
                guard sqlite3_step(statement) == SQLITE_ROW else { return }
        }
        #if os(macOS)
        nonisolated(unsafe) static let database: OpaquePointer? = {
                var db: OpaquePointer? = nil
                guard let path: String = Bundle.module.path(forResource: "imedb", ofType: "sqlite3") else { return nil }
                var storageDatabase: OpaquePointer? = nil
                defer { sqlite3_close_v2(storageDatabase) }
                guard sqlite3_open_v2(path, &storageDatabase, SQLITE_OPEN_READONLY, nil) == SQLITE_OK else { return nil }
                guard sqlite3_open_v2(":memory:", &db, SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE | SQLITE_OPEN_FULLMUTEX, nil) == SQLITE_OK else { return nil }
                let backup = sqlite3_backup_init(db, "main", storageDatabase, "main")
                guard sqlite3_backup_step(backup, -1) == SQLITE_DONE else { return nil }
                guard sqlite3_backup_finish(backup) == SQLITE_OK else { return nil }
                return db
        }()
        #else
        nonisolated(unsafe) static let database: OpaquePointer? = {
                var db: OpaquePointer? = nil
                guard let path: String = Bundle.module.path(forResource: "imedb", ofType: "sqlite3") else { return nil }
                guard sqlite3_open_v2(path, &db, SQLITE_OPEN_READONLY | SQLITE_OPEN_FULLMUTEX, nil) == SQLITE_OK else { return nil }
                return db
        }()
        #endif

        /// SQLITE_TRANSIENT replacement
        static let transientDestructorType = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
}


// MARK: - Suggestions

extension Engine {
        public static func suggest<T: RandomAccessCollection<VirtualInputKey>>(events: T, segmentation: Segmentation) -> [Candidate] {
                lazy var anchorsStatement = prepareAnchorsStatement()
                lazy var spellStatement = prepareSpellStatement()
                lazy var strictStatement = prepareStrictStatement()
                defer {
                        sqlite3_finalize(anchorsStatement)
                        sqlite3_finalize(spellStatement)
                        sqlite3_finalize(strictStatement)
                }
                switch events.count {
                case 0: return []
                case 1:
                        switch events.first {
                        case .letterA:
                                let text = VirtualInputKey.letterA.text
                                return spellMatch(text: text, input: text, mark: text, statement: spellStatement) + spellMatch(text: text + text, input: text, mark: text, statement: spellStatement) + anchorsMatch(events: events, input: text, statement: anchorsStatement)
                        case .letterO, .letterM:
                                guard let text = events.first?.text else { return [] }
                                return spellMatch(text: text, input: text, mark: text, statement: spellStatement) + anchorsMatch(events: events, input: text, statement: anchorsStatement)
                        default:
                                return anchorsMatch(events: events, statement: anchorsStatement)
                        }
                default:
                        return dispatch(events: events, segmentation: segmentation, anchorsStatement: anchorsStatement, spellStatement: spellStatement, strictStatement: strictStatement)
                }
        }

        private static func dispatch<T: RandomAccessCollection<VirtualInputKey>>(events: T, segmentation: Segmentation, anchorsStatement: OpaquePointer?, spellStatement: OpaquePointer?, strictStatement: OpaquePointer?) -> [Candidate] {
                let syllableEvents = events.filter(\.isSyllableLetter)
                let candidates: [Candidate] =  switch (segmentation.first?.first?.alias.count ?? 0) {
                case 0:
                        processSlices(of: syllableEvents, text: syllableEvents.map(\.text).joined(), anchorsStatement: anchorsStatement, spellStatement: spellStatement)
                case 1 where syllableEvents.count > 1,
                        _ where syllableEvents.count != events.count :
                        search(events: syllableEvents, segmentation: segmentation, anchorsStatement: anchorsStatement, spellStatement: spellStatement, strictStatement: strictStatement) + processSlices(of: syllableEvents, text: syllableEvents.map(\.text).joined(), anchorsStatement: anchorsStatement, spellStatement: spellStatement)
                default:
                        search(events: syllableEvents, segmentation: segmentation, anchorsStatement: anchorsStatement, spellStatement: spellStatement, strictStatement: strictStatement)
                }
                switch (events.contains(where: \.isApostrophe), events.contains(where: \.isToneEvent)) {
                case (false, false):
                        return candidates
                case (true, true):
                        let inputText = events.map(\.text).joined()
                        let text = inputText.toneConverted()
                        return candidates.compactMap({ item -> Candidate? in
                                guard text.hasPrefix(item.romanization) else { return nil }
                                return item.replacedInput(with: inputText)
                        })
                case (false, true):
                        let inputText = events.map(\.text).joined()
                        let toneInput = events.filter(\.isSyllableLetter.negative).map(\.text).joined()
                        let text = inputText.toneConverted()
                        let textTones = text.tones
                        let qualified: [Candidate] = candidates.compactMap({ item -> Candidate? in
                                let syllableText = item.romanization.removedSpaces()
                                guard syllableText.hasPrefix(text).negative else { return item.replacedInput(with: inputText) }
                                let tones = syllableText.tones
                                switch (textTones.count, tones.count) {
                                case (1, 1):
                                        guard textTones == tones else { return nil }
                                        let isCorrectPosition: Bool = text.dropFirst(item.inputCount).first?.isCantoneseToneDigit ?? false
                                        guard isCorrectPosition else { return nil }
                                        let combinedInput = item.input + toneInput
                                        return item.replacedInput(with: combinedInput)
                                case (1, 2):
                                        let isToneLast: Bool = text.last?.isCantoneseToneDigit ?? false
                                        if isToneLast {
                                                guard tones.hasSuffix(textTones) else { return nil }
                                                let isCorrectPosition: Bool = text.dropFirst(item.inputCount).first?.isCantoneseToneDigit ?? false
                                                guard isCorrectPosition else { return nil }
                                                return item.replacedInput(with: inputText)
                                        } else {
                                                guard tones.hasPrefix(textTones) else { return nil }
                                                let combinedInput = item.input + toneInput
                                                return item.replacedInput(with: combinedInput)
                                        }
                                case (2, 1):
                                        guard textTones.hasPrefix(tones) else { return nil }
                                        let isCorrectPosition: Bool = text.dropFirst(item.inputCount).first?.isCantoneseToneDigit ?? false
                                        guard isCorrectPosition else { return nil }
                                        var firstSyllableEvents: [VirtualInputKey] = []
                                        for event in events {
                                                if event.isSyllableLetter {
                                                        firstSyllableEvents.append(event)
                                                } else {
                                                        break
                                                }
                                        }
                                        var firstToneEvents: [VirtualInputKey] = []
                                        for event in events.dropFirst(firstSyllableEvents.count) {
                                                if event.isSyllableLetter.negative {
                                                        firstToneEvents.append(event)
                                                } else {
                                                        break
                                                }
                                        }
                                        let combinedInput: String = (firstSyllableEvents + firstToneEvents).map(\.text).joined()
                                        return item.replacedInput(with: combinedInput)
                                case (2, 2):
                                        guard textTones == tones else { return nil }
                                        let isToneLast: Bool = text.last?.isCantoneseToneDigit ?? false
                                        if isToneLast {
                                                guard item.inputCount == (text.count - 2) else { return nil }
                                                return item.replacedInput(with: inputText)
                                        } else {
                                                let tail = text.dropFirst(item.inputCount + 1)
                                                let isCorrectPosition: Bool = (tail.first == textTones.last)
                                                guard isCorrectPosition else { return nil }
                                                let combinedInput = item.input + toneInput
                                                return item.replacedInput(with: combinedInput)
                                        }
                                default:
                                        guard inputText.hasPrefix(syllableText).negative else { return item.replacedInput(with: syllableText) }
                                        return nil
                                }
                        })
                        return qualified.sorted(by: { $0.inputCount > $1.inputCount })
                case (true, false):
                        let isHeadingSeparator: Bool = events.first?.isApostrophe ?? false
                        let isTrailingSeparator: Bool = events.last?.isApostrophe ?? false
                        guard isHeadingSeparator.negative else { return [] }
                        let inputSeparatorCount = events.count(where: \.isApostrophe)
                        let eventLength = events.count
                        let text = events.map(\.text).joined()
                        let textParts = text.split(separator: Character.apostrophe)
                        let qualified: [Candidate] = candidates.compactMap({ item -> Candidate? in
                                let syllables = item.romanization.removedTones().split(separator: Character.space)
                                guard syllables != textParts else { return item.replacedInput(with: text) }
                                switch inputSeparatorCount {
                                case 1 where isTrailingSeparator:
                                        guard syllables.count == 1 else { return nil }
                                        guard item.inputCount == (eventLength - 1) else { return nil }
                                        return item.replacedInput(with: text)
                                case 1:
                                        switch syllables.count {
                                        case 1:
                                                guard item.inputCount == textParts.first?.count else { return nil }
                                                let combinedInput: String = item.input + String.apostrophe
                                                return item.replacedInput(with: combinedInput)
                                        case 2:
                                                let isMatched: Bool = {
                                                        guard eventLength != 3 else { return true }
                                                        guard syllables.first != textParts.first else { return true }
                                                        guard textParts.first?.count == 1 else { return false }
                                                        guard textParts.first?.first == syllables.first?.first else { return false }
                                                        guard let lastSyllable = syllables.last else { return false }
                                                        return textParts.last?.hasPrefix(lastSyllable) ?? false
                                                }()
                                                guard isMatched else { return nil }
                                                let combinedInput: String = item.input + String.apostrophe
                                                return item.replacedInput(with: combinedInput)
                                        default:
                                                return nil
                                        }
                                case 2 where isTrailingSeparator:
                                        switch syllables.count {
                                        case 1:
                                                guard item.inputCount == textParts.first?.count else { return nil }
                                                let combinedInput: String = item.input + String.apostrophe
                                                return item.replacedInput(with: combinedInput)
                                        case 2:
                                                guard item.inputCount == (eventLength - 2) else { return nil }
                                                let isMatched: Bool = {
                                                        guard eventLength != 4 else { return true }
                                                        guard syllables.first != textParts.first else { return true }
                                                        guard textParts.first?.count == 1 else { return false }
                                                        guard textParts.first?.first == syllables.first?.first else { return false }
                                                        return textParts.last == syllables.last
                                                }()
                                                guard isMatched else { return nil }
                                                return item.replacedInput(with: text)
                                        default:
                                                return nil
                                        }
                                case 2 where eventLength == 5 && textParts.count == 3,
                                     3 where eventLength == 6 && textParts.count == 3:
                                        switch syllables.count {
                                        case 1:
                                                guard item.inputCount == 1 else { return nil }
                                                return item.replacedInput(with: item.input + String.apostrophe)
                                        case 2:
                                                guard item.inputCount == 2 else { return nil }
                                                let combinedInput: String = item.input + String.apostrophe + String.apostrophe
                                                return item.replacedInput(with: combinedInput)
                                        case 3:
                                                return item.replacedInput(with: text)
                                        default:
                                                return nil
                                        }
                                default:
                                        let textPartCount = textParts.count
                                        let syllableCount = syllables.count
                                        guard syllableCount < textPartCount else { return nil }
                                        let checks = (0..<syllableCount).map { index -> Bool in
                                                return syllables[index] == textParts[index]
                                        }
                                        let isMatched = checks.reduce(true, { $0 && $1 })
                                        guard isMatched else { return nil }
                                        let separatorCount = syllableCount - 1
                                        let tail: [Character] = Array(repeating: "i", count: separatorCount)
                                        let combinedInput: String = item.input + tail
                                        return item.replacedInput(with: combinedInput)
                                }
                        })
                        guard qualified.isEmpty else { return qualified.sorted(by: { $0.inputCount > $1.inputCount }) }
                        let anchorEvents = events.split(separator: VirtualInputKey.apostrophe).compactMap(\.first)
                        let anchorCount = anchorEvents.count
                        return anchorsMatch(events: anchorEvents, statement: anchorsStatement)
                                .compactMap({ item -> Candidate? in
                                        let syllables = item.romanization.split(separator: Character.space).map({ $0.dropLast() })
                                        guard syllables.count == anchorCount else { return nil }
                                        let checks = (0..<anchorCount).map({ index -> Bool in
                                                let part = textParts[index]
                                                let isAnchorOnly = part.count == 1
                                                return isAnchorOnly ? syllables[index].hasPrefix(part) : (syllables[index] == part)
                                        })
                                        guard checks.reduce(true, { $0 && $1 }) else { return nil }
                                        return item.replacedInput(with: text)
                                })
                }
        }

        private static func processSlices<T: RandomAccessCollection<VirtualInputKey>>(of events: T, text: String, limit: Int64? = nil, anchorsStatement: OpaquePointer?, spellStatement: OpaquePointer?) -> [Candidate] {
                let adjustedLimit: Int64 = (limit == nil) ? 300 : 100
                let eventLength: Int = events.count
                return (0..<eventLength).flatMap({ number -> [Candidate] in
                        let leadingEvents = events.dropLast(number)
                        let leadingText = leadingEvents.map(\.text).joined()
                        let spellMatched = spellMatch(text: leadingText, input: leadingText, limit: limit, statement: spellStatement)
                                .map({ modify($0, events: events, text: text, eventLength: eventLength) })
                        let anchorsMatched = anchorsMatch(events: leadingEvents, input: leadingText, limit: adjustedLimit, statement: anchorsStatement)
                                .map({ modify($0, events: events, text: text, eventLength: eventLength) })
                                .sorted()
                                .prefix(72)
                        return spellMatched + anchorsMatched
                })
                .distinct()
                .sorted()
        }
        private static func modify<T: RandomAccessCollection<VirtualInputKey>>(_ item: Candidate, events: T, text: String, eventLength: Int) -> Candidate {
                guard eventLength > 1 else { return item }
                guard item.inputCount != eventLength else { return item }
                lazy var converted: Candidate = Candidate(text: item.text, romanization: item.romanization, input: text, mark: text, order: item.order)
                guard item.romanization.removedSpacesTones().hasPrefix(text).negative else { return converted }
                guard let lastSyllable = item.romanization.split(separator: Character.space).last?.filter(\.isCantoneseToneDigit.negative) else { return item }
                let tail = events.dropFirst(item.inputCount - 1)
                guard tail.count <= 6 else { return item }
                if let tailSyllable = Segmenter.syllableText(of: tail) {
                        return lastSyllable == tailSyllable ? converted : item
                } else {
                        let tailText = tail.map(\.text).joined()
                        return lastSyllable.hasPrefix(tailText) ? converted : item
                }
        }

        private static func search<T: RandomAccessCollection<VirtualInputKey>>(events: T, segmentation: Segmentation, limit: Int64? = nil, anchorsStatement: OpaquePointer?, spellStatement: OpaquePointer?, strictStatement: OpaquePointer?) -> [Candidate] {
                let eventLength: Int = events.count
                let text: String = events.map(\.text).joined()
                let spellMatched = spellMatch(text: text, input: text, limit: limit, statement: spellStatement)
                let anchorsMatched = anchorsMatch(events: events, input: text, limit: limit, statement: anchorsStatement)
                let queried = query(inputLength: eventLength, segmentation: segmentation, limit: limit, strictStatement: strictStatement)
                let shouldMatchPrefixes: Bool = {
                        guard eventLength > 2 else { return false }
                        guard spellMatched.isEmpty else { return false }
                        guard queried.contains(where: { $0.inputCount == eventLength }).negative else { return false }
                        guard (events.last != .letterM) && (events.first != .letterM) else { return true }
                        return segmentation.contains(where: { $0.length == eventLength }).negative
                }()
                let prefixesLimit: Int64 = (limit == nil) ? 500 : 200
                let prefixMatched: [Candidate] = shouldMatchPrefixes.negative ? [] : segmentation.flatMap({ scheme -> [Candidate] in
                        guard scheme.isNotEmpty else { return [] }
                        let tail = events.dropFirst(scheme.length)
                        guard let lastAnchor = tail.first else { return [] }
                        let schemeAnchors = scheme.aliasAnchors
                        let conjoined = schemeAnchors + tail
                        let anchors = schemeAnchors + [lastAnchor]
                        let schemeSyllableText: String = scheme.syllableText
                        let mark: String = scheme.mark + String.space + tail.map(\.text).joined()
                        let tailAsAnchorText = tail.compactMap({ $0 == VirtualInputKey.letterY ? VirtualInputKey.letterJ.text.first : $0.text.first })
                        let conjoinedMatched = anchorsMatch(events: conjoined, limit: prefixesLimit, statement: anchorsStatement)
                                .compactMap({ item -> Candidate? in
                                        let toneFreeRomanization = item.romanization.removedTones()
                                        guard toneFreeRomanization.hasPrefix(schemeSyllableText) else { return nil }
                                        let suffixAnchorText = toneFreeRomanization.dropFirst(schemeSyllableText.count).split(separator: Character.space).compactMap(\.first)
                                        guard suffixAnchorText == tailAsAnchorText else { return nil }
                                        return Candidate(text: item.text, romanization: item.romanization, input: text, mark: mark, order: item.order)
                                })
                        let transformedTailText = tail.enumerated().map({ $0.offset == 0 && $0.element == VirtualInputKey.letterY ? VirtualInputKey.letterJ.text : $0.element.text }).joined()
                        let syllables: String = schemeSyllableText + String.space + transformedTailText
                        let anchorsMatched = anchorsMatch(events: anchors, limit: prefixesLimit, statement: anchorsStatement)
                                .compactMap({ item -> Candidate? in
                                        guard item.romanization.removedTones().hasPrefix(syllables) else { return nil }
                                        return Candidate(text: item.text, romanization: item.romanization, input: text, mark: mark, order: item.order)
                                })
                        return conjoinedMatched + anchorsMatched
                })
                let gainedMatched: [Candidate] = shouldMatchPrefixes.negative ? [] : (1..<eventLength).reversed().flatMap({ number -> [Candidate] in
                        let leadingEvents = events.prefix(number)
                        let leadingText = leadingEvents.map(\.text).joined()
                        return anchorsMatch(events: leadingEvents, input: leadingText, limit: 300, statement: anchorsStatement)
                }).compactMap({ item -> Candidate? in
                        // TODO: Cache tails and syllables ?
                        let tail = events.dropFirst(item.inputCount - 1)
                        guard tail.count <= 6 else { return nil }
                        lazy var converted: Candidate = Candidate(text: item.text, romanization: item.romanization, input: text, mark: text, order: item.order)
                        guard item.romanization.removedSpacesTones().hasPrefix(text).negative else { return converted }
                        guard let lastSyllable = item.romanization.split(separator: Character.space).last?.filter(\.isCantoneseToneDigit.negative) else { return nil }
                        if let tailSyllable = Segmenter.syllableText(of: tail) {
                                return lastSyllable == tailSyllable ? converted : nil
                        } else {
                                let tailText = tail.map(\.text).joined()
                                return lastSyllable.hasPrefix(tailText) ? converted : nil
                        }
                })
                let fetched: [Candidate] = {
                        let idealQueried = queried.filter({ $0.inputCount == eventLength }).sorted(by: { $0.order < $1.order }).distinct()
                        let notIdealQueried = queried.filter({ $0.inputCount < eventLength }).sorted().distinct()
                        let fullInput = (spellMatched + idealQueried + anchorsMatched + prefixMatched + gainedMatched).distinct()
                        let primary = fullInput.prefix(10)
                        let secondary = fullInput.sorted().prefix(10)
                        let tertiary = notIdealQueried.prefix(10)
                        let quaternary = notIdealQueried.sorted(by: { $0.order < $1.order }).prefix(10)
                        return (primary + secondary + tertiary + quaternary + fullInput + notIdealQueried).distinct()
                }()
                guard let firstInputCount = fetched.first?.inputCount else {
                        return processSlices(of: events, text: text, limit: limit, anchorsStatement: anchorsStatement, spellStatement: spellStatement)
                }
                guard firstInputCount < eventLength else { return fetched }
                let headInputLengths = fetched.map(\.inputCount).distinct()
                let concatenated = headInputLengths.compactMap({ headLength -> Candidate? in
                        let tailEvents = events.dropFirst(headLength)
                        let tailSegmentation = Segmenter.segment(events: tailEvents)
                        guard let tailCandidate = search(events: tailEvents, segmentation: tailSegmentation, limit: 50, anchorsStatement: anchorsStatement, spellStatement: spellStatement, strictStatement: strictStatement).first else { return nil }
                        guard let headCandidate = fetched.first(where: { $0.inputCount == headLength }) else { return nil }
                        return headCandidate + tailCandidate
                }).distinct().sorted().prefix(1)
                return concatenated + fetched
        }
        private static func query(inputLength: Int, segmentation: Segmentation, limit: Int64? = nil, strictStatement: OpaquePointer?) -> [Candidate] {
                let idealSchemes = segmentation.filter({ $0.length == inputLength })
                if idealSchemes.isEmpty {
                        return segmentation.flatMap({ perform(scheme: $0, limit: limit, strictStatement: strictStatement) })
                } else {
                        return idealSchemes.flatMap({ scheme -> [Candidate] in
                                switch scheme.count {
                                case 0: return []
                                case 1: return perform(scheme: scheme, limit: limit, strictStatement: strictStatement)
                                default:
                                        return (1...scheme.count).reversed().map({ scheme.prefix($0) }).flatMap({ perform(scheme: $0, limit: limit, strictStatement: strictStatement) })
                                }
                        })
                }
        }
        private static func perform<T: RandomAccessCollection<Syllable>>(scheme: T, limit: Int64? = nil, strictStatement: OpaquePointer?) -> [Candidate] {
                let anchorsCode = scheme.aliasAnchors.anchorsCode
                guard anchorsCode > 0 else { return [] }
                let spellCode = scheme.originText.hashCode()
                return strictMatch(anchors: anchorsCode, spell: spellCode, input: scheme.aliasText, mark: scheme.mark, limit: limit, statement: strictStatement)
        }
}

extension Array where Element == Candidate {
        /// Sort Candidates for Qwerty and Triple-Stroke layouts
        func ordered(with textCount: Int) -> [Candidate] {
                let matched = filter({ $0.inputCount == textCount }).sorted(by: { $0.order < $1.order }).distinct()
                let others = filter({ $0.inputCount != textCount }).sorted().distinct()
                let primary = matched.prefix(15)
                let secondary = others.prefix(10)
                let tertiary = others.sorted(by: { $0.order < $1.order }).prefix(7)
                return (primary + secondary + tertiary + matched + others).distinct()
        }
}


// MARK: - SQLite Statement Preparing

// CREATE TABLE core_lexicon(word TEXT NOT NULL, romanization TEXT NOT NULL, anchors INTEGER NOT NULL, spell INTEGER NOT NULL, nine_key_anchors INTEGER NOT NULL, nine_key_code INTEGER NOT NULL);

private extension Engine {
        private static let anchorsQuery: String = "SELECT rowid, word, romanization FROM core_lexicon WHERE anchors = ? LIMIT ?;"
        static func prepareAnchorsStatement() -> OpaquePointer? {
                var statement: OpaquePointer?
                guard sqlite3_prepare_v2(database, anchorsQuery, -1, &statement, nil) == SQLITE_OK else { return nil }
                return statement
        }

        private static let spellQuery: String = "SELECT rowid, word, romanization FROM core_lexicon WHERE spell = ? LIMIT ?;"
        static func prepareSpellStatement() -> OpaquePointer? {
                var statement: OpaquePointer?
                guard sqlite3_prepare_v2(database, spellQuery, -1, &statement, nil) == SQLITE_OK else { return nil }
                return statement
        }

        private static let strictQuery: String = "SELECT rowid, word, romanization FROM core_lexicon WHERE spell = ? AND anchors = ? LIMIT ?;"
        static func prepareStrictStatement() -> OpaquePointer? {
                var statement: OpaquePointer?
                guard sqlite3_prepare_v2(database, strictQuery, -1, &statement, nil) == SQLITE_OK else { return nil }
                return statement
        }

        private static let nineKeyAnchorsQuery: String = "SELECT rowid, word, romanization FROM core_lexicon WHERE nine_key_anchors = ? LIMIT ?;"
        static func prepareNineKeyAnchorsStatement() -> OpaquePointer? {
                var statement: OpaquePointer?
                guard sqlite3_prepare_v2(database, nineKeyAnchorsQuery, -1, &statement, nil) == SQLITE_OK else { return nil }
                return statement
        }

        private static let nineKeyCodeQuery: String = "SELECT rowid, word, romanization FROM core_lexicon WHERE nine_key_code = ? LIMIT ?;"
        static func prepareNineKeyCodeStatement() -> OpaquePointer? {
                var statement: OpaquePointer?
                guard sqlite3_prepare_v2(database, nineKeyCodeQuery, -1, &statement, nil) == SQLITE_OK else { return nil }
                return statement
        }
}


// MARK: - SQLite Querying

private extension Engine {
        static func anchorsMatch<T: RandomAccessCollection<VirtualInputKey>>(events: T, input: String? = nil, limit: Int64? = nil, statement: OpaquePointer?) -> [Candidate] {
                let code = events.anchorsCode
                guard code > 0 else { return [] }
                sqlite3_reset(statement)
                sqlite3_bind_int64(statement, 1, Int64(code))
                sqlite3_bind_int64(statement, 2, (limit ?? 100))
                let text: String = input ?? events.map(\.text).joined()
                var candidates: [Candidate] = []
                while sqlite3_step(statement) == SQLITE_ROW {
                        let order: Int = Int(sqlite3_column_int64(statement, 0))
                        let word: String = String(cString: sqlite3_column_text(statement, 1))
                        let romanization: String = String(cString: sqlite3_column_text(statement, 2))
                        let candidate = Candidate(text: word, romanization: romanization, input: text, mark: text, order: order)
                        candidates.append(candidate)
                }
                return candidates
        }
        static func spellMatch<T: StringProtocol>(text: T, input: String, mark: String? = nil, limit: Int64? = nil, statement: OpaquePointer?) -> [Candidate] {
                sqlite3_reset(statement)
                sqlite3_bind_int64(statement, 1, Int64(text.hashCode()))
                sqlite3_bind_int64(statement, 2, (limit ?? -1))
                var candidates: [Candidate] = []
                while sqlite3_step(statement) == SQLITE_ROW {
                        let order: Int = Int(sqlite3_column_int64(statement, 0))
                        let word: String = String(cString: sqlite3_column_text(statement, 1))
                        let romanization: String = String(cString: sqlite3_column_text(statement, 2))
                        let mark: String = mark ?? romanization.removedTones()
                        let candidate = Candidate(text: word, romanization: romanization, input: input, mark: mark, order: order)
                        candidates.append(candidate)
                }
                return candidates
        }
        static func strictMatch(anchors: Int, spell: Int32, input: String, mark: String? = nil, limit: Int64? = nil, statement: OpaquePointer?) -> [Candidate] {
                sqlite3_reset(statement)
                sqlite3_bind_int64(statement, 1, Int64(spell))
                sqlite3_bind_int64(statement, 2, Int64(anchors))
                sqlite3_bind_int64(statement, 3, (limit ?? -1))
                var candidates: [Candidate] = []
                while sqlite3_step(statement) == SQLITE_ROW {
                        let order: Int = Int(sqlite3_column_int64(statement, 0))
                        let word: String = String(cString: sqlite3_column_text(statement, 1))
                        let romanization: String = String(cString: sqlite3_column_text(statement, 2))
                        let mark: String = mark ?? romanization.removedTones()
                        let candidate = Candidate(text: word, romanization: romanization, input: input, mark: mark, order: order)
                        candidates.append(candidate)
                }
                return candidates
        }
}


// MARK: - NineKey Suggestions

extension Engine {
        public static func nineKeySuggest<T: RandomAccessCollection<Combo>>(combos: T) async -> [Candidate] {
                lazy var anchorsStatement = prepareNineKeyAnchorsStatement()
                lazy var codeMatchStatement = prepareNineKeyCodeStatement()
                defer {
                        sqlite3_finalize(anchorsStatement)
                        sqlite3_finalize(codeMatchStatement)
                }
                return nineKeySearch(combos: combos, anchorsStatement: anchorsStatement, codeMatchStatement: codeMatchStatement)
        }
        private static func nineKeySearch<T: RandomAccessCollection<Combo>>(combos: T, limit: Int64? = nil, anchorsStatement: OpaquePointer?, codeMatchStatement: OpaquePointer?) -> [Candidate] {
                let inputLength: Int = combos.count
                let fullCode: Int = combos.map(\.code).decimalCombined()
                guard inputLength > 1 else {
                        return nineKeyCodeMatch(code: fullCode, limit: limit, statement: codeMatchStatement) + nineKeyAnchorsMatch(code: fullCode, limit: 100, statement: anchorsStatement)
                }
                let fullMatched: [Candidate] = nineKeyCodeMatch(code: fullCode, limit: limit, statement: codeMatchStatement)
                let idealAnchorsMatched: [Candidate] = nineKeyAnchorsMatch(code: fullCode, limit: 4, statement: anchorsStatement)
                let codeMatched: [Candidate] = (1..<inputLength)
                        .flatMap({ number -> [Candidate] in
                                let code = combos.dropLast(number).map(\.code).decimalCombined()
                                guard code > 0 else { return [] }
                                return nineKeyCodeMatch(code: code, limit: limit, statement: codeMatchStatement)
                        })
                let anchorsMatched: [Candidate] = (0..<inputLength)
                        .flatMap({ number -> [Candidate] in
                                let code = combos.dropLast(number).map(\.code).decimalCombined()
                                guard code > 0 else { return [] }
                                return nineKeyAnchorsMatch(code: code, limit: limit, statement: anchorsStatement)
                        })
                let queried = (fullMatched + idealAnchorsMatched + codeMatched + anchorsMatched)
                guard let firstInputCount = queried.first?.inputCount else { return [] }
                guard firstInputCount < inputLength else { return queried }
                let tailCombos = combos.dropFirst(firstInputCount)
                let tailCode = tailCombos.map(\.code).decimalCombined()
                guard tailCode > 0 else { return queried }
                let tailCandidates: [Candidate] = nineKeyCodeMatch(code: tailCode, limit: 20, statement: codeMatchStatement) + nineKeyAnchorsMatch(code: tailCode, limit: 20, statement: anchorsStatement)
                guard tailCandidates.isNotEmpty, let head = queried.first else { return queried }
                let concatenated = tailCandidates.compactMap({ head + $0 }).sorted().prefix(1)
                return concatenated + queried

                /*
                let headInputLengths = queried.map(\.inputCount).distinct()
                let concatenated = headInputLengths.compactMap({ headLength -> Candidate? in
                        let tailEvents = combos.dropFirst(headLength)
                        guard let tailCandidate = nineKeySearch(combos: tailEvents, limit: 10, anchorsStatement: anchorsStatement, codeMatchStatement: codeMatchStatement).first else { return nil }
                        guard let headCandidate = queried.first(where: { $0.inputCount == headLength }) else { return nil }
                        return headCandidate + tailCandidate
                }).distinct().sorted().prefix(1)
                return concatenated + queried
                */
        }
        private static func nineKeyAnchorsMatch(code: Int, limit: Int64? = nil, statement: OpaquePointer?) -> [Candidate] {
                guard code > 0 else { return [] }
                sqlite3_reset(statement)
                sqlite3_bind_int64(statement, 1, Int64(code))
                sqlite3_bind_int64(statement, 2, (limit ?? 30))
                var candidates: [Candidate] = []
                while sqlite3_step(statement) == SQLITE_ROW {
                        let order: Int = Int(sqlite3_column_int64(statement, 0))
                        let word: String = String(cString: sqlite3_column_text(statement, 1))
                        let romanization: String = String(cString: sqlite3_column_text(statement, 2))
                        let anchors = romanization.split(separator: Character.space).compactMap(\.first)
                        let anchorText = String(anchors)
                        let candidate = Candidate(text: word, romanization: romanization, input: anchorText, mark: anchorText, order: order)
                        candidates.append(candidate)
                }
                return candidates
        }
        private static func nineKeyCodeMatch(code: Int, limit: Int64? = nil, statement: OpaquePointer?) -> [Candidate] {
                guard code > 0 else { return [] }
                sqlite3_reset(statement)
                sqlite3_bind_int64(statement, 1, Int64(code))
                sqlite3_bind_int64(statement, 2, (limit ?? -1))
                var candidates: [Candidate] = []
                while sqlite3_step(statement) == SQLITE_ROW {
                        let order: Int = Int(sqlite3_column_int64(statement, 0))
                        let word: String = String(cString: sqlite3_column_text(statement, 1))
                        let romanization: String = String(cString: sqlite3_column_text(statement, 2))
                        let mark: String = romanization.removedTones()
                        let candidate = Candidate(text: word, romanization: romanization, input: mark.removedSpaces(), mark: mark, order: order)
                        candidates.append(candidate)
                }
                return candidates
        }
}
