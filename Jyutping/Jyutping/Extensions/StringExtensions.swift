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
