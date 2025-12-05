import Foundation
import SQLite3
import CommonExtensions

extension Engine {
        public static func pinyinReverseLookup<T: RandomAccessCollection<InputEvent>>(events: T, segmentation: PinyinSegmentation) async -> [Candidate] {
                let isLetterEventOnly: Bool = events.contains(where: \.isLetter.negative).negative
                // TODO: Handle separators
                guard isLetterEventOnly else { return [] }
                lazy var anchorsStatement: OpaquePointer? = preparePinyinAnchorsStatement()
                lazy var pingStatement: OpaquePointer? = preparePinyinStatement()
                defer {
                        sqlite3_finalize(anchorsStatement)
                        sqlite3_finalize(pingStatement)
                }
                let canSegment: Bool = segmentation.flattenedCount > 0
                if canSegment {
                        return pinyinSearch(events: events, segmentation: segmentation, anchorsStatement: anchorsStatement, pingStatement: pingStatement)
                                .flatMap({ Engine.reveresLookup(text: $0.text, input: $0.input, mark: $0.mark) })
                } else {
                        return processPinyinSlices(of: events, text: events.map(\.text).joined(), anchorsStatement: anchorsStatement, pingStatement: pingStatement)
                                .flatMap({ Engine.reveresLookup(text: $0.text, input: $0.input, mark: $0.mark) })
                }
        }

        private static func processPinyinSlices<T: RandomAccessCollection<InputEvent>>(of events: T, text: String, limit: Int64? = nil, anchorsStatement: OpaquePointer?, pingStatement: OpaquePointer?) -> [PinyinLexicon] {
                let adjustedLimit: Int64 = (limit == nil) ? 300 : 100
                let inputLength: Int = events.count
                return (0..<inputLength).flatMap({ number -> [PinyinLexicon] in
                        let leadingEvents = events.dropLast(number)
                        let leadingText = leadingEvents.map(\.text).joined()
                        let pingMatched = pinyinMatch(text: leadingText, limit: limit, statement: pingStatement)
                                .map({ modify($0, text: text, textLength: inputLength) })
                        let anchorsMatched = pinyinAnchorsMatch(events: leadingEvents, input: leadingText, limit: adjustedLimit, statement: anchorsStatement)
                                .map({ modify($0, text: text, textLength: inputLength) })
                                .sorted()
                                .prefix(72)
                        return pingMatched + anchorsMatched
                })
                .distinct()
                .sorted()
        }
        private static func modify(_ item: PinyinLexicon, text: String, textLength: Int) -> PinyinLexicon {
                guard item.inputCount != textLength else { return item }
                guard item.pinyin.removedSpaces().hasPrefix(text).negative else {
                        return PinyinLexicon(text: item.text, pinyin: item.pinyin, input: text, mark: text, order: item.order)
                }
                let syllables = item.pinyin.split(separator: Character.space)
                guard let lastSyllable = syllables.last, text.hasSuffix(lastSyllable) else { return item }
                let isMatched: Bool = ((syllables.count - 1) + lastSyllable.count) == textLength
                guard isMatched else { return item }
                return PinyinLexicon(text: item.text, pinyin: item.pinyin, input: text, mark: text, order: item.order)
        }

        private static func pinyinSearch<T: RandomAccessCollection<InputEvent>>(events: T, segmentation: PinyinSegmentation, limit: Int64? = nil, anchorsStatement: OpaquePointer?, pingStatement: OpaquePointer?) -> [PinyinLexicon] {
                let inputLength: Int = events.count
                let text: String = events.map(\.text).joined()
                let pingMatched = pinyinMatch(text: text, limit: limit, statement: pingStatement)
                let anchorsMatched = pinyinAnchorsMatch(events: events, limit: limit, statement: anchorsStatement)
                let queried = pinyinQuery(inputLength: inputLength, segmentation: segmentation, limit: limit, statement: pingStatement)
                let shouldMatchPrefixes: Bool = {
                        guard pingMatched.isEmpty else { return false }
                        guard queried.contains(where: { $0.inputCount == inputLength }).negative else { return false }
                        return segmentation.contains(where: { $0.length == inputLength }).negative
                }()
                let prefixesLimit: Int64 = (limit == nil) ? 500 : 200
                let prefixMatched: [PinyinLexicon] = shouldMatchPrefixes.negative ? [] : segmentation.flatMap({ scheme -> [PinyinLexicon] in
                        let tail = events.dropFirst(scheme.length)
                        guard let lastAnchor = tail.first else { return [] }
                        let schemeAnchors = scheme.compactMap(\.events.first)
                        let conjoined = schemeAnchors + tail
                        let anchors = schemeAnchors + [lastAnchor]
                        let schemeMark: String = scheme.map(\.text).joined(separator: String.space)
                        let mark: String = schemeMark + String.space + tail.map(\.text).joined()
                        let conjoinedMatched = pinyinAnchorsMatch(events: conjoined, limit: prefixesLimit, statement: anchorsStatement)
                                .compactMap({ item -> PinyinLexicon? in
                                        guard item.pinyin.hasPrefix(schemeMark) else { return nil }
                                        let tailAnchors = item.pinyin.dropFirst(schemeMark.count).split(separator: Character.space).compactMap(\.first)
                                        guard tailAnchors == tail.compactMap(\.text.first) else { return nil }
                                        return PinyinLexicon(text: item.text, pinyin: item.pinyin, input: text, mark: mark, order: item.order)
                                })
                        let anchorsMatched = pinyinAnchorsMatch(events: anchors, limit: prefixesLimit, statement: anchorsStatement)
                                .compactMap({ item -> PinyinLexicon? in
                                        guard item.pinyin.hasPrefix(mark) else { return nil }
                                        return PinyinLexicon(text: item.text, pinyin: item.pinyin, input: text, mark: mark, order: item.order)
                                })
                        return conjoinedMatched + anchorsMatched
                })
                let gainedMatched: [PinyinLexicon] = shouldMatchPrefixes.negative ? [] : (1..<inputLength).flatMap({ number -> [PinyinLexicon] in
                        let leadingEvents = events.dropLast(number)
                        let leadingText = leadingEvents.map(\.text).joined()
                        return pinyinAnchorsMatch(events: leadingEvents, input: leadingText, limit: 300, statement: anchorsStatement)
                }).compactMap({ item -> PinyinLexicon? in
                        guard item.pinyin.removedSpaces().hasPrefix(text).negative else {
                                return PinyinLexicon(text: item.text, pinyin: item.pinyin, input: text, mark: text, order: item.order)
                        }
                        let syllables = item.pinyin.split(separator: Character.space)
                        guard let lastSyllable = syllables.last, text.hasSuffix(lastSyllable) else { return nil }
                        let isMatched: Bool = ((syllables.count - 1) + lastSyllable.count) == inputLength
                        guard isMatched else { return nil }
                        return PinyinLexicon(text: item.text, pinyin: item.pinyin, input: text, mark: text, order: item.order)
                })
                let fetched: [PinyinLexicon] = {
                        let idealQueried = queried.filter({ $0.inputCount == inputLength }).sorted(by: { $0.order < $1.order }).distinct()
                        let notIdealQueried = queried.filter({ $0.inputCount < inputLength }).sorted().distinct()
                        let fullInput = (pingMatched + idealQueried + anchorsMatched + prefixMatched + gainedMatched).distinct()
                        let primary = fullInput.prefix(10)
                        let secondary = fullInput.sorted().prefix(10)
                        let tertiary = notIdealQueried.prefix(10)
                        let quaternary = notIdealQueried.sorted(by: { $0.order < $1.order }).prefix(10)
                        return (primary + secondary + tertiary + quaternary + fullInput + notIdealQueried).distinct()
                }()
                guard let firstInputCount = fetched.first?.inputCount else {
                        return processPinyinSlices(of: events, text: text, limit: limit, anchorsStatement: anchorsStatement, pingStatement: pingStatement)
                }
                guard firstInputCount < inputLength else { return fetched }
                let headInputLengths = fetched.map(\.inputCount).distinct()
                let concatenated = headInputLengths.compactMap({ headLength -> PinyinLexicon? in
                        let tailEvents = events.dropFirst(headLength)
                        let tailSegmentation = PinyinSegmenter.segment(events: tailEvents)
                        guard let tailLexicon = pinyinSearch(events: tailEvents, segmentation: tailSegmentation, limit: 50, anchorsStatement: anchorsStatement, pingStatement: pingStatement).first else { return nil }
                        guard let headLexicon = fetched.first(where: { $0.inputCount == headLength }) else { return nil }
                        return headLexicon + tailLexicon
                }).distinct().sorted().prefix(1)
                return concatenated + fetched
        }

        private static func pinyinQuery(inputLength: Int, segmentation: PinyinSegmentation, limit: Int64? = nil, statement: OpaquePointer?) -> [PinyinLexicon] {
                let idealSchemes = segmentation.filter({ $0.length == inputLength })
                if idealSchemes.isEmpty {
                        return segmentation.flatMap({ scheme -> [PinyinLexicon] in
                                return pinyinMatch(text: scheme.map(\.text).joined(), limit: limit, statement: statement)
                        })
                } else {
                        return idealSchemes.flatMap({ scheme -> [PinyinLexicon] in
                                switch scheme.count {
                                case 0:
                                        return []
                                case 1:
                                        return pinyinMatch(text: scheme.map(\.text).joined(), limit: limit, statement: statement)
                                default:
                                        return (1...scheme.count).reversed().map({ scheme.prefix($0) }).flatMap({ slice -> [PinyinLexicon] in
                                                return pinyinMatch(text: slice.map(\.text).joined(), limit: limit, statement: statement)
                                        })
                                }
                        })
                }
        }

        private static func preparePinyinStatement() -> OpaquePointer? {
                let command: String = "SELECT rowid, word, romanization FROM pinyin_lexicon WHERE spell = ? LIMIT ?;"
                var statement: OpaquePointer? = nil
                guard sqlite3_prepare_v2(Engine.database, command, -1, &statement, nil) == SQLITE_OK else { return nil }
                return statement
        }
        private static func pinyinMatch(text: String, limit: Int64? = nil, statement: OpaquePointer?) -> [PinyinLexicon] {
                let limit: Int64 = limit ?? -1
                sqlite3_reset(statement)
                sqlite3_bind_int64(statement, 1, Int64(text.hashCode()))
                sqlite3_bind_int64(statement, 2, limit)
                var items: [PinyinLexicon] = []
                while sqlite3_step(statement) == SQLITE_ROW {
                        let rowID = sqlite3_column_int64(statement, 0)
                        guard let word = sqlite3_column_text(statement, 1) else { continue }
                        guard let romanization = sqlite3_column_text(statement, 2) else { continue }
                        let pinyin = String(cString: romanization)
                        let instance = PinyinLexicon(text: String(cString: word), pinyin: pinyin, input: text, mark: pinyin, order: Int(rowID))
                        items.append(instance)
                }
                return items
        }
        private static func preparePinyinAnchorsStatement() -> OpaquePointer? {
                let command: String = "SELECT rowid, word, romanization FROM pinyin_lexicon WHERE anchors = ? LIMIT ?;"
                var statement: OpaquePointer? = nil
                guard sqlite3_prepare_v2(Engine.database, command, -1, &statement, nil) == SQLITE_OK else { return nil }
                return statement
        }
        private static func pinyinAnchorsMatch<T: RandomAccessCollection<InputEvent>>(events: T, input: String? = nil, limit: Int64? = nil, statement: OpaquePointer?) -> [PinyinLexicon] {
                let code = events.combinedCode
                guard code > 0 else { return [] }
                sqlite3_reset(statement)
                sqlite3_bind_int64(statement, 1, Int64(code))
                sqlite3_bind_int64(statement, 2, (limit ?? 100))
                let text: String = input ?? events.map(\.text).joined()
                var items: [PinyinLexicon] = []
                while sqlite3_step(statement) == SQLITE_ROW {
                        let rowID = sqlite3_column_int64(statement, 0)
                        guard let word = sqlite3_column_text(statement, 1) else { continue }
                        guard let romanization = sqlite3_column_text(statement, 2) else { continue }
                        let instance = PinyinLexicon(text: String(cString: word), pinyin: String(cString: romanization), input: text, mark: text, order: Int(rowID))
                        items.append(instance)
                }
                return items
        }
}

private extension Array where Element == PinyinLexicon {
        func ordered(with textCount: Int) -> [PinyinLexicon] {
                let matched = filter({ $0.inputCount == textCount }).sorted(by: { $0.order < $1.order }).distinct()
                let others = filter({ $0.inputCount != textCount }).sorted().distinct()
                let primary = matched.prefix(15)
                let secondary = others.prefix(10)
                let tertiary = others.sorted(by: { $0.order < $1.order }).prefix(7)
                return (primary + secondary + tertiary + matched + others).distinct()
        }
}

private struct PinyinLexicon: Hashable, Comparable {

        /// Cantonese Chinese word.
        let text: String

        /// Pinyin romanization for word text.
        let pinyin: String

        /// User input.
        let input: String

        /// Character count of self.input
        let inputCount: Int

        /// Formatted user input for pre-edit display
        let mark: String

        /// Rank, smaller is preferred.
        let order: Int

        /// Create a PinyinLexicon.
        /// - Parameters:
        ///   - text: Cantonese Chinese word.
        ///   - pinyin: Pinyin romanization for word text.
        ///   - input: User input.
        ///   - order: Rank, smaller is preferred.
        init(text: String, pinyin: String? = nil, input: String, mark: String? = nil, order: Int? = nil) {
                self.text = text
                self.pinyin = pinyin ?? input
                self.input = input
                self.inputCount = input.count
                self.mark = mark ?? input
                self.order = order ?? 0
        }

        // Equatable
        static func ==(lhs: PinyinLexicon, rhs: PinyinLexicon) -> Bool {
                return lhs.text == rhs.text && lhs.pinyin == rhs.pinyin
        }

        // Hashable
        func hash(into hasher: inout Hasher) {
                hasher.combine(text)
                hasher.combine(pinyin)
        }

        // Comparable
        static func <(lhs: PinyinLexicon, rhs: PinyinLexicon) -> Bool {
                guard lhs.inputCount == rhs.inputCount else { return lhs.inputCount > rhs.inputCount }
                return lhs.order < rhs.order
        }

        static func +(lhs: PinyinLexicon, rhs: PinyinLexicon) -> PinyinLexicon {
                let newText: String = lhs.text + rhs.text
                let newPinyin: String = lhs.pinyin + String.space + rhs.pinyin
                let newInput: String = lhs.input + rhs.input
                let newMark: String = lhs.mark + String.space + rhs.mark
                return PinyinLexicon(text: newText, pinyin: newPinyin, input: newInput, mark: newMark)
        }
}
