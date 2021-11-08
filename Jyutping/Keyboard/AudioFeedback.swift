import AudioToolbox

enum AudioFeedback {

        case input
        case delete
        case modify
        
        private var soundID: SystemSoundID {
                switch self {
                case .input : return 1123
                case .delete: return 1155
                case .modify: return 1156
                }
        }
        
        static func play(for keyboardEvent: KeyboardEvent) {
                guard isAudioFeedbackOn else { return }
                switch keyboardEvent {
                case .key, .shadowKey:
                        AudioServicesPlaySystemSound(Self.input.soundID)
                case .backspace, .shadowBackspace:
                        AudioServicesPlaySystemSound(Self.delete.soundID)
                case .switchTo, .newLine, .shift:
                        AudioServicesPlaySystemSound(Self.modify.soundID)
                case .none:
                        break
                default:
                        AudioServicesPlaySystemSound(Self.input.soundID)
                }
        }
        
        static func perform(_ feedback: AudioFeedback) {
                guard isAudioFeedbackOn else { return }
                AudioServicesPlaySystemSound(feedback.soundID)
        }
        
        private static var isAudioFeedbackOn: Bool = UserDefaults.standard.bool(forKey: "audio_feedback")
        static func updateAudioFeedbackStatus() {
                isAudioFeedbackOn = UserDefaults.standard.bool(forKey: "audio_feedback")
        }
}


/// 候選詞字符標準
///
/// 1: 傳統漢字
///
/// 2: 傳統漢字（香港）
///
/// 3: 傳統漢字（臺灣）
///
/// 4: 簡化字
enum Logogram: Int {

        /// Traditional. 傳統漢字
        case traditional = 1

        /// Traditional, Hong Kong. 傳統漢字（香港）
        case hongkong = 2

        /// Traditional,Taiwan. 傳統漢字（臺灣）
        case taiwan = 3

        /// Simplified. 簡化字
        case simplified = 4

        private(set) static var current: Logogram = {
                let preference: Int = UserDefaults.standard.integer(forKey: "logogram")
                switch preference {
                case 2: return .hongkong
                case 3: return .taiwan
                case 4: return .simplified
                default: return .traditional
                }
        }()

        /// Update `Logogram.current` to the new value
        /// - Parameter newLogogram: New value for `Logogram.current`
        static func changeCurent(to newLogogram: Logogram) {
                current = newLogogram
        }

        /// Save current logogram to UserDefaults
        static func updatePreference() {
                let value: Int = current.rawValue
                UserDefaults.standard.set(value, forKey: "logogram")
        }
}
