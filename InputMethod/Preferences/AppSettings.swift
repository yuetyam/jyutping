import SwiftUI
import CommonExtensions
import CoreIME

struct SettingsKey {
        static let CandidatePageSize: String = "CandidatePageSize"
        static let CandidateLineSpacing: String = "CandidateLineSpacing"
        static let CandidatePageOrientation: String = "CandidatePageOrientation"
        static let CommentDisplayStyle: String = "CommentDisplayStyle"
        static let ToneDisplayStyle: String = "ToneDisplayStyle"
        static let ToneDisplayColor: String = "ToneDisplayColor"
        static let LabelSet: String = "LabelSet"
        static let LabelLast: String = "LabelLast"
        static let CangjieVariant: String = "CangjieVariant"
        static let SystemLexicon: String = "SystemLexicon"
        static let SchemeRules: String = "SchemeRules"
        static let UserLexiconInputMemory: String = "UserLexiconInputMemory"


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
        static let BracketKeys: String = "BracketKeys"
        static let CommaPeriodKeys: String = "CommaPeriodKeys"
}

enum CandidatePageOrientation: Int, CaseIterable {
        case horizontal = 1
        case vertical = 2
        var isHorizontal: Bool { self == .horizontal }
        var isVertical: Bool { self == .vertical }
        static func orientation(of value: Int) -> CandidatePageOrientation {
                return Self.allCases.first(where: { $0.rawValue == value }) ?? Self.horizontal
        }
}

enum CommentDisplayStyle: Int, CaseIterable {

        case top = 1
        case bottom = 2
        // case left = 3 // Unwanted
        case right = 4
        case noComments = 5

        static func style(of value: Int) -> CommentDisplayStyle {
                return Self.allCases.first(where: { $0.rawValue == value }) ?? Self.top
        }
        var isTop: Bool { self == .top }
        var isBottom: Bool { self == .bottom }
        var isRight: Bool { self == .right }
        var isCommentFree: Bool { self == .noComments }
        var isVertical: Bool {
                switch self {
                case .top, .bottom: true
                default: false
                }
        }
}

enum ToneDisplayStyle: Int, CaseIterable {

        case normal = 1
        case noTones = 2
        case superscript = 3
        case `subscript` = 4

        static func style(of value: Int) -> ToneDisplayStyle {
                return Self.allCases.first(where: { $0.rawValue == value }) ?? Self.normal
        }
}
enum ToneDisplayColor: Int, CaseIterable {

        case normal = 1

        /// 相對更淺
        case shallow = 2

        static func color(of value: Int) -> ToneDisplayColor {
                return Self.allCases.first(where: { $0.rawValue == value }) ?? Self.normal
        }

        var isShallow: Bool { self == .shallow}
}

/// 候選詞編號集
enum LabelSet: Int, CaseIterable {

        /// 阿拉伯數字（半寬）
        case arabic = 1

        /// 全寬阿拉伯數字
        case fullWidthArabic = 2

        /// 漢字數字： 〇一二三四五六七八九十
        case chinese = 3

        /// 大寫漢字數字： 零壹貳叁肆伍陸柒捌玖拾
        case capitalizedChinese = 4

        /// 算籌數字（直式）： 𝍠𝍡𝍢𝍣𝍤𝍥𝍦𝍧𝍨〇
        case verticalCountingRods = 5

        /// 算籌數字（橫式）： 𝍩𝍪𝍫𝍬𝍭𝍮𝍯𝍰𝍱〇
        case horizontalCountingRods = 6

        /// 蘇州碼： 〇〡〢〣〤〥〦〧〨〩〸
        case soochow = 7

        /// 麻雀／麻將： 🀙 🀚 🀛 🀜 🀝 🀞 🀟 🀠 🀡 🀆
        case mahjong = 8

        /// 大寫羅馬數字： Ⅰ Ⅱ Ⅲ Ⅳ Ⅴ Ⅵ Ⅶ Ⅷ Ⅸ Ⅹ
        case roman = 9

        /// 小寫羅馬數字： ⅰ ⅱ ⅲ ⅳ ⅴ ⅵ ⅶ ⅷ ⅸ ⅹ
        case smallRoman = 10

        /// Heavenly Stems. 天干： 甲乙丙丁戊己庚辛壬癸
        case stems = 11

        /// Earthly Branches. 地支： 子丑寅卯辰巳午未申酉
        case branches = 12

        static func labelSet(of value: Int) -> LabelSet {
                return Self.allCases.first(where: { $0.rawValue == value }) ?? Self.arabic
        }
}

/// 候選詞編號第十位
enum LabelLast: Int, CaseIterable {
        case zero = 1
        case ten = 2
        static func labelLast(of value: Int) -> LabelLast {
                return Self.allCases.first(where: { $0.rawValue == value }) ?? Self.zero
        }
}


enum FontMode: Int, CaseIterable {

        case `default` = 1
        case system = 2
        case custom = 3

        var isCustom: Bool {
                return self == .custom
        }

        static func mode(of value: Int) -> FontMode {
                return Self.allCases.first(where: { $0.rawValue == value }) ?? Self.default
        }
}

enum PressShiftOnce: Int, CaseIterable {
        case doNothing = 1
        case switchInputMethodMode = 2
        static func action(of value: Int) -> PressShiftOnce {
                return Self.allCases.first(where: { $0.rawValue == value }) ?? Self.doNothing
        }
}

enum ShiftSpaceCombination: Int, CaseIterable {
        case inputFullWidthSpace = 1
        case switchInputMethodMode = 2
        static func action(of value: Int) -> ShiftSpaceCombination {
                return Self.allCases.first(where: { $0.rawValue == value }) ?? Self.inputFullWidthSpace
        }
}

/// 括號鍵 [ ] 額外功能
enum BracketKeysMode: Int, CaseIterable {
        /// 輸入候選詞首字、末字
        case characterSelection = 1
        /// 候選詞翻䈎
        case candidatePaging = 2
        /// 無額外功能
        case noOperation = 3
        static func mode(of value: Int) -> BracketKeysMode {
                return Self.allCases.first(where: { $0.rawValue == value }) ?? Self.characterSelection
        }
        var isCharacterSelection: Bool { self == .characterSelection }
        var isPaging: Bool { self == .candidatePaging }
}

/// 逗號、句號鍵額外功能
enum CommaPeriodKeysMode: Int, CaseIterable {
        /// 候選詞翻䈎
        case candidatePaging = 1
        /// 輸入候選詞首字、末字
        case characterSelection = 2
        /// 無額外功能
        case noOperation = 3
        static func mode(of value: Int) -> CommaPeriodKeysMode {
                return Self.allCases.first(where: { $0.rawValue == value }) ?? Self.candidatePaging
        }
        var isPaging: Bool { self == .candidatePaging }
        var isCharacterSelection: Bool { self == .characterSelection }
}

@MainActor
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
                UserDefaults.standard.set(newPageSize, forKey: SettingsKey.CandidatePageSize)
        }
        private static func pageSizeValidity(of value: Int) -> Bool {
                return candidatePageSizeRange.contains(value)
        }
        private static let defaultCandidatePageSize: Int = 7
        static let candidatePageSizeRange: Range<Int> = 1..<11


        // MARK: - Line Spacing

        private(set) static var candidateLineSpacing: Int = {
                let hasSavedValue: Bool = UserDefaults.standard.object(forKey: SettingsKey.CandidateLineSpacing) != nil
                guard hasSavedValue else { return defaultCandidateLineSpacing }
                let savedValue: Int = UserDefaults.standard.integer(forKey: SettingsKey.CandidateLineSpacing)
                let isSavedValueValid: Bool = lineSpacingValidity(of: savedValue)
                guard isSavedValueValid else { return defaultCandidateLineSpacing }
                return savedValue
        }()
        static func updateCandidateLineSpacing(to newLineSpacing: Int) {
                let isNewLineSpacingValid: Bool = lineSpacingValidity(of: newLineSpacing)
                guard isNewLineSpacingValid else { return }
                candidateLineSpacing = newLineSpacing
                UserDefaults.standard.set(newLineSpacing, forKey: SettingsKey.CandidateLineSpacing)
        }
        private static func lineSpacingValidity(of value: Int) -> Bool {
                return candidateLineSpacingRange.contains(value)
        }
        private static let defaultCandidateLineSpacing: Int = 6
        static let candidateLineSpacingRange: Range<Int> = 0..<15


        // MARK: - Orientation

        private(set) static var candidatePageOrientation: CandidatePageOrientation = {
                let savedValue: Int = UserDefaults.standard.integer(forKey: SettingsKey.CandidatePageOrientation)
                return CandidatePageOrientation.orientation(of: savedValue)
        }()
        static func updateCandidatePageOrientation(to orientation: CandidatePageOrientation) {
                candidatePageOrientation = orientation
                let value: Int = orientation.rawValue
                UserDefaults.standard.set(value, forKey: SettingsKey.CandidatePageOrientation)
        }


        // MARK: - Comment Display Style

        private(set) static var commentDisplayStyle: CommentDisplayStyle = {
                let savedValue: Int = UserDefaults.standard.integer(forKey: SettingsKey.CommentDisplayStyle)
                return CommentDisplayStyle.style(of: savedValue)
        }()
        static func updateCommentDisplayStyle(to style: CommentDisplayStyle) {
                commentDisplayStyle = style
                let value: Int = style.rawValue
                UserDefaults.standard.set(value, forKey: SettingsKey.CommentDisplayStyle)
        }


        // MARK: - Tone Display Style

        private(set) static var toneDisplayStyle: ToneDisplayStyle = {
                let savedValue: Int = UserDefaults.standard.integer(forKey: SettingsKey.ToneDisplayStyle)
                return ToneDisplayStyle.style(of: savedValue)
        }()
        static func updateToneDisplayStyle(to style: ToneDisplayStyle) {
                toneDisplayStyle = style
                let value: Int = style.rawValue
                UserDefaults.standard.set(value, forKey: SettingsKey.ToneDisplayStyle)
        }

        private(set) static var toneDisplayColor: ToneDisplayColor = {
                let savedValue: Int = UserDefaults.standard.integer(forKey: SettingsKey.ToneDisplayColor)
                return ToneDisplayColor.color(of: savedValue)
        }()
        static func updateToneDisplayColor(to colorOption: ToneDisplayColor) {
                toneDisplayColor = colorOption
                let value: Int = colorOption.rawValue
                UserDefaults.standard.set(value, forKey: SettingsKey.ToneDisplayColor)
        }


        // MARK: - Label / Serial Number

        private(set) static var labelSet: LabelSet = {
                let savedValue: Int = UserDefaults.standard.integer(forKey: SettingsKey.LabelSet)
                return LabelSet.labelSet(of: savedValue)
        }()
        static func updateLabelSet(to labels: LabelSet) {
                labelSet = labels
                Font.updateLabelFont()
                let value: Int = labels.rawValue
                UserDefaults.standard.set(value, forKey: SettingsKey.LabelSet)
        }

        private(set) static var isLabelLastZero: Bool = {
                let savedValue: Int = UserDefaults.standard.integer(forKey: SettingsKey.LabelLast)
                let option: LabelLast = LabelLast.labelLast(of: savedValue)
                return option == LabelLast.zero
        }()
        static func updateLabelLastState(to isZero: Bool) {
                isLabelLastZero = isZero
                let value: Int = isZero ? 1 : 2
                UserDefaults.standard.set(value, forKey: SettingsKey.LabelLast)
        }


        // MARK: - Cangjie / Quick Reverse Lookup

        private(set) static var cangjieVariant: CangjieVariant = {
                let savedValue: Int = UserDefaults.standard.integer(forKey: SettingsKey.CangjieVariant)
                return CangjieVariant.variant(of: savedValue)
        }()
        static func updateCangjieVariant(to variant: CangjieVariant) {
                cangjieVariant = variant
                let value: Int = variant.rawValue
                UserDefaults.standard.set(value, forKey: SettingsKey.CangjieVariant)
        }

        private(set) static var isTextReplacementsOn: Bool = {
                let savedValue: Int = UserDefaults.standard.integer(forKey: SettingsKey.SystemLexicon)
                return savedValue != 2
        }()
        static func updateTextReplacementsState(to isOn: Bool) {
                isTextReplacementsOn = isOn
                let value: Int = isOn ? 1 : 2
                UserDefaults.standard.set(value, forKey: SettingsKey.SystemLexicon)
        }

        private(set) static var isCompatibleModeOn: Bool = {
                let savedValue: Int = UserDefaults.standard.integer(forKey: SettingsKey.SchemeRules)
                return savedValue == 1
        }()
        static func updateCompatibleMode(to isOn: Bool) {
                isCompatibleModeOn = isOn
                let value: Int = isOn ? 1 : 0
                UserDefaults.standard.set(value, forKey: SettingsKey.SchemeRules)
        }


        // MARK: - User Lexicon

        private(set) static var isInputMemoryOn: Bool = {
                let savedValue: Int = UserDefaults.standard.integer(forKey: SettingsKey.UserLexiconInputMemory)
                return savedValue != 2
        }()
        static func updateInputMemoryState(to isOn: Bool) {
                isInputMemoryOn = isOn
                let value: Int = isOn ? 1 : 2
                UserDefaults.standard.set(value, forKey: SettingsKey.UserLexiconInputMemory)
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
                UserDefaults.standard.set(newFontSize, forKey: SettingsKey.CandidateFontSize)
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
                UserDefaults.standard.set(newFontSize, forKey: SettingsKey.CommentFontSize)
                updateSyllableViewSize()
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
                UserDefaults.standard.set(newFontSize, forKey: SettingsKey.LabelFontSize)
                Font.updateLabelFont()
        }

        private static func fontSizeValidity(of value: Int) -> Bool {
                return fontSizeRange.contains(value)
        }
        private static let defaultCandidateFontSize: Int = 16
        private static let defaultCommentFontSize: Int = 13
        private static let defaultLabelFontSize: Int = 13
        static let fontSizeRange: Range<Int> = 10..<25


        // Candidate StackView syllable text frame
        private(set) static var syllableViewSize: CGSize = computeSyllableViewSize()
        private static func updateSyllableViewSize() {
                syllableViewSize = computeSyllableViewSize()
        }
        private static func computeSyllableViewSize() -> CGSize {
                let width: CGFloat = commentFontSize * 2.0 + 10.0
                let height: CGFloat = commentFontSize
                return CGSize(width: width, height: height)
        }


        // MARK: - Font Mode

        private(set) static var candidateFontMode: FontMode = {
                let savedValue: Int = UserDefaults.standard.integer(forKey: SettingsKey.CandidateFontMode)
                return FontMode.mode(of: savedValue)
        }()
        static func updateCandidateFontMode(to newMode: FontMode) {
                candidateFontMode = newMode
                let value: Int = newMode.rawValue
                UserDefaults.standard.set(value, forKey: SettingsKey.CandidateFontMode)
                Font.updateCandidateFont()
        }

        private(set) static var commentFontMode: FontMode = {
                let savedValue: Int = UserDefaults.standard.integer(forKey: SettingsKey.CommentFontMode)
                return FontMode.mode(of: savedValue)
        }()
        static func updateCommentFontMode(to newMode: FontMode) {
                commentFontMode = newMode
                let value: Int = newMode.rawValue
                UserDefaults.standard.set(value, forKey: SettingsKey.CommentFontMode)
                Font.updateCommentFont()
        }

        private(set) static var labelFontMode: FontMode = {
                let savedValue: Int = UserDefaults.standard.integer(forKey: SettingsKey.LabelFontMode)
                return FontMode.mode(of: savedValue)
        }()
        static func updateLabelFontMode(to newMode: FontMode) {
                labelFontMode = newMode
                let value: Int = newMode.rawValue
                UserDefaults.standard.set(value, forKey: SettingsKey.LabelFontMode)
                Font.updateLabelFont()
        }


        // MARK: - Custom Fonts

        private(set) static var customCandidateFonts: [String] = {
                let fallback: [String] = [PresetConstant.PingFangHK]
                let savedNames: String? = UserDefaults.standard.string(forKey: SettingsKey.CustomCandidateFontList)
                guard let savedNames else { return fallback }
                let names: [String] = savedNames.split(separator: ",").map({ $0.trimmed() }).filter(\.isNotEmpty).uniqued()
                guard names.isNotEmpty else { return fallback }
                return names
        }()
        static func updateCustomCandidateFonts(to fontNames: [String]) {
                let names: [String] = fontNames.map({ $0.trimmed() }).filter(\.isNotEmpty).uniqued()
                customCandidateFonts = names
                let fontList: String = names.joined(separator: ",")
                UserDefaults.standard.set(fontList, forKey: SettingsKey.CustomCandidateFontList)
                Font.updateCandidateFont()
        }

        private(set) static var customCommentFonts: [String] = {
                let fallback: [String] = [PresetConstant.HelveticaNeue]
                let savedNames: String? = UserDefaults.standard.string(forKey: SettingsKey.CustomCommentFontList)
                guard let savedNames else { return fallback }
                let names: [String] = savedNames.split(separator: ",").map({ $0.trimmed() }).filter(\.isNotEmpty).uniqued()
                guard names.isNotEmpty else { return fallback }
                return names
        }()
        static func updateCustomCommentFonts(to fontNames: [String]) {
                let names: [String] = fontNames.map({ $0.trimmed() }).filter(\.isNotEmpty).uniqued()
                customCommentFonts = names
                let fontList: String = names.joined(separator: ",")
                UserDefaults.standard.set(fontList, forKey: SettingsKey.CustomCommentFontList)
                Font.updateCommentFont()
        }

        private(set) static var customLabelFonts: [String] = {
                let fallback: [String] = [PresetConstant.Menlo]
                let savedNames = UserDefaults.standard.string(forKey: SettingsKey.CustomLabelFontList)
                guard let savedNames else { return fallback }
                let names: [String] = savedNames.split(separator: ",").map({ $0.trimmed() }).filter(\.isNotEmpty).uniqued()
                guard names.isNotEmpty else { return fallback }
                return names
        }()
        static func updateCustomLabelFonts(to fontNames: [String]) {
                let names: [String] = fontNames.map({ $0.trimmed() }).filter(\.isNotEmpty).uniqued()
                customLabelFonts = names
                let fontList: String = names.joined(separator: ",")
                UserDefaults.standard.set(fontList, forKey: SettingsKey.CustomLabelFontList)
                Font.updateLabelFont()
        }


        // MARK: - Hotkeys

        /// Press Shift Key Once TO
        ///
        /// 1. Do Nothing
        /// 2. Switch between Cantonese and English
        nonisolated(unsafe) private(set) static var pressShiftOnce: PressShiftOnce = {
                let savedValue: Int = UserDefaults.standard.integer(forKey: SettingsKey.PressShiftOnce)
                return PressShiftOnce.action(of: savedValue)
        }()
        static func updatePressShiftOnce(to option: PressShiftOnce) {
                pressShiftOnce = option
                let value: Int = option.rawValue
                UserDefaults.standard.set(value, forKey: SettingsKey.PressShiftOnce)
        }

        /// Press Shift+Space TO
        ///
        /// 1. Input Full-width Space (U+3000)
        /// 2. Switch between Cantonese and English
        nonisolated(unsafe) private(set) static var shiftSpaceCombination: ShiftSpaceCombination = {
                let savedValue: Int = UserDefaults.standard.integer(forKey: SettingsKey.ShiftSpaceCombination)
                return ShiftSpaceCombination.action(of: savedValue)
        }()
        static func updateShiftSpaceCombination(to option: ShiftSpaceCombination) {
                shiftSpaceCombination = option
                let value: Int = option.rawValue
                UserDefaults.standard.set(value, forKey: SettingsKey.ShiftSpaceCombination)
        }

        /// Use [ ] keys for
        private(set) static var bracketKeysMode: BracketKeysMode = {
                let savedValue: Int = UserDefaults.standard.integer(forKey: SettingsKey.BracketKeys)
                return BracketKeysMode.mode(of: savedValue)
        }()
        static func updateBracketKeysMode(to mode: BracketKeysMode) {
                bracketKeysMode = mode
                let value: Int = mode.rawValue
                UserDefaults.standard.set(value, forKey: SettingsKey.BracketKeys)
        }

        /// Use , . keys for
        private(set) static var commaPeriodKeysMode: CommaPeriodKeysMode = {
                let savedValue: Int = UserDefaults.standard.integer(forKey: SettingsKey.CommaPeriodKeys)
                return CommaPeriodKeysMode.mode(of: savedValue)
        }()
        static func updateCommaPeriodKeysMode(to mode: CommaPeriodKeysMode) {
                commaPeriodKeysMode = mode
                let value: Int = mode.rawValue
                UserDefaults.standard.set(value, forKey: SettingsKey.CommaPeriodKeys)
        }
}

extension LabelSet {

        private static let chineseLabels: [String] = ["一", "二", "三", "四", "五", "六", "七", "八", "九", "十"]
        private static let capitalizedChineseLabels: [String] = ["壹", "貳", "叁", "肆", "伍", "陸", "柒", "捌", "玖", "拾"]
        private static let verticalCountingRodLabels: [String] = ["𝍠", "𝍡", "𝍢", "𝍣", "𝍤", "𝍥", "𝍦", "𝍧", "𝍨", "〇"]
        private static let horizontalCountingRodLabels: [String] = ["𝍩", "𝍪", "𝍫", "𝍬", "𝍭", "𝍮", "𝍯", "𝍰", "𝍱", "〇"]
        private static let soochowLabels: [String] = ["〡", "〢", "〣", "〤", "〥", "〦", "〧", "〨", "〩", "〸"]
        private static let mahjongLabels: [String] = ["🀙", "🀚", "🀛", "🀜", "🀝", "🀞", "🀟", "🀠", "🀡", "🀆"]
        private static let romanLabels: [String] = ["Ⅰ", "Ⅱ", "Ⅲ", "Ⅳ", "Ⅴ", "Ⅵ", "Ⅶ", "Ⅷ", "Ⅸ", "Ⅹ"]
        private static let smallRomanLabels: [String] = ["ⅰ", "ⅱ", "ⅲ", "ⅳ", "ⅴ", "ⅵ", "ⅶ", "ⅷ", "ⅸ", "ⅹ"]
        private static let stemsLabels: [String] = ["甲", "乙", "丙", "丁", "戊", "己", "庚", "辛", "壬", "癸"]
        private static let branchesLabels: [String] = ["子", "丑", "寅", "卯", "辰", "巳", "午", "未", "申", "酉"]
        private static let fallbackText: String = "?"

        static func labelText(for index: Int, labelSet: LabelSet, isLabelLastZero: Bool) -> String {
                let shouldBeZero: Bool = isLabelLastZero && index == 9
                switch labelSet {
                case .arabic:
                        return shouldBeZero ? "0" : "\(index + 1)"
                case .fullWidthArabic:
                        let numberText: String = "\(index + 1)"
                        return shouldBeZero ? "０" : numberText.fullWidth()
                case .chinese:
                        return shouldBeZero ? "〇" : (chineseLabels.fetch(index) ?? fallbackText)
                case .capitalizedChinese:
                        return shouldBeZero ? "零" : (capitalizedChineseLabels.fetch(index) ?? fallbackText)
                case .verticalCountingRods:
                        return verticalCountingRodLabels.fetch(index) ?? fallbackText
                case .horizontalCountingRods:
                        return horizontalCountingRodLabels.fetch(index) ?? fallbackText
                case .soochow:
                        return shouldBeZero ? "〇" : (soochowLabels.fetch(index) ?? fallbackText)
                case .mahjong:
                        return mahjongLabels.fetch(index) ?? fallbackText
                case .roman:
                        return shouldBeZero ? "N" : (romanLabels.fetch(index) ?? fallbackText)
                case .smallRoman:
                        return shouldBeZero ? "n" : (smallRomanLabels.fetch(index) ?? fallbackText)
                case .stems:
                        return stemsLabels.fetch(index) ?? fallbackText
                case .branches:
                        return branchesLabels.fetch(index) ?? fallbackText
                }
        }
}
