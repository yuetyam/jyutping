import Foundation
import InputMethodKit

extension IMKTextInput {

        // cursor position
        var position: CGPoint {
                var lineHeightRectangle: CGRect = .init()
                self.attributes(forCharacterIndex: 0, lineHeightRectangle: &lineHeightRectangle)
                return lineHeightRectangle.origin
        }

        func insert(_ text: String) {
                let convertedText: NSString = text as NSString
                self.insertText(convertedText, replacementRange: NSRange.replacementRange)
        }

        func mark(_ text: String) {
                let convertedText: NSString = text as NSString
                self.setMarkedText(convertedText, selectionRange: NSRange(location: convertedText.length, length: 0), replacementRange: NSRange.replacementRange)
        }

        func clearMarkedText() {
                self.setMarkedText(NSString(), selectionRange: NSRange(location: 0, length: 0), replacementRange: NSRange.replacementRange)
        }
}

private extension NSRange {
        static let replacementRange = NSRange(location: NSNotFound, length: 0)
}
