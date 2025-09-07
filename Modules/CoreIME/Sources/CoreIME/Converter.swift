import Foundation
import SQLite3

/*
extension Array where Element == Candidate {
        @available(*, deprecated, message: "Use Converter.dispatch() instead")
        public func transformed(with characterStandard: CharacterStandard, isEmojiSuggestionsOn: Bool) -> [Candidate] {
                let containsInputMemory: Bool = first?.isInputMemory ?? false
                switch (containsInputMemory, isEmojiSuggestionsOn) {
                case (true, true):
                        return filter(\.isCompound.negative).transformed(to: characterStandard).uniqued()
                case (false, true):
                        return transformed(to: characterStandard).uniqued()
                case (true, false):
                        return filter({ $0.isCompound.negative && $0.isEmojiOrSymbol.negative }).transformed(to: characterStandard).uniqued()
                case (false, false):
                        return filter(\.isEmojiOrSymbol.negative).transformed(to: characterStandard).uniqued()
                }
        }
}
*/

extension Converter {

        /// Merge and normalize multiple candidate sources into a single list.
        /// - Parameters:
        ///   - memory: Candidates from InputMemory — all Cantonese.
        ///   - defined: User-defined candidates from System Text Replacements — all plain text.
        ///   - marks: TextMark candidates suggested by the Engine — all plain text.
        ///   - symbols: Emoji / symbol candidates suggested by the Engine.
        ///   - queried: Candidates suggested by the Engine — all Cantonese.
        ///   - isEmojiSuggestionsOn: Whether emoji and symbol candidates are needs. If `true`, include `symbols`; otherwise, exclude emojis/symbols.
        ///   - characterStandard: The Chinese character set to use (e.g., Traditional or Simplified).
        /// - Returns: A merged array of unique, converted candidates.
        public static func dispatch(memory: [Candidate], defined: [Candidate], marks: [Candidate], symbols: [Candidate], queried: [Candidate], isEmojiSuggestionsOn: Bool, characterStandard: CharacterStandard) -> [Candidate] {
                switch (memory.isNotEmpty, isEmojiSuggestionsOn) {
                case (true, true):
                        guard symbols.isNotEmpty else {
                                if defined.isEmpty {
                                        return (memory + marks + queried.filter(\.isCompound.negative))
                                                .transformed(to: characterStandard)
                                                .uniqued()
                                } else {
                                        return (memory.prefix(3) + defined + memory + marks + queried.filter(\.isCompound.negative))
                                                .transformed(to: characterStandard)
                                                .uniqued()
                                }
                        }
                        var items: [Candidate] = {
                                if defined.isEmpty {
                                        return (memory + marks + queried.filter(\.isCompound.negative))
                                                .transformed(to: characterStandard)
                                                .uniqued()
                                } else {
                                        return (memory.prefix(3) + defined + memory + marks + queried.filter(\.isCompound.negative))
                                                .transformed(to: characterStandard)
                                                .uniqued()
                                }
                        }()
                        for symbol in symbols.reversed() {
                                if let index = items.firstIndex(where: { $0.isCantonese && $0.lexiconText == symbol.lexiconText && $0.romanization == symbol.romanization }) {
                                        items.insert(symbol, at: index + 1)
                                }
                        }
                        return items
                case (true, false):
                        if defined.isEmpty {
                                return (memory + marks + queried.filter(\.isCompound.negative))
                                        .transformed(to: characterStandard)
                                        .uniqued()
                        } else {
                                return (memory.prefix(3) + defined + memory + marks + queried.filter(\.isCompound.negative))
                                        .transformed(to: characterStandard)
                                        .uniqued()
                        }
                case (false, true):
                        guard queried.isNotEmpty else {
                                return (defined + marks).uniqued()
                        }
                        guard symbols.isNotEmpty else {
                                return (defined + marks + queried.transformed(to: characterStandard)).uniqued()
                        }
                        var items: [Candidate] = queried
                        for symbol in symbols.reversed() {
                                if let index = items.firstIndex(where: { $0.lexiconText == symbol.lexiconText && $0.romanization == symbol.romanization }) {
                                        items.insert(symbol, at: index + 1)
                                }
                        }
                        return (defined + marks + items.transformed(to: characterStandard)).uniqued()
                case (false, false):
                        return (defined + marks + queried.transformed(to: characterStandard)).uniqued()
                }
        }
}

extension RandomAccessCollection where Element == Candidate {

        /// Convert Cantonese Candidate text to the specific variant
        /// - Parameter variant: Character variant
        /// - Returns: Transformed Candidates
        public func transformed(to variant: CharacterStandard) -> [Candidate] {
                switch variant {
                case .traditional:
                        return (self is Array<Candidate>) ? (self as! Array<Candidate>) : Array<Candidate>(self)
                case .hongkong:
                        return self.map { origin -> Candidate in
                                guard origin.isCantonese else { return origin }
                                let convertedText: String = Converter.convert2HongKongVariant(origin.lexiconText)
                                return Candidate(text: convertedText, lexiconText: origin.lexiconText, romanization: origin.romanization, input: origin.input, mark: origin.mark, order: origin.order)
                        }
                case .taiwan:
                        return self.map { origin -> Candidate in
                                guard origin.isCantonese else { return origin }
                                let convertedText: String = Converter.convert2TaiwanVariant(origin.lexiconText)
                                return Candidate(text: convertedText, lexiconText: origin.lexiconText, romanization: origin.romanization, input: origin.input, mark: origin.mark, order: origin.order)
                        }
                case .simplified:
                        let statement: OpaquePointer? = {
                                let query: String = "SELECT simplified FROM t2stable WHERE traditional = ?;"
                                var pointer: OpaquePointer? = nil
                                guard sqlite3_prepare_v2(Engine.database, query, -1, &pointer, nil) == SQLITE_OK else { return nil }
                                return pointer
                        }()
                        defer { sqlite3_finalize(statement) }
                        return self.map { origin -> Candidate in
                                guard origin.isCantonese else { return origin }
                                let convertedText: String = Simplifier.simplify(origin.lexiconText, statement: statement)
                                return Candidate(text: convertedText, lexiconText: origin.lexiconText, romanization: origin.romanization, input: origin.input, mark: origin.mark, order: origin.order)
                        }
                }
        }
}

/// Character Variant Converter
public struct Converter {

        /// Convert original (traditional) text to the specific variant
        /// - Parameters:
        ///   - text: Original (traditional) text
        ///   - variant: Character Variant
        /// - Returns: Converted text
        public static func convert(_ text: String, to variant: CharacterStandard) -> String {
                switch variant {
                case .traditional:
                        return text
                case .hongkong:
                        return convert2HongKongVariant(text)
                case .taiwan:
                        return convert2TaiwanVariant(text)
                case .simplified:
                        let statement: OpaquePointer? = {
                                let query: String = "SELECT simplified FROM t2stable WHERE traditional = ?;"
                                var pointer: OpaquePointer? = nil
                                guard sqlite3_prepare_v2(Engine.database, query, -1, &pointer, nil) == SQLITE_OK else { return nil }
                                return pointer
                        }()
                        defer { sqlite3_finalize(statement) }
                        return Simplifier.simplify(text, statement: statement)
                }
        }

        fileprivate static func convert2HongKongVariant(_ text: String) -> String {
                switch text.count {
                case 0:
                        return text
                case 1:
                        return hongkongVariants[text] ?? text
                default:
                        let converted = text.map({ hongkongCharacterVariants[$0] ?? $0 })
                        return String(converted)
                }
        }
        fileprivate static func convert2TaiwanVariant(_ text: String) -> String {
                switch text.count {
                case 0:
                        return text
                case 1:
                        return taiwanVariants[text] ?? text
                default:
                        let converted: [Character] = text.map({ taiwanCharacterVariants[$0] ?? $0 })
                        return String(converted)
                }
        }

        private static let hongkongVariants: [String: String] = {
                let keys: [String] = hongkongCharacterVariants.keys.map({ String($0) })
                let values: [String] = hongkongCharacterVariants.values.map({ String($0) })
                let newDictionary: [String: String] = Dictionary(uniqueKeysWithValues: zip(keys, values))
                return newDictionary
        }()
        private static let taiwanVariants: [String: String] = {
                let keys: [String] = taiwanCharacterVariants.keys.map({ String($0) })
                let values: [String] = taiwanCharacterVariants.values.map({ String($0) })
                let newDictionary: [String: String] = Dictionary(uniqueKeysWithValues: zip(keys, values))
                return newDictionary
        }()

private static let hongkongCharacterVariants: [Character: Character] = [
"僞": "偽",
"兌": "兑",
"叄": "叁",
// "喫": "吃",
"囪": "囱",
"媼": "媪",
"嬀": "媯",
"悅": "悦",
"慍": "愠",
"戶": "户",
"挩": "捝",
"搵": "揾",
"擡": "抬",
"敓": "敚",
"敘": "敍",
"柺": "枴",
"梲": "棁",
"棱": "稜",
"榲": "榅",
"檯": "枱",
"氳": "氲",
"涗": "涚",
"溫": "温",
"溼": "濕",
"潙": "溈",
"潨": "潀",
"熅": "煴",
"爲": "為",
"癡": "痴",
"皁": "皂",
"祕": "秘",
"稅": "税",
"竈": "灶",
"糉": "粽",
"縕": "緼",
"纔": "才",
"脣": "唇",
"脫": "脱",
"膃": "腽",
"臥": "卧",
"臺": "台",
"菸": "煙",
"蒕": "蒀",
"蔥": "葱",
"蔿": "蒍",
"蘊": "藴",
"蛻": "蜕",
"衆": "眾",
"衛": "衞",
"覈": "核",
"說": "説",
"踊": "踴",
"轀": "輼",
"醞": "醖",
"鉢": "缽",
"鉤": "鈎",
"銳": "鋭",
"鍼": "針",
"閱": "閲",
"鰮": "鰛"
]

private static let taiwanCharacterVariants: [Character: Character] = [
"僞": "偽",
"啓": "啟",
// "喫": "吃",
"嫺": "嫻",
"嬀": "媯",
"峯": "峰",
"幺": "么",
"擡": "抬",
"棱": "稜",
"檐": "簷",
"污": "汙",
"泄": "洩",
"潙": "溈",
"潨": "潀",
"爲": "為",
"牀": "床",
"痹": "痺",
"癡": "痴",
"皁": "皂",
"着": "著",
"睾": "睪",
"祕": "秘",
"竈": "灶",
"糉": "粽",
"繮": "韁",
"纔": "才",
"羣": "群",
"脣": "唇",
"蔘": "參",
"蔿": "蒍",
"衆": "眾",
"裏": "裡",
"覈": "核",
"踊": "踴",
"鉢": "缽",
"鍼": "針",
"鮎": "鯰",
"麪": "麵",
"齶": "顎"
]

}
