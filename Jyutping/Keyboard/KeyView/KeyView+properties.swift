import UIKit

extension KeyView {

        var width: CGFloat {
                switch event {
                case .none, .shadowKey, .shadowBackspace:
                        return 10
                case .backspace, .shift, .switchTo:
                        return 50
                case .switchInputMethod:
                        return 45
                case .newLine:
                        return 72
                case .space:
                        return 180
                case .key(.period), .key(.cantoneseComma), .key(.separator):
                        return controller.needsInputModeSwitchKey ? 37 : 33
                default:
                        return 40
                }
        }
        var height: CGFloat {
                let widthPoints: CGFloat =  UIScreen.main.bounds.width
                let heightPoints: CGFloat = UIScreen.main.bounds.height
                switch traitCollection.userInterfaceIdiom {
                case .phone:
                        guard controller.traitCollection.verticalSizeClass != .compact else {
                                // iPhone SE1, iPod touch 7. (w480 x h320) in landscape
                                return heightPoints < 350 ? 36 : 40
                        }
                        if widthPoints < 350 {
                                // iPhone SE1, iPod touch 7. (320 x 480)
                                return 48
                        } else if widthPoints < 400 {
                                // iPhone 6s, 7, 8, SE2. (375 x 667)
                                // iPhone X, Xs, 11 Pro, 12 mini. (375 x 812)
                                // iPhone 12 Pro, 12. (390 x 844)
                                return 53
                        } else {
                                // iPhone 6s Plus, 7 Plus, 8 Plus. (414 x 836)
                                // iPhone Xs Max, Xr, 11 Pro Max, 11. (414 x 896)
                                // iPhone 12 Pro Max. (428 x 926)
                                return 55
                        }
                case .pad:
                        if isCompactInterface {
                                return 48 // floating, same as iPhone SE1
                        } else if isPadLandscape {
                                return 80 // landscape
                        } else {
                                return 70 // portrait
                        }
                default:
                        return 55
                }
        }

        var keyFont: UIFont {
                // https://www.iosfontsizes.com
                // https://developer.apple.com/design/human-interface-guidelines/ios/visual-design/typography
                switch event {
                case .key(let seat) where seat.primary.text.count > 1:
                        guard !isCompactInterface else { return .systemFont(ofSize: 18) }
                        return isPadLandscape ? .systemFont(ofSize: 28) : .systemFont(ofSize: 26)
                case .key:
                        guard !isCompactInterface else { return .systemFont(ofSize: 24) }
                        return isPadLandscape ? .systemFont(ofSize: 30) : .systemFont(ofSize: 28)
                default:
                        return isCompactInterface ? .systemFont(ofSize: 17) : .systemFont(ofSize: 22)
                }
        }
        var keyText: String? {
                switch event {
                case .key(let seat):
                        return seat.primary.text
                case .space:
                        if layout.isEnglishMode {
                                return "English"
                        } else {
                                return Logogram.current == .simplified ? "粤拼" : "粵拼"
                        }
                case .newLine:
                        return newLineKeyText
                case .switchTo(let newLayout):
                        switch newLayout {
                        case .cantoneseNumeric, .numeric:
                                return "123"
                        case .cantoneseSymbolic, .symbolic:
                                return "#+="
                        case .cantonese:
                                return "拼"
                        case .alphabetic:
                                return "ABC"
                        default:
                                return "??"
                        }
                default:
                        return nil
                }
        }
        private var newLineKeyText: String {
                guard !layout.isEnglishMode else {
                        guard let returnKeyType: UIReturnKeyType = controller.textDocumentProxy.returnKeyType else { return "return" }
                        switch returnKeyType {
                        case .continue:
                                return "continue"
                        case .default:
                                return "return"
                        case .done:
                                return "done"
                        case .emergencyCall:
                                return "emergency"
                        case .go:
                                return "go"
                        case .google:
                                return "google"
                        case .join:
                                return "join"
                        case .next:
                                return "next"
                        case .route:
                                return "route"
                        case .search:
                                return "search"
                        case .send:
                                return "send"
                        case .yahoo:
                                return "yahoo"
                        @unknown default:
                                return "return"
                        }
                }
                guard Logogram.current != .simplified else {
                        guard let returnKeyType: UIReturnKeyType = controller.textDocumentProxy.returnKeyType else { return "换行" }
                        switch returnKeyType {
                        case .continue:
                                return "继续"
                        case .default:
                                return "换行"
                        case .done:
                                return "完成"
                        case .emergencyCall:
                                return "紧急"
                        case .go:
                                return "前往"
                        case .google:
                                return "谷歌"
                        case .join:
                                return "加入"
                        case .next:
                                return "下一个"
                        case .route:
                                return "路线"
                        case .search:
                                return "搜寻"
                        case .send:
                                return "传送"
                        case .yahoo:
                                return "雅虎"
                        @unknown default:
                                return "换行"
                        }
                }
                guard let returnKeyType: UIReturnKeyType = controller.textDocumentProxy.returnKeyType else { return "換行" }
                switch returnKeyType {
                case .continue:
                        return "繼續"
                case .default:
                        return "換行"
                case .done:
                        return "完成"
                case .emergencyCall:
                        return "緊急"
                case .go:
                        return "前往"
                case .google:
                        return "谷歌"
                case .join:
                        return "加入"
                case .next:
                        return "下一個"
                case .route:
                        return "路線"
                case .search:
                        return "搜尋"
                case .send:
                        return "傳送"
                case .yahoo:
                        return "雅虎"
                @unknown default:
                        return "換行"
                }
        }

        var keyImageName: String? {
                switch event {
                case .switchInputMethod:
                        return "globe"
                case .backspace:
                        return "delete.left"
                case .shift:
                        switch layout {
                        case .cantonese(.uppercased), .alphabetic(.uppercased):
                                return "shift.fill"
                        case .cantonese(.capsLocked), .alphabetic(.capsLocked):
                                return "capslock.fill"
                        default:
                                return "shift"
                        }
                default:
                        return nil
                }
        }

        /// Key Shape View background color
        var backColor: UIColor {
                if isDarkAppearance {
                        return deepDarkFantasy ? .darkActionButton : .darkButton
                } else {
                        return deepDarkFantasy ? .lightActionButton : .white
                }
        }
        var highlightingBackColor: UIColor {
                // action <=> non-action
                if isDarkAppearance {
                        return deepDarkFantasy ? .darkButton : .black
                } else {
                        return deepDarkFantasy ? .white : .lightActionButton
                }
        }
        private var deepDarkFantasy: Bool {
                switch event {
                case .key, .space:
                        return false
                default:
                        return true
                }
        }
        var foreColor: UIColor {
                return isDarkAppearance ? .white : .black
        }
}
