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

        /// U+20
        public static let space: String = "\u{20}"

        /// U+200B
        public static let zeroWidthSpace: String = "\u{200B}"

        /// U+3000. Ideographic Space. 全寬空格
        public static let fullWidthSpace: String = "\u{3000}"

        /// U+30FB. 全寬中點
        public static let centerDot: String = "\u{30FB}"
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
                var lastWasIdeographic: Bool = true
                for character in self {
                        if character.isIdeographic {
                                if !lastWasIdeographic && !otherCache.isEmpty {
                                        let newElement: TextUnit = TextUnit(text: otherCache, isIdeographic: false)
                                        blocks.append(newElement)
                                        otherCache = ""
                                }
                                ideographicCache.append(character)
                                lastWasIdeographic = true
                        } else {
                                if lastWasIdeographic && !ideographicCache.isEmpty {
                                        let newElement: TextUnit = TextUnit(text: ideographicCache, isIdeographic: true)
                                        blocks.append(newElement)
                                        ideographicCache = ""
                                }
                                otherCache.append(character)
                                lastWasIdeographic = false
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
