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
}

extension KeyboardInterface {
        func keyHeightUnit(of screen: CGSize) -> CGFloat {
                switch self {
                case .padPortraitSmall:
                        return 65
                case .padPortraitMedium:
                        return 68
                case .padPortraitLarge:
                        return 72
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
                        } else if screen.width < 400 {
                                // iPhone 6s, 7, 8, SE2, SE3 (375 x 667)
                                // iPhone X, Xs, 11 Pro, 12 mini, 13 mini (375 x 812)
                                // iPhone 12, 12 Pro, 13, 13 Pro, 14 (390 x 844)
                                // iPhone 14 Pro (393 x 852)
                                return 53
                        } else {
                                // iPhone 6s Plus, 7 Plus, 8 Plus (414 x 836)
                                // iPhone Xr, Xs Max, 11, 11 Pro Max (414 x 896)
                                // iPhone 12 Pro Max, 13 Pro Max, 14 Plus (428 x 926)
                                // iPhone 14 Pro Max (430 x 932)
                                return 55
                        }
                }
        }
}
