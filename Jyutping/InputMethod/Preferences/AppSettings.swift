import SwiftUI

struct SettingsKeys {
        static let CandidatePageSize: String = "CandidatePageSize"
        static let CandidateLineSpacing: String = "CandidateLineSpacing"
        static let ToneDisplayStyle: String = "ToneDisplayStyle"


        static let CandidateFontSize: String = "CandidateFontSize"
        static let CommentFontSize: String = "CommentFontSize"
        static let LabelFontSize: String = "LabelFontSize"

        static let CandidateFontMode: String = "CandidateFontMode"
        static let CommentFontMode: String = "CommentFontMode"
        static let LabelFontMode: String = "LabelFontMode"

        static let CustomCandidateFontList: String = "CustomCandidateFontList"
        static let CustomCommentFontList: String = "CustomCommentFontList"
        static let CustomLabelFontList: String = "CustomLabelFontList"


        static let PressShiftOnce: String = "PressShiftOnce"
        static let ShiftSpaceCombination: String = "ShiftSpaceCombination"
        // static let SpeakCandidate: String = "SpeakCandidate"
}

enum ToneDisplayStyle: Int {

        case normal = 1
        case noTones = 2
        case superscript = 3
        case `subscript` = 4

        static func style(of value: Int) -> ToneDisplayStyle {
                switch value {
                case 1:
                        return .normal
                case 2:
                        return .noTones
                case 3:
                        return .superscript
                case 4:
                        return .subscript
                default:
                        return .normal
                }
        }
}

enum FontMode: Int {

        case `default` = 1
        case system = 2
        case custom = 3

        static func mode(of value: Int) -> FontMode {
                switch value {
                case 1:
                        return .default
                case 2:
                        return .system
                case 3:
                        return .custom
                default:
                        return .default
                }
        }
}

enum PressShiftOnce: Int {
        case doNothing = 1
        case switchCantoneseEnglish = 2
}

enum ShiftSpaceCombination: Int {
        case inputFullWidthSpace = 1
        case switchCantoneseEnglish = 2
}

struct AppSettings {

        // MARK: - Page Size

        private(set) static var displayCandidatePageSize: Int = {
                let savedValue: Int = UserDefaults.standard.integer(forKey: SettingsKeys.CandidatePageSize)
                let isSavedValueValid: Bool = pageSizeValidity(of: savedValue)
                guard isSavedValueValid else { return 10 }
                return savedValue
        }()
        static func updateDisplayCandidatePageSize(to newPageSize: Int) {
                let isNewPageSizeValid: Bool = pageSizeValidity(of: newPageSize)
                guard isNewPageSizeValid else { return }
                displayCandidatePageSize = newPageSize
        }
        private static func pageSizeValidity(of value: Int) -> Bool {
                return value > 4 && value < 11
        }

        private(set) static var candidateLineSpacing: Int = {
                let savedValue: Int = UserDefaults.standard.integer(forKey: SettingsKeys.CandidateLineSpacing)
                let isSavedValueValid: Bool = lineSpacingValidity(of: savedValue)
                guard isSavedValueValid else { return 6 }
                return savedValue
        }()
        static func updateCandidateLineSpacing(to newLineSpacing: Int) {
                let isNewLineSpacingValid: Bool = lineSpacingValidity(of: newLineSpacing)
                guard isNewLineSpacingValid else { return }
                candidateLineSpacing = newLineSpacing
        }
        private static func lineSpacingValidity(of value: Int) -> Bool {
                return value > 1 && value < 13
        }


        // MARK: - Tones Display Style

        private(set) static var toneDisplayStyle: ToneDisplayStyle = {
                let savedValue: Int = UserDefaults.standard.integer(forKey: SettingsKeys.ToneDisplayStyle)
                switch savedValue {
                case 0, 1:
                        return .normal
                case 2:
                        return .noTones
                case 3:
                        return .superscript
                case 4:
                        return .subscript
                default:
                        return .normal
                }
        }()
        static func updateToneDisplayStyle(to value: Int) {
                let newStyle: ToneDisplayStyle = ToneDisplayStyle.style(of: value)
                toneDisplayStyle = newStyle
        }


        // MARK: - Font Size

        private(set) static var candidateFontSize: CGFloat = {
                let savedValue: Int = UserDefaults.standard.integer(forKey: SettingsKeys.CandidateFontSize)
                let isSavedValueValid: Bool = fontSizeValidity(of: savedValue)
                guard isSavedValueValid else { return 17 }
                return CGFloat(savedValue)
        }()
        static func updateCandidateFontSize(to newFontSize: Int) {
                let isNewFontSizeValid: Bool = fontSizeValidity(of: newFontSize)
                guard isNewFontSizeValid else { return }
                candidateFontSize = CGFloat(newFontSize)
        }

        private(set) static var commentFontSize: CGFloat = {
                let savedValue: Int = UserDefaults.standard.integer(forKey: SettingsKeys.CommentFontSize)
                let isSavedValueValid: Bool = fontSizeValidity(of: savedValue)
                guard isSavedValueValid else { return 15 }
                return CGFloat(savedValue)
        }()
        static func updateCommentFontSize(to newFontSize: Int) {
                let isNewFontSizeValid: Bool = fontSizeValidity(of: newFontSize)
                guard isNewFontSizeValid else { return }
                commentFontSize = CGFloat(newFontSize)
        }

        private(set) static var labelFontSize: CGFloat = {
                let savedValue: Int = UserDefaults.standard.integer(forKey: SettingsKeys.LabelFontSize)
                let isSavedValueValid: Bool = fontSizeValidity(of: savedValue)
                guard isSavedValueValid else { return 15 }
                return CGFloat(savedValue)
        }()
        static func updateLabelFontSize(to newFontSize: Int) {
                let isNewFontSizeValid: Bool = fontSizeValidity(of: newFontSize)
                guard isNewFontSizeValid else { return }
                labelFontSize = CGFloat(newFontSize)
        }

        private static func fontSizeValidity(of value: Int) -> Bool {
                return value > 11 && value < 23
        }


        // MARK: - Font Mode

        private(set) static var candidateFontMode: FontMode = {
                let savedValue: Int = UserDefaults.standard.integer(forKey: SettingsKeys.CandidateFontMode)
                switch savedValue {
                case 0, 1:
                        return .default
                case 2:
                        return .system
                case 3:
                        return .custom
                default:
                        return .default
                }
        }()
        static func updateCandidateFontMode(to newMode: FontMode) {
                candidateFontMode = newMode
        }

        private(set) static var commentFontMode: FontMode = {
                let savedValue: Int = UserDefaults.standard.integer(forKey: SettingsKeys.CommentFontMode)
                switch savedValue {
                case 0, 1:
                        return .default
                case 2:
                        return .system
                case 3:
                        return .custom
                default:
                        return .default
                }
        }()
        static func updateCommentFontMode(to newMode: FontMode) {
                commentFontMode = newMode
        }

        private(set) static var labelFontMode: FontMode = {
                let savedValue: Int = UserDefaults.standard.integer(forKey: SettingsKeys.LabelFontMode)
                switch savedValue {
                case 0, 1:
                        return .default
                case 2:
                        return .system
                case 3:
                        return .custom
                default:
                        return .default
                }
        }()
        static func updateLabelFontMode(to newMode: FontMode) {
                labelFontMode = newMode
        }


        // MARK: - Custom Fonts

        private(set) static var customCandidateFonts: [String] = {
                let fallback: [String] = ["PingFang HK"]
                let savedValue = UserDefaults.standard.string(forKey: SettingsKeys.CustomCandidateFontList)
                guard let fontList = savedValue else { return fallback }
                let names: [String] = fontList.components(separatedBy: ",").filter({ !($0.isEmpty) }).map({ $0.trimmed() }).uniqued()
                guard !(names.isEmpty) else { return fallback }
                return names
        }()
        static func updateCustomCandidateFonts(to fontNames: [String]) {
                let names: [String] = fontNames.filter({ !($0.isEmpty) }).map({ $0.trimmed() }).uniqued()
                guard !(names.isEmpty) else { return }
                customCandidateFonts = names
                let primary: String? = names.first
                let fallbacks: [String] = Array<String>(names.dropFirst())
                Font.updateCandidateFont(primary: primary, fallbacks: fallbacks, size: candidateFontSize)
        }

        private(set) static var customCommentFonts: [String] = {
                let fallback: [String] = ["Helvetica Neue"]
                let savedValue = UserDefaults.standard.string(forKey: SettingsKeys.CustomCommentFontList)
                guard let fontList = savedValue else { return fallback }
                let names: [String] = fontList.components(separatedBy: ",").filter({ !($0.isEmpty) }).map({ $0.trimmed() }).uniqued()
                guard !(names.isEmpty) else { return fallback }
                return names
        }()
        static func updateCustomCommentFonts(to fontNames: [String]) {
                let names: [String] = fontNames.filter({ !($0.isEmpty) }).map({ $0.trimmed() }).uniqued()
                guard !(names.isEmpty) else { return }
                customCommentFonts = names
                let primary: String? = names.first
                let fallbacks: [String] = Array<String>(names.dropFirst())
                Font.updateCommentFont(primary: primary, fallbacks: fallbacks, size: commentFontSize)
        }

        private(set) static var customLabelFonts: [String] = {
                let fallback: [String] = ["Menlo"]
                let savedValue = UserDefaults.standard.string(forKey: SettingsKeys.CustomLabelFontList)
                guard let fontList = savedValue else { return fallback }
                let names: [String] = fontList.components(separatedBy: ",").filter({ !($0.isEmpty) }).map({ $0.trimmed() }).uniqued()
                guard !(names.isEmpty) else { return fallback }
                return names
        }()
        static func updateCustomLabelFonts(to fontNames: [String]) {
                let names: [String] = fontNames.filter({ !($0.isEmpty) }).map({ $0.trimmed() }).uniqued()
                guard !(names.isEmpty) else { return }
                customLabelFonts = names
                let primary: String? = names.first
                let fallbacks: [String] = Array<String>(names.dropFirst())
                Font.updateLabelFont(primary: primary, fallbacks: fallbacks, size: labelFontSize)
        }


        // MARK: - Hotkeys

        /// Press Shift Key Once TO
        ///
        /// 1. Do Nothing
        /// 2. Switch between Cantonese and English
        private(set) static var pressShiftOnce: PressShiftOnce = {
                let savedValue: Int = UserDefaults.standard.integer(forKey: SettingsKeys.PressShiftOnce)
                switch savedValue {
                case 0, 1:
                        return .doNothing
                case 2:
                        return .switchCantoneseEnglish
                default:
                        return .doNothing
                }
        }()
        static func updatePressShiftOnce(to newValue: Int) {
                let newOption: PressShiftOnce = {
                        switch newValue {
                        case 0, 1:
                                return .doNothing
                        case 2:
                                return .switchCantoneseEnglish
                        default:
                                return .doNothing
                        }
                }()
                pressShiftOnce = newOption
        }

        /// Press Shift+Space TO
        ///
        /// 1. Input Full-width Space (U+3000)
        /// 2. Switch between Cantonese and English
        private(set) static var shiftSpaceCombination: ShiftSpaceCombination = {
                let savedValue: Int = UserDefaults.standard.integer(forKey: SettingsKeys.ShiftSpaceCombination)
                switch savedValue {
                case 0, 1:
                        return .inputFullWidthSpace
                case 2:
                        return .switchCantoneseEnglish
                default:
                        return .inputFullWidthSpace
                }
        }()
        static func updateShiftSpaceCombination(to newValue: Int) {
                let newOption: ShiftSpaceCombination = {
                        switch newValue {
                        case 0, 1:
                                return .inputFullWidthSpace
                        case 2:
                                return .switchCantoneseEnglish
                        default:
                                return .inputFullWidthSpace
                        }
                }()
                shiftSpaceCombination = newOption
        }

        /*
        private(set) static var isSpeakCandidateEnabled: Bool = {
                let savedValue: Int = UserDefaults.standard.integer(forKey: SettingsKeys.SpeakCandidate)
                switch savedValue {
                case 101:
                        return true
                case 102:
                        return false
                default:
                        return false
                }
        }()
        static func updateSpeakCandidateState(to newValue: Int) {
                let newState: Bool = {
                        switch newValue {
                        case 101:
                                return true
                        case 102:
                                return false
                        default:
                                return false
                        }
                }()
                isSpeakCandidateEnabled = newState
        }
        */
}
