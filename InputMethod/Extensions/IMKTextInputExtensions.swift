import Foundation
import InputMethodKit

extension IMKTextInput {

        /// (x: origin.x, y: origin.y, width: 1, height: maxY)
        var cursorBlock: CGRect {
                var lineHeightRectangle: CGRect = .init()
                self.attributes(forCharacterIndex: 0, lineHeightRectangle: &lineHeightRectangle)
                return lineHeightRectangle
        }
}

/**
    @abstract  Returns a dictionary of text attributes for the text at a given character index. The attributes include the CTFontRef for the text at that index and the text orientation.  The text orientation is indicated by an NSNumber whose value is 0 if the text is vertically oriented and 1 if the text is horizontally oriented. The key for this value is IMKTextOrientationKey. Additionally, a rectangle that would frame a one-pixel wide rectangle with the height of the line is returned in the frame parameter.  Note that rectangle will be oriented the same way the line is oriented.
    @discussion  Input methods will call this method to place a candidate window on the screen. The index is relative to the inline session.  Note that if there is no inline session the value of index should be 0, which indicates that the information should be taken from the current selection.

    The returned NSDictionary is an autoreleased object.  Don't release it unless you have retained it.
*/
// func attributes(forCharacterIndex index: Int, lineHeightRectangle lineRect: UnsafeMutablePointer<NSRect>!) -> [AnyHashable : Any]!
