import Foundation
import CommonExtensions

enum HapticFeedback: Int, CaseIterable {
        case disabled = 0
        case light = 1
        case medium = 2
        case heavy = 3
}

extension HapticFeedback {

        /// Read HapticFeedback mode from UserDefaults
        static func fetchSavedMode() -> HapticFeedback {
                let savedValue: Int = UserDefaults.standard.integer(forKey: UserSettingsKey.HapticFeedback)
                return allCases.first(where: { $0.rawValue == savedValue }) ?? .disabled
        }
}
