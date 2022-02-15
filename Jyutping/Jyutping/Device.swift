import UIKit

struct Device {

        static let isPhone: Bool = {
                switch UITraitCollection.current.userInterfaceIdiom {
                case .phone, .unspecified:
                        return true
                default:
                        return false
                }
        }()

        static let isPad: Bool = UITraitCollection.current.userInterfaceIdiom == .pad

        /// Example: iPhone 13 Pro Max
        static let modelName: String = UIDevice.modelName

        /// Example: iPadOS 15.2
        static let system: String = UIDevice.current.systemName + " " + UIDevice.current.systemVersion
}
