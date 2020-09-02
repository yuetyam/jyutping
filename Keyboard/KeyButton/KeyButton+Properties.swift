import UIKit

extension KeyButton {
        
        var width: CGFloat {
                switch keyboardEvent {
                case .none, .keyALeft, .keyLRight, .keyZLeft, .keyBackspaceLeft:
                        return 10
                case .backspace, .shift, .shiftDown, .switchTo(_):
                        return 50
                case .switchInputMethod:
                        return 45
                case .newLine:
                        return 72
                case .space:
                        return 190
                case .text("."):
                        if viewController.keyboardLayout == .alphabetic || viewController.keyboardLayout == .alphabeticUppercase {
                                return 35
                        } else {
                                return 40
                        }
                default:
                        return 40
                }
        }
        
        var height: CGFloat {
                switch traitCollection.userInterfaceIdiom {
                case .phone:
                        if traitCollection.verticalSizeClass == .compact {
                                // iPhone landscape
                                
                                if UIScreen.main.bounds.width < 570 {
                                        return 36 // iPhone SE1, iPod touch 7
                                } else {
                                        return 40
                                }
                        } else {
                                if UIScreen.main.bounds.height < 570 {
                                        // iPhone SE1, iPod touch 7
                                        return 48
                                } else if UIScreen.main.bounds.height < 700 {
                                        // iPhone 6s, 7, 8, SE2
                                        return 53
                                } else {
                                        return 55
                                }
                        }
                case .pad:
                        if viewController.view.bounds.width < 500 {
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
                case .text:
                        if traitCollection.userInterfaceIdiom == .pad && viewController.view.bounds.width > 500 {
                                if UIScreen.main.bounds.width > UIScreen.main.bounds.height {
                                        return UIFontMetrics(forTextStyle: .title1).scaledFont(for: .systemFont(ofSize: 30))
                                } else {
                                        return .preferredFont(forTextStyle: .title1)
                                }
                        } else {
                                return UIFontMetrics(forTextStyle: .title2).scaledFont(for: .systemFont(ofSize: 24))
                        }
                default:
                        if traitCollection.userInterfaceIdiom == .pad && viewController.view.bounds.width > 500 {
                                return .preferredFont(forTextStyle: .title2)
                        } else {
                                return .preferredFont(forTextStyle: .body)
                        }
                }
        }
        
        var keyText: String? {
                switch keyboardEvent {
                case .text(let text):
                        return text
                case .space:
                        return viewController.keyboardLayout.isEnglish ? "English" : "粵  拼"
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
                guard let returnKeyType: UIReturnKeyType = viewController.textDocumentProxy.returnKeyType else { return "return" }
                switch returnKeyType {
                case .continue:
                        return "繼續"
                case .default:
                        return "換行"
                case .done:
                        return "完成"
                case .emergencyCall:
                        return "緊急Call"
                case .go:
                        return "前往"
                case .google:
                        return "Google"
                case .join:
                        return "加入"
                case .next:
                        return "下一個"
                case .route:
                        return "Route"
                case .search:
                        return "搜尋"
                case .send:
                        return "發送"
                case .yahoo:
                        return "Yahoo"
                @unknown default:
                        return "return"
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
                switch viewController.appearance {
                case .lightModeLightAppearance:
                        return shouldBeDarker ? LightMode.lightActionButton : LightMode.lightButton
                case .lightModeDarkAppearance, .darkModeLightAppearance:
                        return shouldBeDarker ? LightMode.darkActionButton : LightMode.darkButton
                case .darkModeDarkAppearance:
                        return shouldBeDarker ? DarkMode.darkActionButton : DarkMode.darkButton
                }
        }
        
        var buttonTintColor: UIColor {
                switch viewController.appearance {
                case .lightModeLightAppearance:
                        return .lightButtonText
                default:
                        return .darkButtonText
                }
        }
        
        var highlightButtonColor: UIColor {
                // action <=> non-action
                switch viewController.appearance {
                case .lightModeLightAppearance:
                        return shouldBeDarker ? LightMode.lightButton : LightMode.lightActionButton
                case .lightModeDarkAppearance, .darkModeLightAppearance:
                        return shouldBeDarker ? LightMode.darkButton : LightMode.darkActionButton
                case .darkModeDarkAppearance:
                        return shouldBeDarker ? DarkMode.darkButton : DarkMode.darkActionButton
                }
        }
        
        private var shouldBeDarker: Bool {
                switch keyboardEvent {
                case .text, .space:
                        return false
                default:
                        return true
                }
        }
}
