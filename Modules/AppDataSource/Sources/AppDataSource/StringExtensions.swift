import Foundation

extension String {
        var isNone: Bool {
                return self == "X"
        }
}

extension String {

        /// Convert simplified Chinese text to traditional
        /// - Parameter text: Simplified Chinese text
        /// - Returns: Traditional Chinese text
        func convertedS2T() -> String {
                let transformed: String? = self.applyingTransform(StringTransform("Simplified-Traditional"), reverse: false)
                return transformed ?? self
        }
}
