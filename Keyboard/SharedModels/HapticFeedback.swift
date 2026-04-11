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
                let hasSavedValue: Bool = UserDefaults.standard.object(forKey: OptionsKey.HapticFeedback) != nil
                let hasLegacySavedValue: Bool = UserDefaults.standard.object(forKey: LegacyOptionsKey.HapticFeedback) != nil
                defer {
                        if hasLegacySavedValue {
                                UserDefaults.standard.removeObject(forKey: LegacyOptionsKey.HapticFeedback)
                        }
                }
                let savedValue: Int = {
                        if hasSavedValue.negative && hasLegacySavedValue {
                                let oldValue: Int = UserDefaults.standard.integer(forKey: LegacyOptionsKey.HapticFeedback)
                                UserDefaults.standard.set(oldValue, forKey: OptionsKey.HapticFeedback)
                                return oldValue
                        } else {
                                return UserDefaults.standard.integer(forKey: OptionsKey.HapticFeedback)
                        }
                }()
                return allCases.first(where: { $0.rawValue == savedValue }) ?? .disabled
        }
}
