import UIKit

extension KeyButton {
        
        var width: CGFloat {
                switch keyboardEvent {
                case .none, .shadowKey(_), .shadowBackspace:
                        return 10
                case .backspace, .shift, .shiftDown, .switchTo(_):
                        return 50
                case .switchInputMethod:
                        return 45
                case .newLine:
                        return 72
                case .space:
                        return 180
                case .key(.periodSeat):
                        return viewController.needsInputModeSwitchKey ? 37 : 33
                default:
                        return 40
                }
        }
        
        var height: CGFloat {
                switch viewController.traitCollection.userInterfaceIdiom {
                case .phone:
                        if viewController.traitCollection.verticalSizeClass == .compact {
                                // iPhone landscape

                                if UIScreen.main.bounds.height < 350 {
                                        return 36 // iPhone SE1, iPod touch 7. (320 x 480)
                                } else {
                                        return 40
                                }
                        } else {
                                let widthPoints: CGFloat =  UIScreen.main.bounds.width
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
                        }
                case .pad:
                        if viewController.traitCollection.horizontalSizeClass == .compact || viewController.view.frame.width < 500 {
                                // floating
                                return 50
                        } else if UIScreen.main.bounds.width > UIScreen.main.bounds.height {
                                // landscape
                                return 80
                        } else {
                                return 70
                        }
                default:
                        return 55
                }
        }
        
        var styledFont: UIFont {
                // Font sizes reference: https://www.iosfontsizes.com
                switch keyboardEvent {
                case .key:
                        if viewController.traitCollection.userInterfaceIdiom == .pad {
                                if viewController.traitCollection.horizontalSizeClass == .compact || viewController.view.frame.width < 500 {
                                        return .systemFont(ofSize: 24)
                                } else {
                                        if UIScreen.main.bounds.width > UIScreen.main.bounds.height {
                                                return .systemFont(ofSize: 30)
                                        } else {
                                                return .systemFont(ofSize: 28)
                                        }
                                }
                        } else {
                                return .systemFont(ofSize: 24)
                        }
                default:
                        if viewController.traitCollection.userInterfaceIdiom == .pad {
                                if viewController.traitCollection.horizontalSizeClass == .compact || viewController.view.frame.width < 500 {
                                        return .systemFont(ofSize: 17)
                                } else {
                                        return .systemFont(ofSize: 22)
                                }
                        } else {
                                return .systemFont(ofSize: 17)
                        }
                }
        }
        
        var keyText: String? {
                switch keyboardEvent {
                case .key(let keySeat):
                        return keySeat.primary.text
                case .space:
                        return viewController.keyboardLayout.isEnglishLayout ? "English" : "粵拼"
                case .switchTo(let destinationLayout):
                        return keyText(for: destinationLayout)
                case .newLine:
                        return newLineKeyText
                default:
                        return nil
                }
        }
        
        private func keyText(for destination: KeyboardLayout) -> String {
                switch destination {
                case .cantoneseNumeric, .numeric:
                        return "123"
                case .cantoneseSymbolic, .symbolic:
                        return "#+="
                case .jyutping:
                        return "拼"
                case .alphabetic, .alphabeticUppercase:
                        return "ABC"
                default:
                        return "??"
                }
        }
        
        private var newLineKeyText: String {
                guard let returnKeyType: UIReturnKeyType = viewController.textDocumentProxy.returnKeyType else { return "換行" }
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
        
        var keyImage: UIImage? {
                switch keyboardEvent {
                case .switchInputMethod:
                        return UIImage(systemName: "globe")
                case .backspace:
                        return UIImage(systemName: "delete.left")
                case .shift:
                        return UIImage(systemName: "shift")
                case .shiftDown:
                        return UIImage(systemName: viewController.isCapsLocked ? "capslock.fill" : "shift.fill")
                default:
                        return nil
                }
        }

        /// Key Button View background color
        var buttonColor: UIColor {
                if viewController.isDarkAppearance {
                        return shouldBeDarker ? .darkActionButton : .darkButton
                } else {
                        return shouldBeDarker ? .lightActionButton : .lightButton
                }
        }
        var highlightButtonColor: UIColor {
                // action <=> non-action
                if viewController.isDarkAppearance {
                        return shouldBeDarker ? .darkButton : .black
                } else {
                        return shouldBeDarker ? .lightButton : .lightActionButton
                }
        }
        private var shouldBeDarker: Bool {
                switch keyboardEvent {
                case .key, .space:
                        return false
                default:
                        return true
                }
        }
        var buttonTintColor: UIColor {
                return viewController.isDarkAppearance ? .white : .black
        }
}
