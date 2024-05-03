import Foundation

extension Optional where Wrapped == String {

        /// Not nil && not empty
        public var hasContent: Bool {
                switch self {
                case .none:
                        return false
                case .some(let value):
                        return !value.isEmpty
                }
        }
}

extension Array where Element == String {

        /// All characters count
        public var summedLength: Int {
                return self.map(\.count).reduce(0, +)
        }
}

extension String {

        /// aka. `String.init()`
        public static let empty: String = ""

        /// U+0009. `\t`
        public static let tab: String = "\t"

        /// U+000A. `\n`
        public static let newLine: String = "\n"

        /// U+0020
        public static let space: String = "\u{20}"

        /// U+200B
        public static let zeroWidthSpace: String = "\u{200B}"

        /// U+3000. Ideographic Space. 全寬空格
        public static let fullWidthSpace: String = "\u{3000}"
}

extension String {

        /// Convert simplified Chinese characters to traditional
        /// - Returns: Traditional Chinese characters
        public func simplified2TraditionalConverted() -> String {
                let transformed: String? = self.applyingTransform(StringTransform("Simplified-Traditional"), reverse: false)
                return transformed ?? self
        }

        /// Convert traditional Chinese characters to simplified
        /// - Returns: Simplified Chinese characters
        public func traditional2SimplifiedConverted() -> String {
                let transformed: String? = self.applyingTransform(StringTransform("Simplified-Traditional"), reverse: true)
                return transformed ?? self
        }
}

extension String {

        /// Returns a new String made by removing `.whitespacesAndNewlines` & `.controlCharacters` from both ends of the String.
        public func trimmed() -> String {
                return self.trimmingCharacters(in: .whitespacesAndNewlines).trimmingCharacters(in: .controlCharacters)
        }

        /// CJKV && !CJKV
        public var textBlocks: [TextUnit] {
                var blocks: [TextUnit] = []
                var ideographicCache: String = ""
                var otherCache: String = ""
                var wasLastIdeographic: Bool = true
                for character in self {
                        if character.isIdeographic {
                                if !wasLastIdeographic && !otherCache.isEmpty {
                                        let newElement: TextUnit = TextUnit(text: otherCache, isIdeographic: false)
                                        blocks.append(newElement)
                                        otherCache = ""
                                }
                                ideographicCache.append(character)
                                wasLastIdeographic = true
                        } else {
                                if wasLastIdeographic && !ideographicCache.isEmpty {
                                        let newElement: TextUnit = TextUnit(text: ideographicCache, isIdeographic: true)
                                        blocks.append(newElement)
                                        ideographicCache = ""
                                }
                                otherCache.append(character)
                                wasLastIdeographic = false
                        }
                }
                if !ideographicCache.isEmpty {
                        let tailElement: TextUnit = TextUnit(text: ideographicCache, isIdeographic: true)
                        blocks.append(tailElement)
                } else if !otherCache.isEmpty {
                        let tailElement: TextUnit = TextUnit(text: otherCache, isIdeographic: false)
                        blocks.append(tailElement)
                }
                return blocks
        }
}

public struct TextUnit {
        public let text: String
        public let isIdeographic: Bool
}
