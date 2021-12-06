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

        static func chevron(_ direction: Direction) -> UIImage? {
                let imageName: String = {
                        switch direction {
                        case .up:
                                return "chevron.up"
                        case .down:
                                return "chevron.down"
                        case .forward:
                                if #available(iOSApplicationExtension 14.0, *) {
                                        return "chevron.forward"
                                } else {
                                        return "chevron.right"
                                }
                        case .backward:
                                if #available(iOSApplicationExtension 14.0, *) {
                                        return "chevron.backward"
                                } else {
                                        return "chevron.left"
                                }
                        }
                }()
                return UIImage(systemName: imageName)
        }
}

enum Direction {
        case up
        case down
        case forward
        case backward
}
