import UIKit

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
