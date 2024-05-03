import SwiftUI

extension Image {
        static let upChevron: Image = Image(systemName: "chevron.up")
        static let downChevron: Image = Image(systemName: "chevron.down")
        static let leftChevron: Image = Image(systemName: "chevron.left")
        static let rightChevron: Image = Image(systemName: "chevron.right")

        static let checkmark: Image = Image(systemName: "checkmark")

        /// Backward delete
        static let backspace: Image = Image(systemName: "delete.backward")
        static let forwardDelete: Image = Image(systemName: "delete.forward")

        static let `return`: Image = Image(systemName: "return")
        static let search: Image = Image(systemName: "magnifyingglass")
}

extension UIImage {

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
