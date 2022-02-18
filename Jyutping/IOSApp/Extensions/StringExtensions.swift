extension String {

        /// Returns a new String made by removing `.whitespacesAndNewlines` from both ends of the String.
        /// - Returns: A new String made by removing `.whitespacesAndNewlines` from both ends of the String.
        func trimmed() -> String {
                return trimmingCharacters(in: .whitespacesAndNewlines)
        }

        /// aka. `String.init()`
        static let empty: String = ""

        /// Ideographic characters only.
        /// - Returns: A new String made by removing irrelevant characters.
        func filtered() -> String {
                // return filter({ !($0.isASCII || $0.isPunctuation || $0.isWhitespace) })
                return unicodeScalars.filter({ $0.properties.isIdeographic }).map({ String($0) }).joined()
        }

        var ideographicBlocks: [(text: String, isIdeographic: Bool)] {
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
                        let newElement: (String, Bool) = (ideographicCache, true)
                        blocks.append(newElement)
                } else if !otherCache.isEmpty {
                        let newElement: (String, Bool) = (otherCache, false)
                        blocks.append(newElement)
                }
                return blocks
        }
}


extension Optional where Wrapped == String {

        /// Not nil && not empty
        var hasContent: Bool {
                switch self {
                case .none:
                        return false
                case .some(let value):
                        return !value.isEmpty
                }
        }
}
