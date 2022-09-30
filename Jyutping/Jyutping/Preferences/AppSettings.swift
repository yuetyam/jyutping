import Foundation

struct AppSettings {

        private(set) static var displayCandidatePageSize: Int = {
                let savedValue: Int = UserDefaults.standard.integer(forKey: "CandidatePageSize")
                let isSavedValueValid: Bool = pageSizeValidity(of: savedValue)
                guard isSavedValueValid else { return 10 }
                return savedValue
        }()
        static func updateDisplayCandidatePageSize(to newPageSize: Int) {
                let isNewPageSizeValid: Bool = pageSizeValidity(of: newPageSize)
                guard isNewPageSizeValid else { return }
                displayCandidatePageSize = newPageSize
                UserDefaults.standard.set(newPageSize, forKey: "CandidatePageSize")
        }
        private static func pageSizeValidity(of value: Int) -> Bool {
                return value > 4 && value < 11
        }

        private(set) static var candidateFontSize: CGFloat = {
                let savedValue: Int = UserDefaults.standard.integer(forKey: "CandidateFontSize")
                let isSavedValueValid: Bool = fontSizeValidity(of: savedValue)
                guard isSavedValueValid else { return 17 }
                return CGFloat(savedValue)
        }()
        static func updateCandidateFontSize(to newFontSize: Int) {
                let isNewFontSizeValid: Bool = fontSizeValidity(of: newFontSize)
                guard isNewFontSizeValid else { return }
                candidateFontSize = CGFloat(newFontSize)
                UserDefaults.standard.set(newFontSize, forKey: "CandidateFontSize")
        }

        private(set) static var commentFontSize: CGFloat = {
                let savedValue: Int = UserDefaults.standard.integer(forKey: "CommentFontSize")
                let isSavedValueValid: Bool = fontSizeValidity(of: savedValue)
                guard isSavedValueValid else { return 15 }
                return CGFloat(savedValue)
        }()
        static func updateCommentFontSize(to newFontSize: Int) {
                let isNewFontSizeValid: Bool = fontSizeValidity(of: newFontSize)
                guard isNewFontSizeValid else { return }
                commentFontSize = CGFloat(newFontSize)
                UserDefaults.standard.set(newFontSize, forKey: "CommentFontSize")
        }

        private(set) static var labelFontSize: CGFloat = {
                let savedValue: Int = UserDefaults.standard.integer(forKey: "LabelFontSize")
                let isSavedValueValid: Bool = fontSizeValidity(of: savedValue)
                guard isSavedValueValid else { return 15 }
                return CGFloat(savedValue)
        }()
        static func updateLabelFontSize(to newFontSize: Int) {
                let isNewFontSizeValid: Bool = fontSizeValidity(of: newFontSize)
                guard isNewFontSizeValid else { return }
                labelFontSize = CGFloat(newFontSize)
                UserDefaults.standard.set(newFontSize, forKey: "LabelFontSize")
        }

        private static func fontSizeValidity(of value: Int) -> Bool {
                return value > 11 && value < 23
        }


        // MARK: - Hotkeys

        /// Press Shift Key Once TO
        ///
        /// 1. Do Nothing
        /// 2. Switch between Cantonese and English
        private(set) static var pressShiftOnce: Int = {
                let savedValue: Int = UserDefaults.standard.integer(forKey: "PressShiftOnce")
                switch savedValue {
                case 0:
                        return 1
                case 1:
                        return 1
                case 2:
                        return 2
                default:
                        return 1
                }
        }()
        static func updatePressShiftOnce(to newOption: Int) {
                let isNewOptionValid: Bool = newOption == 1 || newOption == 2
                guard isNewOptionValid else { return }
                pressShiftOnce = newOption
                UserDefaults.standard.set(newOption, forKey: "PressShiftOnce")
        }
}

