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

extension String {

        /// aka. `String.init()`
        public static let empty: String = ""

        /// A Space. U+0020
        public static let space: String = "\u{0020}"

        /// U+200B
        public static let zeroWidthSpace: String = "\u{200B}"

        /// U+3000. Ideographic Space.
        public static let fullWidthSpace: String = "\u{3000}"

        /// U+30FB =>・<=
        public static let centerDot: String = "\u{30FB}"
}

extension String {

        /// Returns a new String made by removing `.whitespacesAndNewlines` from both ends of the String.
        /// - Returns: A new String made by removing `.whitespacesAndNewlines` from both ends of the String.
        public func trimmed() -> String {
                return self.trimmingCharacters(in: .whitespacesAndNewlines)
        }

        /// Ideographic characters only.
        /// - Returns: A new String made by removing irrelevant characters.
        public func ideographicFiltered() -> String {
                return self.unicodeScalars.filter({ $0.properties.isIdeographic }).map({ String($0) }).joined()
        }
}

extension String {

        /// CJKV && !CJKV
        public var ideographicBlocks: [(text: String, isIdeographic: Bool)] {
                var blocks: [(String, Bool)] = []
                var ideographicCache: String = .empty
                var otherCache: String = .empty
                var lastWasIdeographic: Bool = true
                for character in self {
                        let isIdeographic: Bool = character.unicodeScalars.first?.properties.isIdeographic ?? false
                        if isIdeographic {
                                if !lastWasIdeographic && !otherCache.isEmpty {
                                        let newElement: (String, Bool) = (otherCache, false)
                                        blocks.append(newElement)
                                        otherCache = .empty
                                }
                                ideographicCache.append(character)
                                lastWasIdeographic = true
                        } else {
                                if lastWasIdeographic && !ideographicCache.isEmpty {
                                        let newElement: (String, Bool) = (ideographicCache, true)
                                        blocks.append(newElement)
                                        ideographicCache = .empty
                                }
                                otherCache.append(character)
                                lastWasIdeographic = false
                        }
                }
                if !ideographicCache.isEmpty {
                        let tailElement: (String, Bool) = (ideographicCache, true)
                        blocks.append(tailElement)
                } else if !otherCache.isEmpty {
                        let tailElement: (String, Bool) = (otherCache, false)
                        blocks.append(tailElement)
                }
                return blocks
        }
}
