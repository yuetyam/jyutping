import Foundation

/// 全形 / 半形
enum CharacterForm: Int {
        case halfWidth = 1
        case fullWidth = 2
}


/// 標點符號
enum Punctuation: Int {

        case cantonese = 1
        case english = 2

        var isCantoneseMode: Bool {
                return self == .cantonese
        }
}


/// Cantonese / ABC
enum InputMethodMode: Int {

        case cantonese = 1
        case abc = 2

        var isCantonese: Bool {
                return self == .cantonese
        }

        var isABC: Bool {
                return self == .abc
        }
}


struct InstantSettings {

        /// 全形 / 半形
        private(set) static var characterForm: CharacterForm = {
                let savedValue: Int = UserDefaults.standard.integer(forKey: "character_form")
                switch savedValue {
                case 0, 1:
                        return .halfWidth
                case 2:
                        return .fullWidth
                default:
                        return .halfWidth
                }
        }()
        static func updateCharacterFormState(to newState: CharacterForm) {
                characterForm = newState
                let value: Int = newState.rawValue
                UserDefaults.standard.set(value, forKey: "character_form")
        }


        /// 標點符號。粵文句讀 or 英文標點
        private(set) static var punctuation: Punctuation = {
                let savedValue: Int = UserDefaults.standard.integer(forKey: "punctuation")
                switch savedValue {
                case 0, 1:
                        return .cantonese
                case 2:
                        return .english
                default:
                        return .cantonese
                }
        }()
        static func updatePunctuationState(to newState: Punctuation) {
                punctuation = newState
                let value: Int = newState.rawValue
                UserDefaults.standard.set(value, forKey: "punctuation")
        }


        /// 候選詞包含 Emoji
        private(set) static var needsEmojiCandidates: Bool = {
                /// 0: The key "emoji" doesn‘t exist.
                ///
                /// 1: Emoji Suggestions On
                ///
                /// 2: Emoji Suggestions Off
                let savedValue: Int = UserDefaults.standard.integer(forKey: "emoji")
                switch savedValue {
                case 0, 1:
                        return true
                case 2:
                        return false
                default:
                        return true
                }
        }()
        static func updateNeedsEmojiCandidates(to newState: Bool) {
                needsEmojiCandidates = newState
                let value: Int = newState ? 1 : 2
                UserDefaults.standard.set(value, forKey: "emoji")
        }

        private(set) static var inputMethodMode: InputMethodMode = {
                let savedValue: Int = UserDefaults.standard.integer(forKey: "InputMethodMode")
                switch savedValue {
                case 0, 1:
                        return .cantonese
                case 2:
                        return .abc
                default:
                        return .cantonese
                }
        }()
        static func updateInputMethodMode(to newMode: InputMethodMode) {
                inputMethodMode = newMode
                let value: Int = newMode.rawValue
                UserDefaults.standard.set(value, forKey: "InputMethodMode")
        }
}

