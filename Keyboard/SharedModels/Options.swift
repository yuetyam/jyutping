import SwiftUI
import CoreIME
import CommonExtensions

struct Options {

        /// 字形標準
        nonisolated(unsafe) private(set) static var characterStandard: CharacterStandard = {
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

        nonisolated(unsafe) private(set) static var isAudioFeedbackOn: Bool = {
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

        nonisolated(unsafe) private(set) static var showLowercaseKeys: Bool = {
                let savedValue: Int = UserDefaults.standard.integer(forKey: OptionsKey.KeyCase)
                switch savedValue {
                case 0, 1:
                        return true
                case 2:
                        return false
                default:
                        return true
                }
        }()
        static func updateShowLowercaseKeys(to state: Bool) {
                showLowercaseKeys = state
                let value: Int = state ? 1 : 2
                UserDefaults.standard.set(value, forKey: OptionsKey.KeyCase)
        }
        nonisolated(unsafe) private(set) static var keyTextPreview: Bool = {
                let savedValue: Int = UserDefaults.standard.integer(forKey: OptionsKey.KeyTextPreview)
                switch savedValue {
                case 0, 1:
                        return true
                case 2:
                        return false
                default:
                        return true
                }
        }()
        static func updateKeyTextPreview(to state: Bool) {
                keyTextPreview = state
                let value: Int = state ? 1 : 2
                UserDefaults.standard.set(value, forKey: OptionsKey.KeyTextPreview)
        }

        nonisolated(unsafe) private(set) static var commentStyle: CommentStyle = {
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

        nonisolated(unsafe) private(set) static var commentToneStyle: CommentToneStyle = {
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

        nonisolated(unsafe) private(set) static var isEmojiSuggestionsOn: Bool = {
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
        static func updateEmojiSuggestions(to isOn: Bool) {
                isEmojiSuggestionsOn = isOn
                let value: Int = isOn ? 1 : 2
                UserDefaults.standard.set(value, forKey: OptionsKey.EmojiSuggestions)
        }

        nonisolated(unsafe) private(set) static var cangjieVariant: CangjieVariant = {
                let savedValue: Int = UserDefaults.standard.integer(forKey: OptionsKey.CangjieVariant)
                switch savedValue {
                case CangjieVariant.cangjie5.rawValue:
                        return .cangjie5
                case CangjieVariant.cangjie3.rawValue:
                        return .cangjie3
                case CangjieVariant.quick5.rawValue:
                        return .quick5
                case CangjieVariant.quick3.rawValue:
                        return .quick3
                default:
                        return .cangjie5
                }
        }()
        static func updateCangjieVariant(to variant: CangjieVariant) {
                cangjieVariant = variant
                let value: Int = variant.rawValue
                UserDefaults.standard.set(value, forKey: OptionsKey.CangjieVariant)
        }

        nonisolated(unsafe) private(set) static var preferredLanguage: PreferredLanguage = {
                let languages = Locale.preferredLanguages
                guard languages.isNotEmpty else { return .english }
                let englishIndex = languages.firstIndex(where: { $0.hasPrefix("en") }) ?? 1000
                let cantoneseIndex = languages.firstIndex(where: { $0.hasPrefix("yue") || $0.hasPrefix("zh") }) ?? 1000
                return (englishIndex <= cantoneseIndex) ? .english : .cantonese
        }()
        static func updatePreferredLanguage(to language: PreferredLanguage) {
                preferredLanguage = language
                let codes: [String] = Locale.preferredLanguages
                let languageCodes: [String] = {
                        // TODO: This code block needs more tests
                        switch language {
                        case .cantonese:
                                let nonEnglishCodes: [String] = codes.filter({ $0.hasPrefix("en").negative })
                                let hasChineseCodes: Bool = nonEnglishCodes.contains(where: { $0.hasPrefix("yue") || $0.hasPrefix("zh") })
                                let insertCodes: [String] = hasChineseCodes ? [] : ["yue"]
                                return (nonEnglishCodes + insertCodes + codes).uniqued()
                        case .english:
                                let firstEnglish: String = codes.first(where: { $0.hasPrefix("en") }) ?? "en"
                                return ([firstEnglish] + codes).uniqued()
                        }
                }()
                UserDefaults.standard.set(languageCodes, forKey: "AppleLanguages")
        }

        nonisolated(unsafe) private(set) static var isInputMemoryOn: Bool = {
                let savedValue: Int = UserDefaults.standard.integer(forKey: OptionsKey.UserLexiconInputMemory)
                switch savedValue {
                case 0, 1:
                        return true
                case 2:
                        return false
                default:
                        return true
                }
        }()
        static func updateInputMemory(to isOn: Bool) {
                isInputMemoryOn = isOn
                let value: Int = isOn ? 1 : 2
                UserDefaults.standard.set(value, forKey: OptionsKey.UserLexiconInputMemory)
        }
}

struct OptionsKey {
        static let CharacterStandard: String = "logogram"
        static let AudioFeedback: String = "audio_feedback"
        static let HapticFeedback: String = "haptic_feedback"
        static let KeyboardLayout: String = "keyboard_layout"
        static let KeyCase: String = "KeyCase"
        static let KeyTextPreview: String = "KeyPreview"
        static let CommentStyle: String = "jyutping_display"
        static let CommentToneStyle: String = "tone_style"
        static let EmojiSuggestions: String = "emoji"
        static let CangjieVariant: String = "CangjieVariant"
        static let UserLexiconInputMemory: String = "UserLexiconInputMemory"

        // @available(*, deprecated)
        // static let DoubleSpaceShortcut: String = "double_space_shortcut"

        // @available(*, deprecated)
        // static let PasteButtonStyle: String = "PasteButtonStyle"
}

enum CommentStyle: Int {
        case aboveCandidates = 1
        case belowCandidates = 2
        case noComments = 3
        var isAbove: Bool { self == .aboveCandidates }
        var isBelow: Bool { self == .belowCandidates }
        var isHidden: Bool { self == .noComments }
}
enum CommentToneStyle: Int {
        case normal = 1
        case superscript = 2
        case `subscript` = 3
        case noTones = 4
}

/// Keyboard UI Display Language
enum PreferredLanguage: Int {
        case cantonese = 1
        case english = 2
}

/*
@available(*, deprecated)
enum DoubleSpaceShortcut: Int {
        case insertPeriod = 1
        case doNothing = 2
        case insertIdeographicComma = 3
        case insertFullWidthSpace = 4
}

@available(*, deprecated)
enum PasteButtonStyle: Int {
        case `default` = 1
        case system = 2
        var isSystem: Bool {
                return self == .system
        }
}
*/
