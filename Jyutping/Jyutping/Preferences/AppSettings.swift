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
                let isSavedValueValid: Bool = candidateFontSizeValidity(of: savedValue)
                guard isSavedValueValid else { return 17 }
                return CGFloat(savedValue)
        }()
        static func updateCandidateFontSize(to newFontSize: Int) {
                let isNewFontSizeValid: Bool = candidateFontSizeValidity(of: newFontSize)
                guard isNewFontSizeValid else { return }
                candidateFontSize = CGFloat(newFontSize)
                UserDefaults.standard.set(newFontSize, forKey: "CandidateFontSize")
        }
        private static func candidateFontSizeValidity(of value: Int) -> Bool {
                return value > 13 && value < 25
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

