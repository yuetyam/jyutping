import Foundation
import CoreIME

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
}

struct OptionsKey {
        static let CharacterStandard: String = "logogram"
        static let AudioFeedback: String = "audio_feedback"
        static let HapticFeedback: String = "haptic_feedback"
        static let EmojiSuggestions: String = "emoji"
        static let KeyboardLayout: String = "keyboard_layout"
        static let JyutpingDisplay: String = "jyutping_display"
        static let ToneStyle: String = "tone_style"
        static let DoubleSpaceShortcut: String = "double_space_shortcut"
}
