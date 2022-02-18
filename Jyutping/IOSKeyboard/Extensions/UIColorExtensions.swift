import UIKit

extension UIColor {
        static let lightEmphatic: UIColor = UIColor(displayP3Red: 172.0 / 255.0, green: 177.0 / 255.0, blue: 185.0 / 255.0, alpha: 1)
        static let darkThin     : UIColor = UIColor(displayP3Red: 106.0 / 255.0, green: 106.0 / 255.0, blue: 106.0 / 255.0, alpha: 1)
        static let darkThick    : UIColor = UIColor(displayP3Red: 70.0 / 255.0, green: 70.0 / 255.0, blue: 70.0 / 255.0, alpha: 1)
        static let selection    : UIColor = UIColor(displayP3Red: 52.0 / 255.0, green: 120.0 / 255.0, blue: 246.0 / 255.0, alpha: 1)

        /// .clear && isUserInteractionEnabled
        static let interactiveClear: UIColor = UIColor(white: 1, alpha: 0.001)
}
