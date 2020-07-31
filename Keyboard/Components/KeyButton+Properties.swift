import UIKit

extension KeyButton {
        
        var width: CGFloat {
                switch keyboardEvent {
                case .none:
                        return 10
                case .backspace, .shift, .shiftDown, .switchTo(_), .switchInputMethod:
                        return 50
                case .newLine:
                        return 80
                case .space:
                        return 200
                default:
                        return 40
                }
        }
        
        var height: CGFloat {
                switch traitCollection.userInterfaceIdiom {
                case .phone:
                        if UIScreen.main.bounds.width > UIScreen.main.bounds.height {
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
                        let currentLayout = viewController.keyboardLayout
                        if currentLayout == .alphabetLowercase ||
                                currentLayout == .alphabetUppercase ||
                                currentLayout == .numericAlphabet ||
                                currentLayout == .symbolicAlphabet {
                                return "English"
                        } else {
                                return "粵  拼"
                        }
                case .switchTo(let type):
                        return keyText(for: type)
                default:
                        return nil
                }
        }
        
        private func keyText(for keyboardType: KeyboardLayout) -> String {
                switch keyboardType {
                case .numericJyutping, .numericAlphabet:
                        return "123"
                case .symbolicJyutping, .symbolicAlphabet:
                        return "#+="
                case .jyutping:
                        return "粵"
                case .cantoneseSymbolic:
                        return "符"
                case .alphabetLowercase:
                        return "EN"
                default:
                        return "??"
                }
        }
        
        var keyImage: UIImage? {
                switch keyboardEvent {
                case .switchInputMethod:
                        return UIImage(systemName: "globe")
                case .backspace:
                        return UIImage(systemName: "delete.left")
                case .newLine:
                        return UIImage(systemName: "return")
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
