import Foundation
import CoreIME
import CommonExtensions

extension CharacterStandard {
        fileprivate var legacyRawValue: Int? {
                switch self {
                case .hongkong: 2
                case .taiwan: 3
                case .mutilated: 4
                default: nil
                }
        }
        var isPreset: Bool { self == .preset }
}

struct Options {

        /// 字形標準
        nonisolated(unsafe) private(set) static var legacyCharacterStandard: CharacterStandard = {
                let hasSavedValue: Bool = UserDefaults.standard.object(forKey: OptionsKey.LegacyCharacterStandard) != nil
                let hasOldKeySavedValue: Bool = UserDefaults.standard.object(forKey: LegacyOptionsKey.OldCharacterStandardKey) != nil
                defer {
                        if hasOldKeySavedValue {
                                UserDefaults.standard.removeObject(forKey: LegacyOptionsKey.OldCharacterStandardKey)
                        }
                }
                if hasSavedValue.negative && hasOldKeySavedValue {
                        let savedValue: Int = UserDefaults.standard.integer(forKey: LegacyOptionsKey.OldCharacterStandardKey)
                        UserDefaults.standard.set(savedValue, forKey: OptionsKey.LegacyCharacterStandard)
                        return CharacterStandard.allCases.first(where: { $0.legacyRawValue == savedValue }) ?? .preset
                } else {
                        let savedValue: Int = UserDefaults.standard.integer(forKey: OptionsKey.LegacyCharacterStandard)
                        return CharacterStandard.allCases.first(where: { $0.legacyRawValue == savedValue }) ?? .preset
                }
        }()
        static func updateLegacyCharacterStandard(to standard: CharacterStandard) {
                legacyCharacterStandard = standard
                let value: Int = standard.legacyRawValue ?? 1
                UserDefaults.standard.set(value, forKey: OptionsKey.LegacyCharacterStandard)
        }

        /// 「傳統漢字」字形標準
        nonisolated(unsafe) private(set) static var traditionalCharacterStandard: CharacterStandard = {
                let savedValue: Int = UserDefaults.standard.integer(forKey: OptionsKey.TraditionalCharacterStandard)
                return CharacterStandard.standard(of: savedValue)
        }()
        static func updateTraditionalCharacterStandard(to standard: CharacterStandard) {
                traditionalCharacterStandard = standard
                let value: Int = standard.rawValue
                UserDefaults.standard.set(value, forKey: OptionsKey.TraditionalCharacterStandard)
        }

        /// 半寬／全寬數字、字母
        nonisolated(unsafe) private(set) static var characterForm: CharacterForm = {
                let hasSavedValue: Bool = UserDefaults.standard.object(forKey: OptionsKey.CharacterForm) != nil
                let hasLegacySavedValue: Bool = UserDefaults.standard.object(forKey: LegacyOptionsKey.CharacterForm) != nil
                defer {
                        if hasLegacySavedValue {
                                UserDefaults.standard.removeObject(forKey: LegacyOptionsKey.CharacterForm)
                        }
                }
                if hasSavedValue.negative && hasLegacySavedValue {
                        let savedValue: Int = UserDefaults.standard.integer(forKey: LegacyOptionsKey.CharacterForm)
                        UserDefaults.standard.set(savedValue, forKey: OptionsKey.CharacterForm)
                        return CharacterForm.allCases.first(where: { $0.rawValue == savedValue }) ?? .halfWidth
                } else {
                        let savedValue: Int = UserDefaults.standard.integer(forKey: OptionsKey.CharacterForm)
                        return CharacterForm.allCases.first(where: { $0.rawValue == savedValue }) ?? .halfWidth
                }
        }()
        static func updateCharacterForm(to form: CharacterForm) {
                characterForm = form
                let value: Int = form.rawValue
                UserDefaults.standard.set(value, forKey: OptionsKey.CharacterForm)
        }

        /// 標點符號形態. 粵文句讀／英文標點
        nonisolated(unsafe) private(set) static var punctuationForm: PunctuationForm = {
                let hasSavedValue: Bool = UserDefaults.standard.object(forKey: OptionsKey.PunctuationForm) != nil
                let hasLegacySavedValue: Bool = UserDefaults.standard.object(forKey: LegacyOptionsKey.PunctuationForm) != nil
                defer {
                        if hasLegacySavedValue {
                                UserDefaults.standard.removeObject(forKey: LegacyOptionsKey.PunctuationForm)
                        }
                }
                if hasSavedValue.negative && hasLegacySavedValue {
                        let savedValue: Int = UserDefaults.standard.integer(forKey: LegacyOptionsKey.PunctuationForm)
                        UserDefaults.standard.set(savedValue, forKey: OptionsKey.PunctuationForm)
                        return PunctuationForm.allCases.first(where: { $0.rawValue == savedValue }) ?? .cantonese
                } else {
                        let savedValue: Int = UserDefaults.standard.integer(forKey: OptionsKey.PunctuationForm)
                        return PunctuationForm.allCases.first(where: { $0.rawValue == savedValue }) ?? .cantonese
                }
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
        static let LegacyCharacterStandard: String = "LegacyCharacterStandard"
        static let TraditionalCharacterStandard: String = "TraditionalCharacterStandard"
        static let CharacterForm: String = "CharacterForm"
        static let PunctuationForm: String = "PunctuationForm"
        static let InputMethodMode: String = "InputMethodMode"
}
private struct LegacyOptionsKey {
        static let OldCharacterStandardKey: String = "characters"
        static let CharacterForm: String = "character_form"
        static let PunctuationForm: String = "punctuation"
}

/// 半寬／全寬數字、字母
enum CharacterForm: Int, CaseIterable {
        case halfWidth = 1
        case fullWidth = 2
        var isHalfWidth: Bool { self == .halfWidth }
        var isFullWidth: Bool { self == .fullWidth }
}

/// 標點符號形態
enum PunctuationForm: Int, CaseIterable {
        case cantonese = 1
        case english = 2
        var isCantoneseMode: Bool { self == .cantonese }
        var isEnglishMode: Bool { self == .english }
}

/// Cantonese / ABC input mode
enum InputMethodMode: Int, CaseIterable {
        case cantonese = 1
        case abc = 2
        var isCantonese: Bool { self == .cantonese }
        var isABC: Bool { self == .abc }
}
