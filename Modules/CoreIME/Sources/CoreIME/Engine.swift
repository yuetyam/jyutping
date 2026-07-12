import Foundation
import SQLite3
import CommonExtensions
import os.log

// MARK: - Preparing Databases

public struct Engine {

        static let logger = Logger(subsystem: "org.jyutping.Jyutping.CoreIME", category: "Engine")

        public static func prepare() {
                defer {
                        Segmenter.prepare()
                        PinyinSegmenter.prepare()
                }
                let statement = prepareAnchorsStatement()
                defer { sqlite3_finalize(statement) }
                let anchors: Int64 = 20
                let charCount: Int64 = 1
                let limit: Int64 = 1
                sqlite3_reset(statement)
                sqlite3_bind_int64(statement, 1, anchors)
                sqlite3_bind_int64(statement, 2, charCount)
                sqlite3_bind_int64(statement, 3, limit)
                if sqlite3_step(statement) == SQLITE_ROW {
                        logger.debug("Prepared primary database")
                } else {
                        logger.warning("Primary database is not ready")
                }
        }
        nonisolated(unsafe) static let database: OpaquePointer? = {
                guard let path: String = Bundle.module.path(forResource: "ime", ofType: "sqlite3") else { return nil }
                var db: OpaquePointer? = nil
                let flags = SQLITE_OPEN_READONLY | SQLITE_OPEN_FULLMUTEX
                if sqlite3_open_v2(path, &db, flags, nil) == SQLITE_OK {
                        logger.debug("Primary database connected")
                        return db
                } else {
                        sqlite3_close_v2(db)
                        logger.warning("Failed to connect primary database")
                        return nil
                }
        }()

        /// The missing SQLITE_TRANSIENT
        static let DEFINED_SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
}


// MARK: - Suggestions

extension Engine {
        public static func suggest<T: RandomAccessCollection<VirtualInputKey>>(_ keys: T, segmentation: Segmentation, deepSearch: Bool = true) -> [Lexicon] {
                switch keys.count {
                case 0: return []
                case 1:
                        switch keys.first {
                        case .letterA:
                                let anchorsStatement = prepareAnchorsStatement()
                                let spellStatement = prepareSpellStatement()
                                defer {
                                        sqlite3_finalize(anchorsStatement)
                                        sqlite3_finalize(spellStatement)
                                }
                                let altKeys = [VirtualInputKey.letterA, VirtualInputKey.letterA]
                                let input = VirtualInputKey.letterA.text
                                return spellMatch(keys: keys, input: input, statement: spellStatement) + spellMatch(keys: altKeys, input: input, statement: spellStatement) + anchorsMatch(keys: keys, input: input, statement: anchorsStatement)
                        case .letterO, .letterM:
                                guard let key = keys.first else { return [] }
                                let anchorsStatement = prepareAnchorsStatement()
                                let spellStatement = prepareSpellStatement()
                                defer {
                                        sqlite3_finalize(anchorsStatement)
                                        sqlite3_finalize(spellStatement)
                                }
                                let input = key.text
                                return spellMatch(keys: keys, input: input, statement: spellStatement) + anchorsMatch(keys: keys, input: input, statement: anchorsStatement)
                        default:
                                let anchorsStatement = prepareAnchorsStatement()
                                defer { sqlite3_finalize(anchorsStatement) }
                                return anchorsMatch(keys: keys, statement: anchorsStatement)
                        }
                default:
                        let anchorsStatement = prepareAnchorsStatement()
                        let spellStatement = prepareSpellStatement()
                        defer {
                                sqlite3_finalize(anchorsStatement)
                                sqlite3_finalize(spellStatement)
                        }
                        return dispatch(keys, segmentation: segmentation, deepSearch: deepSearch, anchorsStatement: anchorsStatement, spellStatement: spellStatement)
                }
        }

        private static func dispatch<T: RandomAccessCollection<VirtualInputKey>>(_ keys: T, segmentation: Segmentation, deepSearch: Bool, anchorsStatement: OpaquePointer?, spellStatement: OpaquePointer?) -> [Lexicon] {
                let syllableKeys = keys.filter(\.isSyllableLetter)
                let lexicons: [Lexicon] = switch (segmentation.first?.first?.alias.count ?? 0) {
                case 0 where deepSearch:
                        processSlices(of: syllableKeys, text: syllableKeys.map(\.text).joined(), anchorsStatement: anchorsStatement, spellStatement: spellStatement)
                case 0:
                        anchorsMatch(keys: syllableKeys, input: syllableKeys.map(\.text).joined(), statement: anchorsStatement)
                case 1 where syllableKeys.count > 1,
                        _ where syllableKeys.count != keys.count :
                        search(syllableKeys, segmentation: segmentation, deepSearch: deepSearch, anchorsStatement: anchorsStatement, spellStatement: spellStatement) + processSlices(of: syllableKeys, text: syllableKeys.map(\.text).joined(), anchorsStatement: anchorsStatement, spellStatement: spellStatement)
                default:
                        search(syllableKeys, segmentation: segmentation, deepSearch: deepSearch, anchorsStatement: anchorsStatement, spellStatement: spellStatement)
                }
                switch (keys.contains(where: \.isApostrophe), keys.contains(where: \.isToneInputKey)) {
                case (false, false):
                        return lexicons
                case (true, true):
                        let inputText = keys.map(\.text).joined()
                        let text = inputText.toneConverted()
                        return lexicons.compactMap({ item -> Lexicon? in
                                guard text.hasPrefix(item.romanization) else { return nil }
                                return item.replacedInput(with: inputText)
                        })
                case (false, true):
                        let inputText = keys.map(\.text).joined()
                        let toneInput = keys.filter(\.isSyllableLetter.negative).map(\.text).joined()
                        let text = inputText.toneConverted()
                        let textTones = text.toneDigitOnly()
                        let qualified: [Lexicon] = lexicons.compactMap({ item -> Lexicon? in
                                let syllableText = item.romanization.strippedSpaces()
                                guard syllableText.hasPrefix(text).negative else { return item.replacedInput(with: inputText) }
                                let tones = syllableText.toneDigitOnly()
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
                                        var leadingKeys: [VirtualInputKey] = []
                                        for key in keys {
                                                if key.isSyllableLetter {
                                                        leadingKeys.append(key)
                                                } else {
                                                        break
                                                }
                                        }
                                        for key in keys.dropFirst(leadingKeys.count) {
                                                if key.isSyllableLetter.negative {
                                                        leadingKeys.append(key)
                                                } else {
                                                        break
                                                }
                                        }
                                        return item.replacedInput(with: leadingKeys.map(\.text).joined())
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
                        let isHeadingSeparator: Bool = keys.first?.isApostrophe ?? false
                        let isTrailingSeparator: Bool = keys.last?.isApostrophe ?? false
                        guard isHeadingSeparator.negative else { return [] }
                        let inputSeparatorCount = keys.count(where: \.isApostrophe)
                        let inputLength = keys.count
                        let text = keys.map(\.text).joined()
                        let textParts = text.split(separator: Character.apostrophe)
                        let qualified: [Lexicon] = lexicons.compactMap({ item -> Lexicon? in
                                let syllables = item.romanization.strippedTones().split(separator: Character.space)
                                guard syllables != textParts else { return item.replacedInput(with: text) }
                                switch inputSeparatorCount {
                                case 1 where isTrailingSeparator:
                                        guard syllables.count == 1 else { return nil }
                                        guard item.inputCount == (inputLength - 1) else { return nil }
                                        return item.replacedInput(with: text)
                                case 1:
                                        switch syllables.count {
                                        case 1:
                                                guard item.inputCount == textParts.first?.count else { return nil }
                                                let combinedInput: String = item.input + String.apostrophe
                                                return item.replacedInput(with: combinedInput)
                                        case 2:
                                                let isMatched: Bool = {
                                                        guard inputLength != 3 else { return true }
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
                                                guard item.inputCount == (inputLength - 2) else { return nil }
                                                let isMatched: Bool = {
                                                        guard inputLength != 4 else { return true }
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
                                case 2 where inputLength == 5 && textParts.count == 3,
                                     3 where inputLength == 6 && textParts.count == 3:
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
                                        let isMatched = (0..<syllableCount).allSatisfy({ syllables[$0] == textParts[$0] })
                                        guard isMatched else { return nil }
                                        let separatorCount = syllableCount - 1
                                        let tail = String(repeating: "i", count: separatorCount)
                                        let combinedInput: String = item.input + tail
                                        return item.replacedInput(with: combinedInput)
                                }
                        })
                        guard qualified.isEmpty else { return qualified.sorted(by: { $0.inputCount > $1.inputCount }) }
                        let anchorKeys = keys.split(separator: VirtualInputKey.apostrophe).compactMap(\.first)
                        let anchorCount = anchorKeys.count
                        return anchorsMatch(keys: anchorKeys, statement: anchorsStatement)
                                .compactMap({ item -> Lexicon? in
                                        let syllables = item.romanization.split(separator: Character.space).map({ $0.dropLast() })
                                        guard syllables.count == anchorCount else { return nil }
                                        let isMatched = (0..<anchorCount).allSatisfy({ index -> Bool in
                                                let part = textParts[index]
                                                let isAnchorOnly = (part.count == 1)
                                                return isAnchorOnly ? syllables[index].hasPrefix(part) : (syllables[index] == part)
                                        })
                                        guard isMatched else { return nil }
                                        return item.replacedInput(with: text)
                                })
                }
        }

        private static func processSlices<T: RandomAccessCollection<VirtualInputKey>>(of keys: T, text: String, limit: Int64? = nil, anchorsStatement: OpaquePointer?, spellStatement: OpaquePointer?) -> [Lexicon] {
                let adjustedLimit: Int64 = (limit == nil) ? 300 : 100
                let inputLength: Int = keys.count
                return (0..<inputLength).flatMap({ number -> [Lexicon] in
                        let leadingKeys = keys.dropLast(number)
                        let leadingText = leadingKeys.map(\.text).joined()
                        let spellMatched = spellMatch(keys: leadingKeys, input: leadingText, limit: limit, statement: spellStatement)
                                .map({ modify($0, keys: keys, text: text, inputLength: inputLength) })
                        let anchorsMatched = anchorsMatch(keys: leadingKeys, input: leadingText, limit: adjustedLimit, statement: anchorsStatement)
                                .map({ modify($0, keys: keys, text: text, inputLength: inputLength) })
                                .sorted()
                                .prefix(72)
                        return spellMatched + anchorsMatched
                })
                .distinct()
                .sorted()
        }
        private static func modify<T: RandomAccessCollection<VirtualInputKey>>(_ item: Lexicon, keys: T, text: String, inputLength: Int) -> Lexicon {
                guard inputLength > 1 else { return item }
                guard item.inputCount != inputLength else { return item }
                lazy var converted: Lexicon = Lexicon(text: item.text, romanization: item.romanization, input: text, mark: text, number: item.number)
                guard item.romanization.latinLetterOnly().hasPrefix(text).negative else { return converted }
                guard let lastSyllable = item.romanization.split(separator: Character.space).last?.filter(\.isCantoneseToneDigit.negative) else { return item }
                let tail = keys.dropFirst(item.inputCount - 1)
                guard tail.count <= 6 else { return item }
                if let tailSyllable = Segmenter.syllableText(of: tail) {
                        return lastSyllable == tailSyllable ? converted : item
                } else {
                        let tailText = tail.map(\.text).joined()
                        return lastSyllable.hasPrefix(tailText) ? converted : item
                }
        }

        private static func search<T: RandomAccessCollection<VirtualInputKey>>(_ keys: T, segmentation: Segmentation, limit: Int64? = nil, deepSearch: Bool, anchorsStatement: OpaquePointer?, spellStatement: OpaquePointer?) -> [Lexicon] {
                let inputLength: Int = keys.count
                let text: String = keys.map(\.text).joined()
                let spellMatched = spellMatch(keys: keys, input: text, limit: limit, statement: spellStatement)
                let anchorsMatched = anchorsMatch(keys: keys, input: text, limit: limit, statement: anchorsStatement)
                let queried = query(inputLength: inputLength, segmentation: segmentation, limit: limit, spellStatement: spellStatement)
                let shouldMatchPrefixes: Bool = {
                        guard deepSearch else { return false }
                        guard (inputLength > 2 && inputLength < 25) else { return false }
                        guard (keys.last != .letterM) && (keys.first != .letterM) else { return true }
                        guard spellMatched.isEmpty else { return false }
                        guard queried.contains(where: { $0.inputCount == inputLength }).negative else { return false }
                        return segmentation.contains(where: { $0.length == inputLength }).negative
                }()
                let prefixesLimit: Int64 = (limit == nil) ? 500 : 200
                let prefixMatched: [Lexicon] = shouldMatchPrefixes.negative ? [] : segmentation.flatMap({ scheme -> [Lexicon] in
                        guard scheme.isNotEmpty else { return [] }
                        let tail = keys.dropFirst(scheme.length)
                        guard let lastAnchor = tail.first else { return [] }
                        let schemeAnchors = scheme.aliasAnchors
                        let conjoined = schemeAnchors + tail
                        let anchors = schemeAnchors + [lastAnchor]
                        let schemeSyllableText: String = scheme.syllableText
                        let mark: String = scheme.mark + String.space + tail.map(\.text).joined()
                        let tailAsAnchorText = tail.compactMap({ $0.isYLetterY ? VirtualInputKey.letterJ.text.first : $0.text.first })
                        let conjoinedMatched = anchorsMatch(keys: conjoined, limit: prefixesLimit, statement: anchorsStatement)
                                .compactMap({ item -> Lexicon? in
                                        let toneFreeRomanization = item.romanization.strippedTones()
                                        guard toneFreeRomanization.hasPrefix(schemeSyllableText) else { return nil }
                                        let suffixAnchorText = toneFreeRomanization.dropFirst(schemeSyllableText.count).split(separator: Character.space).compactMap(\.first)
                                        guard suffixAnchorText == tailAsAnchorText else { return nil }
                                        return Lexicon(text: item.text, romanization: item.romanization, input: text, mark: mark, number: item.number)
                                })
                        let transformedTailText = tail.enumerated().map({ $0.offset == 0 && $0.element.isYLetterY ? VirtualInputKey.letterJ.text : $0.element.text }).joined()
                        let syllables: String = schemeSyllableText + String.space + transformedTailText
                        let anchorsMatched = anchorsMatch(keys: anchors, limit: prefixesLimit, statement: anchorsStatement)
                                .compactMap({ item -> Lexicon? in
                                        guard item.romanization.strippedTones().hasPrefix(syllables) else { return nil }
                                        return Lexicon(text: item.text, romanization: item.romanization, input: text, mark: mark, number: item.number)
                                })
                        return conjoinedMatched + anchorsMatched
                })
                let gainedMatched: [Lexicon] = shouldMatchPrefixes.negative ? [] : (1..<inputLength).reversed().flatMap({ number -> [Lexicon] in
                        let leadingKeys = keys.prefix(number)
                        let leadingText = leadingKeys.map(\.text).joined()
                        return anchorsMatch(keys: leadingKeys, input: leadingText, limit: 300, statement: anchorsStatement)
                }).compactMap({ item -> Lexicon? in
                        // TODO: Cache tails and syllables ?
                        let tail = keys.dropFirst(item.inputCount - 1)
                        guard tail.count <= 6 else { return nil }
                        lazy var converted: Lexicon = Lexicon(text: item.text, romanization: item.romanization, input: text, mark: text, number: item.number)
                        guard item.romanization.latinLetterOnly().hasPrefix(text).negative else { return converted }
                        guard let lastSyllable = item.romanization.split(separator: Character.space).last?.filter(\.isCantoneseToneDigit.negative) else { return nil }
                        if let tailSyllable = Segmenter.syllableText(of: tail) {
                                return lastSyllable == tailSyllable ? converted : nil
                        } else {
                                let tailText = tail.map(\.text).joined()
                                return lastSyllable.hasPrefix(tailText) ? converted : nil
                        }
                })
                let fetched: [Lexicon] = {
                        let idealQueried = queried.filter({ $0.inputCount == inputLength }).sorted(by: { $0.number < $1.number }).distinct()
                        let notIdealQueried = queried.filter({ $0.inputCount < inputLength }).sorted().distinct()
                        let fullInput = (spellMatched + idealQueried + anchorsMatched + prefixMatched + gainedMatched).distinct()
                        let primary = fullInput.prefix(10)
                        let secondary = fullInput.sorted().prefix(10)
                        let tertiary = notIdealQueried.prefix(10)
                        let quaternary = notIdealQueried.sorted(by: { $0.number < $1.number }).prefix(10)
                        return (primary + secondary + tertiary + quaternary + fullInput + notIdealQueried).distinct()
                }()
                guard let firstInputCount = fetched.first?.inputCount else {
                        if deepSearch {
                                return processSlices(of: keys, text: text, limit: limit, anchorsStatement: anchorsStatement, spellStatement: spellStatement)
                        } else {
                                return anchorsMatch(keys: keys, input: text, limit: limit, statement: anchorsStatement)
                        }
                }
                guard firstInputCount < inputLength else { return fetched }
                guard deepSearch else { return fetched }
                let headInputLengths = fetched.map(\.inputCount).distinct()
                let concatenated = headInputLengths.compactMap({ headLength -> Lexicon? in
                        let tailKeys = keys.dropFirst(headLength)
                        let tailSegmentation = Segmenter.segment(tailKeys)
                        guard let tailLexicon = search(tailKeys, segmentation: tailSegmentation, limit: 50, deepSearch: deepSearch, anchorsStatement: anchorsStatement, spellStatement: spellStatement).first else { return nil }
                        guard let headLexicon = fetched.first(where: { $0.inputCount == headLength }) else { return nil }
                        return headLexicon + tailLexicon
                }).distinct().sorted().prefix(1)
                return concatenated + fetched
        }
        private static func query(inputLength: Int, segmentation: Segmentation, limit: Int64? = nil, spellStatement: OpaquePointer?) -> [Lexicon] {
                let idealSchemes = segmentation.filter({ $0.length == inputLength })
                if idealSchemes.isEmpty {
                        return segmentation.flatMap({ perform(scheme: $0, limit: limit, spellStatement: spellStatement) })
                } else {
                        return idealSchemes.flatMap({ scheme -> [Lexicon] in
                                switch scheme.count {
                                case 0: return []
                                case 1: return perform(scheme: scheme, limit: limit, spellStatement: spellStatement)
                                default:
                                        return (1...scheme.count).reversed().map({ scheme.prefix($0) }).flatMap({ perform(scheme: $0, limit: limit, spellStatement: spellStatement) })
                                }
                        })
                }
        }
        private static func perform<T: RandomAccessCollection<Syllable>>(scheme: T, limit: Int64? = nil, spellStatement: OpaquePointer?) -> [Lexicon] {
                let keys = scheme.flatMap(\.origin)
                return spellMatch(keys: keys, input: scheme.aliasText, mark: scheme.mark, limit: limit, statement: spellStatement)
        }
}


// MARK: - SQLite Statement Preparing

// CREATE TABLE core_lexicon(word TEXT NOT NULL, romanization TEXT NOT NULL, anchors INTEGER NOT NULL, spell INTEGER NOT NULL, nine_key_anchors INTEGER NOT NULL, nine_key_code INTEGER NOT NULL);

private extension Engine {
        private static let anchorsQuery: String = "SELECT rowid, word, romanization FROM core_lexicon WHERE anchors = ? AND char_count = ? ORDER BY rowid LIMIT ?;"
        static func prepareAnchorsStatement() -> OpaquePointer? {
                var statement: OpaquePointer?
                guard sqlite3_prepare_v2(database, anchorsQuery, -1, &statement, nil) == SQLITE_OK else { return nil }
                return statement
        }

        private static let spellQuery: String = "SELECT rowid, word, romanization FROM core_lexicon WHERE spell = ? AND complex = ? ORDER BY rowid LIMIT ?;"
        static func prepareSpellStatement() -> OpaquePointer? {
                var statement: OpaquePointer?
                guard sqlite3_prepare_v2(database, spellQuery, -1, &statement, nil) == SQLITE_OK else { return nil }
                return statement
        }

        private static let nineKeyAnchorsQuery: String = "SELECT rowid, word, romanization FROM core_lexicon WHERE nine_key_anchors = ? AND char_count = ? ORDER BY rowid LIMIT ?;"
        static func prepareNineKeyAnchorsStatement() -> OpaquePointer? {
                var statement: OpaquePointer?
                guard sqlite3_prepare_v2(database, nineKeyAnchorsQuery, -1, &statement, nil) == SQLITE_OK else { return nil }
                return statement
        }

        private static let nineKeyCodeQuery: String = "SELECT rowid, word, romanization FROM core_lexicon WHERE nine_key_code = ? AND complex = ? ORDER BY rowid LIMIT ?;"
        static func prepareNineKeyCodeStatement() -> OpaquePointer? {
                var statement: OpaquePointer?
                guard sqlite3_prepare_v2(database, nineKeyCodeQuery, -1, &statement, nil) == SQLITE_OK else { return nil }
                return statement
        }
}


// MARK: - SQLite Querying

private extension Engine {
        static func anchorsMatch<T: RandomAccessCollection<VirtualInputKey>>(keys: T, input: String? = nil, limit: Int64? = nil, statement: OpaquePointer?) -> [Lexicon] {
                sqlite3_reset(statement)
                let anchorsCode: Int64 = keys.anchorNormalized.conjoinedCode.toInt64()
                let charCount: Int64 = keys.count.toInt64()
                let limit: Int64 = limit ?? 100
                sqlite3_bind_int64(statement, 1, anchorsCode)
                sqlite3_bind_int64(statement, 2, charCount)
                sqlite3_bind_int64(statement, 3, limit)
                let input: String = input ?? keys.map(\.text).joined()
                var items: [Lexicon] = []
                while sqlite3_step(statement) == SQLITE_ROW {
                        let number: Int = Int(sqlite3_column_int64(statement, 0))
                        let word: String = String(cString: sqlite3_column_text(statement, 1))
                        let romanization: String = String(cString: sqlite3_column_text(statement, 2))
                        let instance = Lexicon(text: word, romanization: romanization, input: input, mark: input, number: number)
                        items.append(instance)
                }
                return items
        }
        static func spellMatch<T: RandomAccessCollection<VirtualInputKey>>(keys: T, input: String? = nil, mark: String? = nil, limit: Int64? = nil, statement: OpaquePointer?) -> [Lexicon] {
                sqlite3_reset(statement)
                let spell: Int64 = keys.conjoinedCode.toInt64()
                let complex: Int64 = keys.count.toInt64()
                let limit: Int64 = limit ?? -1
                sqlite3_bind_int64(statement, 1, spell)
                sqlite3_bind_int64(statement, 2, complex)
                sqlite3_bind_int64(statement, 3, limit)
                let input: String = input ?? keys.map(\.text).joined()
                var items: [Lexicon] = []
                while sqlite3_step(statement) == SQLITE_ROW {
                        let number: Int = Int(sqlite3_column_int64(statement, 0))
                        let word: String = String(cString: sqlite3_column_text(statement, 1))
                        let romanization: String = String(cString: sqlite3_column_text(statement, 2))
                        let mark: String = mark ?? romanization.strippedTones()
                        let instance = Lexicon(text: word, romanization: romanization, input: input, mark: mark, number: number)
                        items.append(instance)
                }
                return items
        }
}


// MARK: - NineKey Suggestions

extension Engine {
        public static func nineKeySuggest<T: RandomAccessCollection<Combo>>(combos: T) async -> [Lexicon] {
                lazy var anchorsStatement = prepareNineKeyAnchorsStatement()
                lazy var codeMatchStatement = prepareNineKeyCodeStatement()
                defer {
                        sqlite3_finalize(anchorsStatement)
                        sqlite3_finalize(codeMatchStatement)
                }
                return nineKeySearch(combos: combos, anchorsStatement: anchorsStatement, codeMatchStatement: codeMatchStatement)
        }
        private static func nineKeySearch<T: RandomAccessCollection<Combo>>(combos: T, limit: Int64? = nil, anchorsStatement: OpaquePointer?, codeMatchStatement: OpaquePointer?) -> [Lexicon] {
                let inputLength: Int = combos.count
                let fullCode: Int = combos.decimalCombinedCode
                guard inputLength > 1 else {
                        return nineKeyCodeMatch(code: fullCode, complex: inputLength, limit: limit, statement: codeMatchStatement) + nineKeyAnchorsMatch(code: fullCode, charCount: inputLength, limit: 100, statement: anchorsStatement)
                }
                let fullMatched = nineKeyCodeMatch(code: fullCode, complex: inputLength, limit: limit, statement: codeMatchStatement)
                let idealAnchorsMatched = nineKeyAnchorsMatch(code: fullCode, charCount: inputLength, limit: 4, statement: anchorsStatement)
                let codeMatched: [Lexicon] = (1..<inputLength)
                        .flatMap({ number -> [Lexicon] in
                                let code = combos.dropLast(number).decimalCombinedCode
                                let complex = (inputLength - number)
                                return nineKeyCodeMatch(code: code, complex: complex, limit: limit, statement: codeMatchStatement)
                        })
                let anchorsMatched: [Lexicon] = (0..<inputLength)
                        .flatMap({ number -> [Lexicon] in
                                let code = combos.dropLast(number).decimalCombinedCode
                                let charCount = (inputLength - number)
                                return nineKeyAnchorsMatch(code: code, charCount: charCount, limit: limit, statement: anchorsStatement)
                        })
                let queried = (fullMatched + idealAnchorsMatched + codeMatched + anchorsMatched)
                guard let firstInputCount = queried.first?.inputCount else { return [] }
                guard firstInputCount < inputLength else { return queried }
                let tailLength = (inputLength - firstInputCount)
                let tailCode = combos.dropFirst(firstInputCount).decimalCombinedCode
                let tailLexicons = nineKeyCodeMatch(code: tailCode, complex: tailLength, limit: 20, statement: codeMatchStatement) + nineKeyAnchorsMatch(code: tailCode, charCount: tailLength, limit: 20, statement: anchorsStatement)
                guard tailLexicons.isNotEmpty, let head = queried.first else { return queried }
                let concatenated = tailLexicons.compactMap({ head + $0 }).sorted().prefix(1)
                return concatenated + queried
        }
        private static func nineKeyAnchorsMatch<T: BinaryInteger>(code: T, charCount: T, limit: Int64? = nil, statement: OpaquePointer?) -> [Lexicon] {
                sqlite3_reset(statement)
                sqlite3_bind_int64(statement, 1, code.toInt64())
                sqlite3_bind_int64(statement, 2, charCount.toInt64())
                sqlite3_bind_int64(statement, 3, (limit ?? 30))
                var items: [Lexicon] = []
                while sqlite3_step(statement) == SQLITE_ROW {
                        let rowID: Int = Int(sqlite3_column_int64(statement, 0))
                        let word: String = String(cString: sqlite3_column_text(statement, 1))
                        let romanization: String = String(cString: sqlite3_column_text(statement, 2))
                        let anchors = romanization.split(separator: Character.space).compactMap(\.first)
                        let anchorText = String(anchors)
                        let instance = Lexicon(text: word, romanization: romanization, input: anchorText, mark: anchorText, number: rowID)
                        items.append(instance)
                }
                return items
        }
        private static func nineKeyCodeMatch<T: BinaryInteger>(code: T, complex: T, limit: Int64? = nil, statement: OpaquePointer?) -> [Lexicon] {
                sqlite3_reset(statement)
                sqlite3_bind_int64(statement, 1, code.toInt64())
                sqlite3_bind_int64(statement, 2, complex.toInt64())
                sqlite3_bind_int64(statement, 3, (limit ?? -1))
                var items: [Lexicon] = []
                while sqlite3_step(statement) == SQLITE_ROW {
                        let rowID: Int = Int(sqlite3_column_int64(statement, 0))
                        let word: String = String(cString: sqlite3_column_text(statement, 1))
                        let romanization: String = String(cString: sqlite3_column_text(statement, 2))
                        let mark: String = romanization.strippedTones()
                        let instance = Lexicon(text: word, romanization: romanization, input: mark.strippedSpaces(), mark: mark, number: rowID)
                        items.append(instance)
                }
                return items
        }
}
