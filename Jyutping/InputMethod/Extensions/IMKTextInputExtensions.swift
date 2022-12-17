import InputMethodKit

extension IMKTextInput {

        // cursor position
        var position: CGPoint {
                var lineHeightRectangle: CGRect = .init()
                self.attributes(forCharacterIndex: 0, lineHeightRectangle: &lineHeightRectangle)
                return lineHeightRectangle.origin
        }
}
