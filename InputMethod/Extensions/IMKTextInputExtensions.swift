import Foundation
import InputMethodKit

extension IMKTextInput {

        /// (x: origin.x, y: origin.y: width 1, height: maxY)
        var cursorBlock: CGRect {
                var lineHeightRectangle: CGRect = .init()
                self.attributes(forCharacterIndex: 0, lineHeightRectangle: &lineHeightRectangle)
                return lineHeightRectangle
        }
}
