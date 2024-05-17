import SwiftUI
import CommonExtensions

struct SettingsKey {
        static let CandidatePageSize: String = "CandidatePageSize"
        static let CandidateLineSpacing: String = "CandidateLineSpacing"
        static let CandidatePageOrientation: String = "CandidatePageOrientation"
        static let CommentDisplayStyle: String = "CommentDisplayStyle"
        static let ToneDisplayStyle: String = "ToneDisplayStyle"
        static let ToneDisplayColor: String = "ToneDisplayColor"


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

enum CandidatePageOrientation: Int {
        case horizontal = 1
        case vertical = 2
        static func orientation(of value: Int) -> CandidatePageOrientation {
                switch value {
                case 1:
                        return .horizontal
                case 2:
                        return .vertical
                default:
                        return .horizontal
                }
        }
}

enum CommentDisplayStyle: Int {

        case top = 1
        case bottom = 2
        // case left = 3 // Unwanted
        case right = 4
        case noComments = 5

        static func style(of value: Int) -> CommentDisplayStyle {
                switch value {
                case 1:
                        return .top
                case 2:
                        return .bottom
                case 4:
                        return .right
                case 5:
                        return .noComments
                default:
                        return .top
                }
        }
        var isVertical: Bool {
                switch self {
                case .top, .bottom:
                        return true
                default:
                        return false
                }
        }
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
enum ToneDisplayColor: Int {

        case normal = 1

        /// 相對更淺
        case shallow = 2

        static func color(of value: Int) -> ToneDisplayColor {
                switch value {
                case 1:
                        return .normal
                case 2:
                        return .shallow
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
        case switchInputMethodMode = 2
}

enum ShiftSpaceCombination: Int {
        case inputFullWidthSpace = 1
        case switchInputMethodMode = 2
}

struct AppSettings {

        /// Preferences Window
        private(set) static var selectedPreferencesSidebarRow: PreferencesSidebarRow = .general
        static func updateSelectedPreferencesSidebarRow(to row: PreferencesSidebarRow) {
                selectedPreferencesSidebarRow = row
        }


        // MARK: - Page Size

        private(set) static var displayCandidatePageSize: Int = {
                let savedValue: Int = UserDefaults.standard.integer(forKey: SettingsKey.CandidatePageSize)
                let isSavedValueValid: Bool = pageSizeValidity(of: savedValue)
                guard isSavedValueValid else { return defaultCandidatePageSize }
                return savedValue
        }()
        static func updateDisplayCandidatePageSize(to newPageSize: Int) {
                let isNewPageSizeValid: Bool = pageSizeValidity(of: newPageSize)
                guard isNewPageSizeValid else { return }
                displayCandidatePageSize = newPageSize
        }
        private static func pageSizeValidity(of value: Int) -> Bool {
                return candidatePageSizeRange.contains(value)
        }
        private static let defaultCandidatePageSize: Int = 7
        static let candidatePageSizeRange: Range<Int> = 1..<11


        // MARK: - Line Spacing

        private(set) static var candidateLineSpacing: Int = {
                let savedValue: Int = UserDefaults.standard.integer(forKey: SettingsKey.CandidateLineSpacing)
                let isSavedValueValid: Bool = lineSpacingValidity(of: savedValue)
                guard isSavedValueValid else { return defaultCandidateLineSpacing }
                return savedValue
        }()
        static func updateCandidateLineSpacing(to newLineSpacing: Int) {
                let isNewLineSpacingValid: Bool = lineSpacingValidity(of: newLineSpacing)
                guard isNewLineSpacingValid else { return }
                candidateLineSpacing = newLineSpacing
        }
        private static func lineSpacingValidity(of value: Int) -> Bool {
                return candidateLineSpacingRange.contains(value)
        }
        private static let defaultCandidateLineSpacing: Int = 6
        static let candidateLineSpacingRange: Range<Int> = 0..<13


        // MARK: - Orientation

        private(set) static var candidatePageOrientation: CandidatePageOrientation = {
                let savedValue: Int = UserDefaults.standard.integer(forKey: SettingsKey.CandidatePageOrientation)
                return CandidatePageOrientation.orientation(of: savedValue)
        }()
        static func updateCandidatePageOrientation(to value: Int) {
                let newOrientation: CandidatePageOrientation = CandidatePageOrientation.orientation(of: value)
                candidatePageOrientation = newOrientation
        }


        // MARK: - Comment Display Style

        private(set) static var commentDisplayStyle: CommentDisplayStyle = {
                let savedValue: Int = UserDefaults.standard.integer(forKey: SettingsKey.CommentDisplayStyle)
                return CommentDisplayStyle.style(of: savedValue)
        }()
        static func updateCommentDisplayStyle(to value: Int) {
                let newStyle: CommentDisplayStyle = CommentDisplayStyle.style(of: value)
                commentDisplayStyle = newStyle
        }


        // MARK: - Tone Display Style

        private(set) static var toneDisplayStyle: ToneDisplayStyle = {
                let savedValue: Int = UserDefaults.standard.integer(forKey: SettingsKey.ToneDisplayStyle)
                return ToneDisplayStyle.style(of: savedValue)
        }()
        static func updateToneDisplayStyle(to value: Int) {
                let newStyle: ToneDisplayStyle = ToneDisplayStyle.style(of: value)
                toneDisplayStyle = newStyle
        }

        private(set) static var toneDisplayColor: ToneDisplayColor = {
                let savedValue: Int = UserDefaults.standard.integer(forKey: SettingsKey.ToneDisplayColor)
                return ToneDisplayColor.color(of: savedValue)
        }()
        static func updateToneDisplayColor(to value: Int) {
                let newColor: ToneDisplayColor = ToneDisplayColor.color(of: value)
                toneDisplayColor = newColor
        }


        // MARK: - Font Size

        private(set) static var candidateFontSize: CGFloat = {
                let savedValue: Int = UserDefaults.standard.integer(forKey: SettingsKey.CandidateFontSize)
                let isSavedValueValid: Bool = fontSizeValidity(of: savedValue)
                let size: Int = isSavedValueValid ? savedValue : defaultCandidateFontSize
                return CGFloat(size)
        }()
        static func updateCandidateFontSize(to newFontSize: Int) {
                let isNewFontSizeValid: Bool = fontSizeValidity(of: newFontSize)
                guard isNewFontSizeValid else { return }
                candidateFontSize = CGFloat(newFontSize)
                Font.updateCandidateFont()
        }

        private(set) static var commentFontSize: CGFloat = {
                let savedValue: Int = UserDefaults.standard.integer(forKey: SettingsKey.CommentFontSize)
                let isSavedValueValid: Bool = fontSizeValidity(of: savedValue)
                let size: Int = isSavedValueValid ? savedValue : defaultCommentFontSize
                return CGFloat(size)
        }()
        static func updateCommentFontSize(to newFontSize: Int) {
                let isNewFontSizeValid: Bool = fontSizeValidity(of: newFontSize)
                guard isNewFontSizeValid else { return }
                commentFontSize = CGFloat(newFontSize)
                Font.updateCommentFont()
        }

        private(set) static var labelFontSize: CGFloat = {
                let savedValue: Int = UserDefaults.standard.integer(forKey: SettingsKey.LabelFontSize)
                let isSavedValueValid: Bool = fontSizeValidity(of: savedValue)
                let size: Int = isSavedValueValid ? savedValue : defaultLabelFontSize
                return CGFloat(size)
        }()
        static func updateLabelFontSize(to newFontSize: Int) {
                let isNewFontSizeValid: Bool = fontSizeValidity(of: newFontSize)
                guard isNewFontSizeValid else { return }
                labelFontSize = CGFloat(newFontSize)
                Font.updateLabelFont()
        }

        private static func fontSizeValidity(of value: Int) -> Bool {
                return fontSizeRange.contains(value)
        }
        private static let defaultCandidateFontSize: Int = 17
        private static let defaultCommentFontSize: Int = 13
        private static let defaultLabelFontSize: Int = 13
        static let fontSizeRange: Range<Int> = 10..<25


        // MARK: - Font Mode

        private(set) static var candidateFontMode: FontMode = {
                let savedValue: Int = UserDefaults.standard.integer(forKey: SettingsKey.CandidateFontMode)
                return FontMode.mode(of: savedValue)
        }()
        static func updateCandidateFontMode(to newMode: FontMode) {
                candidateFontMode = newMode
                Font.updateCandidateFont()
        }

        private(set) static var commentFontMode: FontMode = {
                let savedValue: Int = UserDefaults.standard.integer(forKey: SettingsKey.CommentFontMode)
                return FontMode.mode(of: savedValue)
        }()
        static func updateCommentFontMode(to newMode: FontMode) {
                commentFontMode = newMode
                Font.updateCommentFont()
        }

        private(set) static var labelFontMode: FontMode = {
                let savedValue: Int = UserDefaults.standard.integer(forKey: SettingsKey.LabelFontMode)
                return FontMode.mode(of: savedValue)
        }()
        static func updateLabelFontMode(to newMode: FontMode) {
                labelFontMode = newMode
                Font.updateLabelFont()
        }


        // MARK: - Custom Fonts

        private(set) static var customCandidateFonts: [String] = {
                let fallback: [String] = [Constant.PingFangHK]
                let savedNames: String? = UserDefaults.standard.string(forKey: SettingsKey.CustomCandidateFontList)
                guard let savedNames else { return fallback }
                let names: [String] = savedNames.split(separator: ",").map({ $0.trimmed() }).filter({ !($0.isEmpty) }).uniqued()
                guard !(names.isEmpty) else { return fallback }
                return names
        }()
        static func updateCustomCandidateFonts(to fontNames: [String]) {
                customCandidateFonts = fontNames
                Font.updateCandidateFont()
        }

        private(set) static var customCommentFonts: [String] = {
                let fallback: [String] = [Constant.HelveticaNeue]
                let savedNames: String? = UserDefaults.standard.string(forKey: SettingsKey.CustomCommentFontList)
                guard let savedNames else { return fallback }
                let names: [String] = savedNames.split(separator: ",").map({ $0.trimmed() }).filter({ !($0.isEmpty) }).uniqued()
                guard !(names.isEmpty) else { return fallback }
                return names
        }()
        static func updateCustomCommentFonts(to fontNames: [String]) {
                customCommentFonts = fontNames
                Font.updateCommentFont()
        }

        private(set) static var customLabelFonts: [String] = {
                let fallback: [String] = [Constant.Menlo]
                let savedNames = UserDefaults.standard.string(forKey: SettingsKey.CustomLabelFontList)
                guard let savedNames else { return fallback }
                let names: [String] = savedNames.split(separator: ",").map({ $0.trimmed() }).filter({ !($0.isEmpty) }).uniqued()
                guard !(names.isEmpty) else { return fallback }
                return names
        }()
        static func updateCustomLabelFonts(to fontNames: [String]) {
                customLabelFonts = fontNames
                Font.updateLabelFont()
        }


        // MARK: - Hotkeys

        /// Press Shift Key Once TO
        ///
        /// 1. Do Nothing
        /// 2. Switch between Cantonese and English
        private(set) static var pressShiftOnce: PressShiftOnce = {
                let savedValue: Int = UserDefaults.standard.integer(forKey: SettingsKey.PressShiftOnce)
                switch savedValue {
                case 0, 1:
                        return .doNothing
                case 2:
                        return .switchInputMethodMode
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
                                return .switchInputMethodMode
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
                let savedValue: Int = UserDefaults.standard.integer(forKey: SettingsKey.ShiftSpaceCombination)
                switch savedValue {
                case 0, 1:
                        return .inputFullWidthSpace
                case 2:
                        return .switchInputMethodMode
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
                                return .switchInputMethodMode
                        default:
                                return .inputFullWidthSpace
                        }
                }()
                shiftSpaceCombination = newOption
        }

        /*
        private(set) static var isSpeakCandidateEnabled: Bool = {
                let savedValue: Int = UserDefaults.standard.integer(forKey: SettingsKey.SpeakCandidate)
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

