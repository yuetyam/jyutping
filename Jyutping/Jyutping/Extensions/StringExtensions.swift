extension String {

        /// Returns a new String made by removing `.whitespacesAndNewlines` from both ends of the String.
        /// - Returns: A new String made by removing `.whitespacesAndNewlines` from both ends of the String.
        func trimming() -> String {
                return trimmingCharacters(in: .whitespacesAndNewlines)
        }

        /// aka. `String.init()`
        static let empty: String = ""
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
