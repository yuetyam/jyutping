import SwiftUI

enum KeyboardInterface: Int {

        case phonePortrait
        case phoneLandscape

        /// Portrait iPhone app running on iPad
        case phoneOnPadPortrait

        /// Landscape iPhone app running on iPad
        case phoneOnPadLandscape

        /// Keyboard floating on iPad
        case padFloating

        case padPortraitSmall
        case padPortraitMedium
        case padPortraitLarge

        case padLandscapeSmall
        case padLandscapeMedium
        case padLandscapeLarge

}

extension KeyboardInterface {

        /// Phone, PhoneOnPad, PadFloating
        var isCompact: Bool {
                switch self {
                case .phonePortrait, .phoneLandscape, .phoneOnPadPortrait, .phoneOnPadLandscape, .padFloating:
                        return true
                default:
                        return false
                }
        }
        var isPhonePortrait: Bool {
                switch self {
                case .phonePortrait, .phoneOnPadPortrait:
                        return true
                default:
                        return false
                }
        }
        var isPhoneLandscape: Bool {
                switch self {
                case .phoneLandscape, .phoneOnPadLandscape:
                        return true
                default:
                        return false
                }
        }
        var isPadFloating: Bool { self == .padFloating }
        var isPadPortrait: Bool {
                switch self {
                case .padPortraitSmall, .padPortraitMedium, .padPortraitLarge:
                        return true
                default:
                        return false
                }
        }
        var isPadLandscape: Bool {
                switch self {
                case .padLandscapeSmall, .padLandscapeMedium, .padLandscapeLarge:
                        return true
                default:
                        return false
                }
        }

        /// 13-inch iPad
        var isLargePad: Bool {
                switch self {
                case .padPortraitLarge, .padLandscapeLarge:
                        return true
                default:
                        return false
                }
        }
}

extension KeyboardInterface {
        func keyHeightUnit(of screenSize: CGSize) -> CGFloat {
                switch self {
                case .padPortraitSmall, .padPortraitMedium:
                        return 66
                case .padPortraitLarge:
                        return 68
                case .padLandscapeSmall, .padLandscapeMedium, .padLandscapeLarge:
                        return 76
                case .padFloating:
                        return 48
                case .phoneOnPadPortrait:
                        // TODO: Handle Larger Text mode Display Zoom
                        let isLargeScreenPad: Bool = min(screenSize.width, screenSize.height) > 840
                        return isLargeScreenPad ? 54 : 53
                case .phoneOnPadLandscape:
                        return 36
                case .phoneLandscape:
                        return 36
                case .phonePortrait:
                        let minDimension: CGFloat = min(screenSize.width, screenSize.height)
                        if minDimension < 355 {
                                // Some devices on Larger Text mode Display Zoom
                                return 48
                        } else if minDimension < 385 {
                                // iPhone 8, SE2, SE3 (375 x 667)
                                // iPhone X, Xs, 11 Pro, 12 mini, 13 mini (375 x 812)
                                return 53
                        } else if minDimension < 405 {
                                // iPhone 12, 12 Pro, 13, 13 Pro, 14, 16e (390 x 844)
                                // iPhone 14 Pro, 15, 15 Pro, 16 (393 x 852)
                                // iPhone 16 Pro, 17, 17 Pro (402 x 874)
                                return 54
                        } else if minDimension < 425 {
                                // iPhone 8 Plus (414 x 836)
                                // iPhone Xr, Xs Max, 11, 11 Pro Max (414 x 896)
                                // iPhone Air (420 x 912)
                                return 56
                        } else if minDimension < 445 {
                                // iPhone 12 Pro Max, 13 Pro Max, 14 Plus (428 x 926)
                                // iPhone 14 Pro Max, 15 Plus, 15 Pro Max, 16 Plus (430 x 932)
                                // iPhone 16 Pro Max, 17 Pro Max (440 x 956)
                                return 56
                        } else {
                                let extra: Int = Int(minDimension - 300) / 20
                                return CGFloat(50 + extra)
                        }
                }
        }
}

extension KeyboardInterface {

        /// Key count per row
        var widthUnitTimes: CGFloat {
                switch self {
                case .phonePortrait:
                        return 10
                case .phoneLandscape:
                        return 10
                case .phoneOnPadPortrait:
                        return 10
                case .phoneOnPadLandscape:
                        return 10
                case .padFloating:
                        return 10
                case .padPortraitSmall:
                        return 11
                case .padPortraitMedium:
                        return 12
                case .padPortraitLarge:
                        return 14.5
                case .padLandscapeSmall:
                        return 11
                case .padLandscapeMedium:
                        return 12
                case .padLandscapeLarge:
                        return 14.5
                }
        }
}

extension KeyboardInterface {
        var editingKeyInset: CGFloat {
                switch self {
                case .padFloating: 2
                case .phonePortrait,
                .phoneLandscape,
                .phoneOnPadPortrait,
                .phoneOnPadLandscape: 3
                case .padPortraitSmall,
                .padLandscapeSmall,
                .padPortraitMedium,
                .padLandscapeMedium,
                .padPortraitLarge,
                .padLandscapeLarge: 5
                }
        }
        var keyShapeInsets: EdgeInsets {
                switch self {
                case .phonePortrait, .phoneOnPadPortrait, .padFloating:
                        EdgeInsets(top: 6, leading: 3, bottom: 6, trailing: 3)
                case .phoneLandscape, .phoneOnPadLandscape:
                        EdgeInsets(top: 3, leading: 6, bottom: 3, trailing: 6)
                case .padPortraitSmall, .padPortraitMedium:
                        EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
                case .padLandscapeSmall, .padLandscapeMedium:
                        EdgeInsets(top: 7, leading: 7, bottom: 7, trailing: 7)
                case .padPortraitLarge:
                        EdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
                case .padLandscapeLarge:
                        EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
                }
        }
        func previewBottomOffset(keyWidth: CGFloat, keyHeight: CGFloat, insets: EdgeInsets? = nil) -> CGFloat {
                let insets = insets ?? keyShapeInsets
                let baseHeight: CGFloat = keyHeight - (insets.top + insets.bottom)
                let shapeHeight: CGFloat = isPhoneLandscape ? (baseHeight / (2 / 6.0)) : baseHeight / ((2.5 / 6.0))
                let curveHeight: CGFloat = isPhoneLandscape ? (shapeHeight / 3.0) : (shapeHeight / 6.0)
                return (baseHeight * 2) + (curveHeight * 1.5)
        }
}
extension EdgeInsets {
        func adjusted(horizontal: CGFloat = 0, vertical: CGFloat = 0) -> EdgeInsets {
                return EdgeInsets(top: top + vertical, leading: leading + horizontal, bottom: bottom + vertical, trailing: trailing + horizontal)
        }
        func plused(_ value: CGFloat) -> EdgeInsets {
                return EdgeInsets(top: top + value, leading: leading + value, bottom: bottom + value, trailing: trailing + value)
        }
}
