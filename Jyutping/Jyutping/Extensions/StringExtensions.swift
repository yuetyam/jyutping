import Foundation

extension String {

        /// Returns a new String made by removing `.whitespacesAndNewlines` from both ends of the String.
        /// - Returns: A new String made by removing `.whitespacesAndNewlines` from both ends of the String.
        func trimmed() -> String {
                return trimmingCharacters(in: .whitespacesAndNewlines)
        }

        /// aka. `String.init()`
        static let empty: String = ""

        /// aka. `removedIrrelevancies()`
        /// - Returns: A new String made by removing irrelevant characters.
        func filtered() -> String {
                return filter({ !($0.isASCII || $0.isPunctuation || $0.isWhitespace) })
        }

        var traditional: String {
                let transformed: String? = self.applyingTransform(StringTransform("Simplified-Traditional"), reverse: false)
                return transformed ?? self
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
