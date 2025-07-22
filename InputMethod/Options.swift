import Foundation
import CoreIME

struct Options {

        /// 字形標準
        nonisolated(unsafe) private(set) static var characterStandard: CharacterStandard = {
                let savedValue: Int = UserDefaults.standard.integer(forKey: OptionsKey.CharacterStandard)
                return CharacterStandard.standard(of: savedValue)
        }()
        static func updateCharacterStandard(to standard: CharacterStandard) {
                characterStandard = standard
                let value: Int = standard.rawValue
                UserDefaults.standard.set(value, forKey: OptionsKey.CharacterStandard)
        }

        /// 半寬／全寬數字、字母
        nonisolated(unsafe) private(set) static var characterForm: CharacterForm = {
                let savedValue: Int = UserDefaults.standard.integer(forKey: OptionsKey.CharacterForm)
                return (savedValue == CharacterForm.fullWidth.rawValue) ? .fullWidth : .halfWidth
        }()
        static func updateCharacterForm(to form: CharacterForm) {
                characterForm = form
                let value: Int = form.rawValue
                UserDefaults.standard.set(value, forKey: OptionsKey.CharacterForm)
        }

        /// 標點符號形態. 粵文句讀／英文標點
        nonisolated(unsafe) private(set) static var punctuationForm: PunctuationForm = {
                let savedValue: Int = UserDefaults.standard.integer(forKey: OptionsKey.PunctuationForm)
                return (savedValue == PunctuationForm.english.rawValue) ? .english : .cantonese
        }()
        static func updatePunctuationForm(to form: PunctuationForm) {
                punctuationForm = form
                let value: Int = form.rawValue
                UserDefaults.standard.set(value, forKey: OptionsKey.PunctuationForm)
        }

        /// 輸入法模式. Cantonese / ABC
        nonisolated(unsafe) private(set) static var inputMethodMode: InputMethodMode = {
                let savedValue: Int = UserDefaults.standard.integer(forKey: OptionsKey.InputMethodMode)
                return (savedValue == InputMethodMode.abc.rawValue) ? .abc : .cantonese
        }()
        static func updateInputMethodMode(to mode: InputMethodMode) {
                inputMethodMode = mode
                let value: Int = mode.rawValue
                UserDefaults.standard.set(value, forKey: OptionsKey.InputMethodMode)
        }
}

private struct OptionsKey {
        static let CharacterStandard: String = "characters"
        static let CharacterForm: String = "character_form"
        static let PunctuationForm: String = "punctuation"
        static let InputMethodMode: String = "InputMethodMode"
}

/// 半寬／全寬數字、字母
enum CharacterForm: Int {
        case halfWidth = 1
        case fullWidth = 2
        var isHalfWidth: Bool {
                return self == .halfWidth
        }
        var isFullWidth: Bool {
                return self == .fullWidth
        }
}

/// 標點符號形態
enum PunctuationForm: Int {
        case cantonese = 1
        case english = 2
        var isCantoneseMode: Bool {
                return self == .cantonese
        }
        var isEnglishMode: Bool {
                return self == .english
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
