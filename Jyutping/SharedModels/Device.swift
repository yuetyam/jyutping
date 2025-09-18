import SwiftUI
import CommonExtensions

struct Device {

        static let isPhone: Bool = {
                #if os(iOS)
                switch UITraitCollection.current.userInterfaceIdiom {
                case .phone, .unspecified:
                        return true
                default:
                        return false
                }
                #else
                return false
                #endif
        }()

        static let isPad: Bool = {
                #if os(iOS)
                return UITraitCollection.current.userInterfaceIdiom == .pad
                #else
                return false
                #endif
        }()

        static let isMac: Bool = {
                #if os(macOS)
                return true
                #else
                return false
                #endif
        }()

        /// Example: iPhone 17 Pro Max
        @MainActor
        static let modelName: String = {
                #if os(iOS)
                return UIDevice.modelName
                #else
                return "Mac"
                #endif
        }()

        /// Example: iPadOS 26.2
        @MainActor
        static let system: String = {
                #if os(iOS)
                return UIDevice.current.systemName + String.space + UIDevice.current.systemVersion
                #else
                return ProcessInfo.processInfo.operatingSystemVersionString
                #endif
        }()
}
