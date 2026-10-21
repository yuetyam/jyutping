import SwiftUI
import CoreIME
import CommonExtensions

struct Options {

        nonisolated(unsafe) private(set) static var needsNumberRow: Bool = {
                let savedValue: Int = UserDefaults.standard.integer(forKey: UserSettingsKey.NumberRow)
                return savedValue == 1
        }()
        static func updateNumberRowState(to isOn: Bool) {
                needsNumberRow = isOn
                let value: Int = isOn ? 1 : 2
                UserDefaults.standard.set(value, forKey: UserSettingsKey.NumberRow)
        }

        nonisolated(unsafe) private(set) static var showLowercaseKeys: Bool = {
                let savedValue: Int = UserDefaults.standard.integer(forKey: UserSettingsKey.KeyCase)
                return savedValue != 2
        }()
        static func updateShowLowercaseKeys(to state: Bool) {
                showLowercaseKeys = state
                let value: Int = state ? 1 : 2
                UserDefaults.standard.set(value, forKey: UserSettingsKey.KeyCase)
        }

        static func fetchKeyTextPreviewState() -> Bool {
                let savedValue: Int = UserDefaults.standard.integer(forKey: UserSettingsKey.KeyTextPreview)
                return savedValue != 2
        }
        static func saveKeyTextPreview(state: Bool) {
                let value: Int = state ? 1 : 2
                UserDefaults.standard.set(value, forKey: UserSettingsKey.KeyTextPreview)
        }

        static func fetchKeyHeightOffset() -> CGFloat {
                let savedValue: Int = UserDefaults.standard.integer(forKey: UserSettingsKey.KeyHeightOffset)
                return CGFloat(savedValue)
        }

        nonisolated(unsafe) private(set) static var commentStyle: CommentStyle = {
                let savedValue: Int = UserDefaults.standard.integer(forKey: UserSettingsKey.CommentStyle)
                return CommentStyle.style(of: savedValue)
        }()
        static func updateCommentStyle(to style: CommentStyle) {
                commentStyle = style
                let value: Int = style.rawValue
                UserDefaults.standard.set(value, forKey: UserSettingsKey.CommentStyle)
        }

        nonisolated(unsafe) private(set) static var commentScene: CommentScene = {
                let savedValue: Int = UserDefaults.standard.integer(forKey: UserSettingsKey.CommentScene)
                return CommentScene.scene(of: savedValue)
        }()
        static func updateCommentScene(to scene: CommentScene) {
                commentScene = scene
                let value: Int = scene.rawValue
                UserDefaults.standard.set(value, forKey: UserSettingsKey.CommentScene)
        }

        nonisolated(unsafe) private(set) static var commentToneStyle: CommentToneStyle = {
                let savedValue: Int = UserDefaults.standard.integer(forKey: UserSettingsKey.CommentToneStyle)
                return CommentToneStyle.style(of: savedValue)
        }()
        static func updateCommentToneStyle(to style: CommentToneStyle) {
                commentToneStyle = style
                let value: Int = style.rawValue
                UserDefaults.standard.set(value, forKey: UserSettingsKey.CommentToneStyle)
        }

        nonisolated(unsafe) private(set) static var traditionalCharacterStandard: CharacterStandard = {
                let savedValue: Int = UserDefaults.standard.integer(forKey: UserSettingsKey.TraditionalCharacterStandard)
                return CharacterStandard.standard(of: savedValue)
        }()
        static func updateTraditionalCharacterStandard(to standard: CharacterStandard) {
                traditionalCharacterStandard = standard
                let value: Int = standard.rawValue
                UserDefaults.standard.set(value, forKey: UserSettingsKey.TraditionalCharacterStandard)
        }

        nonisolated(unsafe) private(set) static var cangjieVariant: CangjieVariant = {
                let savedValue: Int = UserDefaults.standard.integer(forKey: UserSettingsKey.CangjieVariant)
                return CangjieVariant.variant(of: savedValue)
        }()
        static func updateCangjieVariant(to variant: CangjieVariant) {
                cangjieVariant = variant
                let value: Int = variant.rawValue
                UserDefaults.standard.set(value, forKey: UserSettingsKey.CangjieVariant)
        }

        nonisolated(unsafe) private(set) static var isEmojiSuggestionsOn: Bool = {
                let savedValue: Int = UserDefaults.standard.integer(forKey: UserSettingsKey.EmojiSuggestions)
                return savedValue != 2
        }()
        static func updateEmojiSuggestions(to isOn: Bool) {
                isEmojiSuggestionsOn = isOn
                let value: Int = isOn ? 1 : 2
                UserDefaults.standard.set(value, forKey: UserSettingsKey.EmojiSuggestions)
        }

        nonisolated(unsafe) private(set) static var isEnglishSuggestionsOn: Bool = {
                let savedValue: Int = UserDefaults.standard.integer(forKey: UserSettingsKey.EnglishSuggestions)
                return savedValue != 2
        }()
        static func updateEnglishSuggestions(to isOn: Bool) {
                isEnglishSuggestionsOn = isOn
                let value: Int = isOn ? 1 : 2
                UserDefaults.standard.set(value, forKey: UserSettingsKey.EnglishSuggestions)
        }

        nonisolated(unsafe) private(set) static var isTextReplacementsOn: Bool = {
                let savedValue: Int = UserDefaults.standard.integer(forKey: UserSettingsKey.SystemLexicon)
                return savedValue != 2
        }()
        static func updateTextReplacementsMode(to isOn: Bool) {
                isTextReplacementsOn = isOn
                let value: Int = isOn ? 1 : 2
                UserDefaults.standard.set(value, forKey: UserSettingsKey.SystemLexicon)
        }

        nonisolated(unsafe) private(set) static var isCompatibleModeOn: Bool = {
                let savedValue: Int = UserDefaults.standard.integer(forKey: UserSettingsKey.SchemeRules)
                return savedValue == 1
        }()
        static func updateCompatibleMode(to isOn: Bool) {
                isCompatibleModeOn = isOn
                let value: Int = isOn ? 1 : 0
                UserDefaults.standard.set(value, forKey: UserSettingsKey.SchemeRules)
        }

        nonisolated(unsafe) private(set) static var preferredLanguage: KeyboardDisplayLanguage = {
                let savedValue: Int = UserDefaults.standard.integer(forKey: UserSettingsKey.KeyboardDisplayLanguage)
                return KeyboardDisplayLanguage.language(of: savedValue)
        }()
        static func updatePreferredLanguage(to language: KeyboardDisplayLanguage) {
                preferredLanguage = language
                UserDefaults.standard.set(language.rawValue, forKey: UserSettingsKey.KeyboardDisplayLanguage)
                guard let languageCode = language.languageCode else {
                        UserDefaults.standard.removeObject(forKey: UserSettingsKey.AppleLanguages)
                        return
                }
                let preferredCodes: [String] = [languageCode, "yue-Hant-HK", "zh-Hant-HK"]
                let oldCodes: [String] = Locale.preferredLanguages
                let newCodes: [String] = (preferredCodes + oldCodes).distinct()
                UserDefaults.standard.set(newCodes, forKey: UserSettingsKey.AppleLanguages)
        }

        nonisolated(unsafe) private(set) static var isInputMemoryOn: Bool = {
                let savedValue: Int = UserDefaults.standard.integer(forKey: UserSettingsKey.UserLexiconInputMemory)
                return savedValue != 2
        }()
        static func updateInputMemory(to isOn: Bool) {
                isInputMemoryOn = isOn
                let value: Int = isOn ? 1 : 2
                UserDefaults.standard.set(value, forKey: UserSettingsKey.UserLexiconInputMemory)
        }
}

enum CommentScene: Int, CaseIterable {
        case all = 1
        case reverseLookup = 2
        case noneOfAll = 3
        static func scene(of value: Int) -> CommentScene {
                return allCases.first(where: { $0.rawValue == value }) ?? .all
        }
}
enum CommentStyle: Int, CaseIterable {
        case aboveCandidates = 1
        case belowCandidates = 2
        case noComments = 3
        static func style(of value: Int) -> CommentStyle {
                guard value != noComments.rawValue else { return .aboveCandidates }
                return allCases.first(where: { $0.rawValue == value }) ?? .aboveCandidates
        }
        var isAbove: Bool { self == .aboveCandidates }
        var isBelow: Bool { self == .belowCandidates }
        var isHidden: Bool { self == .noComments }
}
enum CommentToneStyle: Int, CaseIterable {
        case normal = 1
        case superscript = 2
        case `subscript` = 3
        case noTones = 4
        static func style(of value: Int) -> CommentToneStyle {
                return allCases.first(where: { $0.rawValue == value }) ?? .normal
        }
}

/// Preferred Keyboard UI Display Language
enum KeyboardDisplayLanguage: Int, CaseIterable {

        case auto = 1
        case cantonese = 2
        case chineseHongKong = 3
        case english = 4
        case french = 5
        case japanese = 6

        static func language(of value: Int) -> KeyboardDisplayLanguage {
                return allCases.first(where: { $0.rawValue == value }) ?? .auto
        }

        var languageCode: String? {
                switch self {
                case .auto: nil
                case .cantonese: "yue-Hant-HK"
                case .chineseHongKong: "zh-Hant-HK"
                case .english: "en"
                case .french: "fr"
                case .japanese: "ja"
                }
        }
}

/*
@available(*, deprecated)
enum PasteButtonStyle: Int {
        case `default` = 1
        case system = 2
        var isSystem: Bool {
                return self == .system
        }
}
*/
