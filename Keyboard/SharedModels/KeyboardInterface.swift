import SwiftUI

enum KeyboardInterface: Int {

        case phonePortrait
        case phoneLandscape

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

        /// .phonePortrait || .phoneLandscape || .padFloating
        var isCompact: Bool {
                switch self {
                case .phonePortrait, .phoneLandscape, .padFloating:
                        return true
                default:
                        return false
                }
        }

        var isPhonePortrait: Bool {
                return self == .phonePortrait
        }
        var isPhoneLandscape: Bool {
                return self == .phoneLandscape
        }

        var isPadFloating: Bool {
                return self == .padFloating
        }

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
}

extension KeyboardInterface {
        func keyHeightUnit(of screen: CGSize) -> CGFloat {
                switch self {
                case .padPortraitSmall:
                        return 66
                case .padPortraitMedium:
                        return 66
                case .padPortraitLarge:
                        return 68
                case .padLandscapeSmall, .padLandscapeMedium, .padLandscapeLarge:
                        return 76
                case .padFloating:
                        return 48
                case .phoneLandscape:
                        return 36
                case .phonePortrait:
                        let screenWidth = screen.width
                        if screenWidth > 300 && screenWidth < 350 {
                                // iPhone SE1, iPod touch 7 (320 x 480)
                                return 48
                        } else if screenWidth < 385 {
                                // iPhone 6s, 7, 8, SE2, SE3 (375 x 667)
                                // iPhone X, Xs, 11 Pro, 12 mini, 13 mini (375 x 812)
                                return 53
                        } else if screenWidth < 405 {
                                // iPhone 12, 12 Pro, 13, 13 Pro, 14 (390 x 844)
                                // iPhone 14 Pro, 15, 15 Pro, 16 (393 x 852)
                                // iPhone 16 Pro (402 x 874)
                                return 54
                        } else if screenWidth < 425 {
                                // iPhone 6s Plus, 7 Plus, 8 Plus (414 x 836)
                                // iPhone Xr, Xs Max, 11, 11 Pro Max (414 x 896)
                                return 55
                        } else if screenWidth < 445 {
                                // iPhone 12 Pro Max, 13 Pro Max, 14 Plus (428 x 926)
                                // iPhone 14 Pro Max, 15 Plus, 15 Pro Max, 16 Plus (430 x 932)
                                // iPhone 16 Pro Max (440 x 956)
                                return 56
                        } else {
                                let extra: Int = Int(screenWidth - 300) / 20
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
