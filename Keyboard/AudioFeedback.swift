import AudioToolbox

enum AudioFeedback {
        case
        input,
        delete,
        modify
        
        private var systemSoundId: SystemSoundID {
                switch self {
                case .input:
                        return 1123
                case .delete:
                        return 1155
                case .modify:
                        return 1156
                }
        }
        
        static func play(for keyboardEvent: KeyboardEvent) {
                guard isAudioFeedbackOn else { return }
                switch keyboardEvent {
                case .key, .shadowKey:
                        feedback(.input)
                case .backspace, .shadowBackspace:
                        feedback(.delete)
                case .switchTo(_), .newLine, .shift, .shiftDown:
                        feedback(.modify)
                case .none:
                        break
                default:
                        feedback(.input)
                }
        }
        private static func feedback(_ audioFeedback: AudioFeedback) {
                AudioServicesPlaySystemSound(audioFeedback.systemSoundId)
        }
        
        static func perform(_ audioFeedback: AudioFeedback) {
                guard isAudioFeedbackOn else { return }
                AudioServicesPlaySystemSound(audioFeedback.systemSoundId)
        }
        
        private static var isAudioFeedbackOn: Bool = UserDefaults.standard.bool(forKey: "audio_feedback")
        static func updateAudioFeedbackStatus() {
                isAudioFeedbackOn = UserDefaults.standard.bool(forKey: "audio_feedback")
        }
}
