import Foundation

extension StringProtocol {

        /// Convert simplified CJKV characters to traditional
        /// - Returns: Traditional CJKV characters
        func convertedS2T() -> String {
                return self.applyingTransform(StringTransform("Simplified-Traditional"), reverse: false) ?? (self as? String) ?? String(self)
        }
}
