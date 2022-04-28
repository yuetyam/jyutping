#if os(iOS)
import UIKit
#elseif os(macOS)
import Cocoa
#else
import SwiftUI
#endif

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

        /// Example: iPhone 13 Pro Max
        static let modelName: String = {
                #if os(iOS)
                return UIDevice.modelName
                #else
                return "Mac"
                #endif
        }()

        /// Example: iPadOS 15.2
        static let system: String = {
                #if os(iOS)
                return UIDevice.current.systemName + " " + UIDevice.current.systemVersion
                #else
                return ProcessInfo.processInfo.operatingSystemVersionString
                #endif
        }()
}

