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
                        return 65
                case .padPortraitMedium:
                        return 68
                case .padPortraitLarge:
                        return 68
                case .padLandscapeSmall, .padLandscapeMedium, .padLandscapeLarge:
                        return 80
                case .padFloating:
                        return 48
                case .phoneLandscape:
                        // iPhone SE1, iPod touch 7 (w480 x h320)
                        let isSmallPhone: Bool = screen.height < 350
                        return isSmallPhone ? 36 : 40
                case .phonePortrait:
                        if screen.width < 350 {
                                // iPhone SE1, iPod touch 7 (320 x 480)
                                return 48
                        } else if screen.width < 380 {
                                // iPhone 6s, 7, 8, SE2, SE3 (375 x 667)
                                // iPhone X, Xs, 11 Pro, 12 mini, 13 mini (375 x 812)
                                return 53
                        } else if screen.width < 400 {
                                // iPhone 12, 12 Pro, 13, 13 Pro, 14 (390 x 844)
                                // iPhone 14 Pro, 15, 15 Pro (393 x 852)
                                return 54
                        } else if screen.width < 420 {
                                // iPhone 6s Plus, 7 Plus, 8 Plus (414 x 836)
                                // iPhone Xr, Xs Max, 11, 11 Pro Max (414 x 896)
                                return 55
                        } else {
                                // iPhone 12 Pro Max, 13 Pro Max, 14 Plus (428 x 926)
                                // iPhone 14 Pro Max, 15 Plus, 15 Pro Max (430 x 932)
                                return 57
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
                        return 11
                case .padPortraitLarge:
                        return 14.5
                case .padLandscapeSmall:
                        return 11
                case .padLandscapeMedium:
                        return 11
                case .padLandscapeLarge:
                        return 14.5
                }
        }
}
