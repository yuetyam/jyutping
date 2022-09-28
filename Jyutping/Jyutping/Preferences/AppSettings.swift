import Foundation

struct AppSettings {

        private(set) static var displayCandidatesPageSize: Int = {
                let savedValue: Int = UserDefaults.standard.integer(forKey: "CandidatesPageSize")
                let isSavedValueValid: Bool = pageSizeValidity(of: savedValue)
                guard isSavedValueValid else { return 10 }
                return savedValue
        }()
        static func updateDisplayCandidatesPageSize(to newPageSize: Int) {
                let isNewPageSizeValid: Bool = pageSizeValidity(of: newPageSize)
                guard isNewPageSizeValid else { return }
                displayCandidatesPageSize = newPageSize
                UserDefaults.standard.set(newPageSize, forKey: "CandidatesPageSize")
        }
        private static func pageSizeValidity(of value: Int) -> Bool {
                return value > 4 && value < 11
        }


        // MARK: - Hotkeys

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

