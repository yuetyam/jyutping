import InputMethodKit

extension IMKTextInput {

        // cursor position
        var position: CGPoint {
                var lineHeightRectangle: CGRect = .init()
                self.attributes(forCharacterIndex: 0, lineHeightRectangle: &lineHeightRectangle)
                return lineHeightRectangle.origin
        }

        func insert(_ text: String) {
                let text: NSString = text as NSString
                self.insertText(text, replacementRange: NSRange(location: NSNotFound, length: NSNotFound))
        }
}
