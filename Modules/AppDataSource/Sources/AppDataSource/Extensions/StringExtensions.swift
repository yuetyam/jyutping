import Foundation

extension StringTransform {
        /// A constant containing the transformation of a string from simplified Chinese characters to traditional forms.
        static let simplifiedToTraditional: StringTransform = StringTransform("Simplified-Traditional")
}

extension StringProtocol {

        /// Convert simplified CJKV characters to traditional
        /// - Returns: Traditional CJKV characters
        func convertedS2T() -> String {
                return self.applyingTransform(.simplifiedToTraditional, reverse: false) ?? (self as? String) ?? String(self)
        }
}
