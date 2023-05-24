import SwiftUI
import CoreIME

extension CharacterStandard {
        var isSimplified: Bool {
                return self == .simplified
        }
}

struct Options {

        /// 字形標準
        private(set) static var characterStandard: CharacterStandard = {
                let savedValue: Int = UserDefaults.standard.integer(forKey: OptionsKey.CharacterStandard)
                switch savedValue {
                case 0, 1:
                        return .traditional
                case 2:
                        return .hongkong
                case 3:
                        return .taiwan
                case 4:
                        return .simplified
                default:
                        return .traditional
                }
        }()
        static func updateCharacterStandard(to standard: CharacterStandard) {
                characterStandard = standard
                let value: Int = standard.rawValue
                UserDefaults.standard.set(value, forKey: OptionsKey.CharacterStandard)
                Font.updateCandidateFont(characterStandard: standard)
        }

        private(set) static var isAudioFeedbackOn: Bool = {
                let savedValue: Int = UserDefaults.standard.integer(forKey: OptionsKey.AudioFeedback)
                switch savedValue {
                case 0:
                        return false
                case 1:
                        return true
                default:
                        return false
                }
        }()
        static func updateAudioFeedbackStatus(isOn: Bool) {
                isAudioFeedbackOn = isOn
                let value: Int = isOn ? 1 : 0
                UserDefaults.standard.set(value, forKey: OptionsKey.AudioFeedback)
        }

        /// 候選詞是否包含 Emoji
        private(set) static var isEmojiSuggestionsOn: Bool = {
                let savedValue: Int = UserDefaults.standard.integer(forKey: OptionsKey.EmojiSuggestions)
                switch savedValue {
                case 0, 1:
                        return true
                case 2:
                        return false
                default:
                        return true
                }
        }()
        static func updateEmojiSuggestions(to state: Bool) {
                isEmojiSuggestionsOn = state
                let value: Int = state ? 1 : 2
                UserDefaults.standard.set(value, forKey: OptionsKey.EmojiSuggestions)
        }

        /// Cantonese Keyboard Layout. qwerty / SaamPing / TenKey
        private(set) static var keyboardLayout: KeyboardLayout = {
                let savedValue: Int = UserDefaults.standard.integer(forKey: OptionsKey.KeyboardLayout)
                switch savedValue {
                case KeyboardLayout.qwerty.rawValue:
                        return .qwerty
                case KeyboardLayout.saamPing.rawValue:
                        return .saamPing
                case KeyboardLayout.tenKey.rawValue:
                        return .tenKey
                default:
                        return .qwerty
                }
        }()
        static func updateKeyboardLayout(to layout: KeyboardLayout) {
                keyboardLayout = layout
                let value: Int = layout.rawValue
                UserDefaults.standard.set(value, forKey: OptionsKey.KeyboardLayout)
        }

        private(set) static var commentStyle: CommentStyle = {
                let savedValue: Int = UserDefaults.standard.integer(forKey: OptionsKey.CommentStyle)
                switch savedValue {
                case CommentStyle.aboveCandidates.rawValue:
                        return .aboveCandidates
                case CommentStyle.belowCandidates.rawValue:
                        return .belowCandidates
                case CommentStyle.noComments.rawValue:
                        return .noComments
                default:
                        return .aboveCandidates
                }
        }()
        static func updateCommentStyle(to style: CommentStyle) {
                commentStyle = style
                let value: Int = style.rawValue
                UserDefaults.standard.set(value, forKey: OptionsKey.CommentStyle)
        }

        private(set) static var commentToneStyle: CommentToneStyle = {
                let savedValue: Int = UserDefaults.standard.integer(forKey: OptionsKey.CommentToneStyle)
                switch savedValue {
                case CommentToneStyle.normal.rawValue:
                        return .normal
                case CommentToneStyle.superscript.rawValue:
                        return .superscript
                case CommentToneStyle.subscript.rawValue:
                        return .subscript
                default:
                        return .normal
                }
        }()
        static func updateCommentToneStyle(to style: CommentToneStyle) {
                commentToneStyle = style
                let value: Int = style.rawValue
                UserDefaults.standard.set(value, forKey: OptionsKey.CommentToneStyle)
        }

        private(set) static var doubleSpaceShortcut: DoubleSpaceShortcut = {
                let savedValue: Int = UserDefaults.standard.integer(forKey: OptionsKey.DoubleSpaceShortcut)
                switch savedValue {
                case DoubleSpaceShortcut.insertPeriod.rawValue:
                        return .insertPeriod
                case DoubleSpaceShortcut.doNothing.rawValue:
                        return .doNothing
                case DoubleSpaceShortcut.insertIdeographicComma.rawValue:
                        return .insertIdeographicComma
                case DoubleSpaceShortcut.insertFullWidthSpace.rawValue:
                        return .insertFullWidthSpace
                default:
                        return .insertPeriod
                }
        }()
        static func updateDoubleSpaceShortcut(to shortcut: DoubleSpaceShortcut) {
                doubleSpaceShortcut = shortcut
                let value: Int = shortcut.rawValue
                UserDefaults.standard.set(value, forKey: OptionsKey.DoubleSpaceShortcut)
        }
}

struct OptionsKey {
        static let CharacterStandard: String = "logogram"
        static let AudioFeedback: String = "audio_feedback"
        static let HapticFeedback: String = "haptic_feedback"
        static let EmojiSuggestions: String = "emoji"
        static let KeyboardLayout: String = "keyboard_layout"
        static let CommentStyle: String = "jyutping_display"
        static let CommentToneStyle: String = "tone_style"
        static let DoubleSpaceShortcut: String = "double_space_shortcut"
}

enum CommentStyle: Int {
        case aboveCandidates = 1
        case belowCandidates = 2
        case noComments = 3
}
enum CommentToneStyle: Int {
        case normal = 1
        case superscript = 2
        case `subscript` = 3
        case noTones = 4
}
enum DoubleSpaceShortcut: Int {
        case insertPeriod = 1
        case doNothing = 2
        case insertIdeographicComma = 3
        case insertFullWidthSpace = 4
}
