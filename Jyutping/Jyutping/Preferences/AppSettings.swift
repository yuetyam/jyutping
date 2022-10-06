import Foundation

struct SettingsKeys {
        static let CandidatePageSize: String = "CandidatePageSize"

        static let CandidateFontSize: String = "CandidateFontSize"
        static let CommentFontSize: String = "CommentFontSize"
        static let LabelFontSize: String = "LabelFontSize"

        static let CandidateFontMode: String = "CandidateFontMode"
        static let CommentFontMode: String = "CommentFontMode"
        static let LabelFontMode: String = "LabelFontMode"

        static let SwitchCantoneseEnglish: String = "SwitchCantoneseEnglish"
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


        // MARK: - Hotkeys

        /// Switch between Cantonese and English
        ///
        /// 1. None
        /// 2. Control + Shift + Space
        /// 3. Shift
        private(set) static var switchCantoneseEnglish: Int = {
                let savedValue: Int = UserDefaults.standard.integer(forKey: SettingsKeys.SwitchCantoneseEnglish)
                switch savedValue {
                case 0, 1:
                        return 1
                case 2:
                        return 2
                case 3:
                        return 3
                default:
                        return 1
                }
        }()
        static func updateSwitchCantoneseEnglish(to newOption: Int) {
                switchCantoneseEnglish = newOption
        }
}

