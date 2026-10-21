import Foundation
import AudioToolbox

enum AudioFeedback: SystemSoundID {

        case input = 1123
        case delete = 1155
        case modify = 1156

        static func perform(_ feedback: AudioFeedback) {
                AudioServicesPlaySystemSound(feedback.rawValue)
        }

        @available(*, deprecated, message: "Use context.performAudioFeedback(.input) instead")
        static func inputed() {
                AudioServicesPlaySystemSound(input.rawValue)
        }

        @available(*, deprecated, message: "Use context.performAudioFeedback(.delete) instead")
        static func deleted() {
                AudioServicesPlaySystemSound(delete.rawValue)
        }

        @available(*, deprecated, message: "Use context.performAudioFeedback(.modify) instead")
        static func modified() {
                AudioServicesPlaySystemSound(modify.rawValue)
        }
}

extension AudioFeedback {

        private static let settingsKey: String = UserSettingsKey.AudioFeedback

        static func fetchSavedState() -> Bool {
                let savedValue: Int = UserDefaults.standard.integer(forKey: settingsKey)
                return savedValue == 1
        }

        static func savedState(isOn: Bool) {
                let value: Int = isOn ? 1 : 0
                UserDefaults.standard.set(value, forKey: settingsKey)
        }
}
