import Foundation

enum HapticFeedback: Int {
        case disabled = 0
        case light = 1
        case medium = 2
        case heavy = 3
}

extension HapticFeedback {
        /// Read HapticFeedback mode from UserDefaults
        static func fetchSavedMode() -> HapticFeedback {
                let savedValue: Int = UserDefaults.standard.integer(forKey: OptionsKey.HapticFeedback)
                switch savedValue {
                case HapticFeedback.disabled.rawValue:
                        return .disabled
                case HapticFeedback.light.rawValue:
                        return .light
                case HapticFeedback.medium.rawValue:
                        return .medium
                case HapticFeedback.heavy.rawValue:
                        return .heavy
                default:
                        return .disabled
                }
        }
}
