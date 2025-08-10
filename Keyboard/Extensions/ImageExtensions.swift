import SwiftUI

extension Image {
        static let chevronUp: Image = Image(systemName: "chevron.up")
        static let chevronDown: Image = Image(systemName: "chevron.down")
        static let chevronForward: Image = Image(systemName: "chevron.forward")

        /// Backward delete
        static let backspace: Image = Image(systemName: "delete.backward")
        static let forwardDelete: Image = Image(systemName: "delete.forward")

        static let `return`: Image = Image(systemName: "return")
        static let search: Image = Image(systemName: "magnifyingglass")
        static let arrowForward: Image = Image(systemName: "arrow.forward")
        static let arrowUp: Image = Image(systemName: "arrow.up")
        static let checkmark: Image = Image(systemName: "checkmark")

        static let tab: Image = Image(systemName: "arrow.right.to.line")
        static let globe: Image = Image(systemName: "globe")
        static let dismissKeyboard: Image = Image(systemName: "keyboard.chevron.compact.down")
        static let shiftLowercased: Image = Image(systemName: "shift")
        static let shiftUppercased: Image = Image(systemName: "shift.fill")
        static let shiftCapsLocked: Image = Image(systemName: "capslock.fill")

        /// Emoji Smiley Face
        @MainActor static let smiley: Image = Image(uiImage: UIImage.emojiSmiley.cropped()?.withRenderingMode(.alwaysTemplate) ?? UIImage.emojiSmiley)
}

extension UIImage {

        @MainActor
        func cropped() -> UIImage? {
                guard let sourceCGImage = self.cgImage else { return nil }
                let sourceSize = self.size
                let sideLength = min(sourceSize.width, sourceSize.height)
                let xOffset = (sourceSize.width - sideLength) / 2.0
                let yOffset = (sourceSize.height - sideLength) / 2.0
                let scale = UIScreen.main.scale
                let cropRect = CGRect(x: xOffset * scale,
                                      y: yOffset * scale,
                                      width: sideLength * scale,
                                      height: sideLength * scale)
                guard let croppedCGImage = sourceCGImage.cropping(to: cropRect) else { return nil }
                return UIImage(cgImage: croppedCGImage)
        }
}
