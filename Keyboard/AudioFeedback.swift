import AudioToolbox

enum AudioFeedback: Equatable {
        case
        input,
        click,
        delete,
        modify
        
        private var systemSoundId: SystemSoundID {
                switch self {
                case .input:
                        return 1123 // Used to be 1104
                case .click:
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
                case .text(_), .keyALeft, .keyLRight, .keyZLeft:
                        perform(audioFeedback: .input)
                case .backspace, .keyBackspaceLeft:
                        perform(audioFeedback: .delete)
                case .switchTo(_), .newLine, .shift, .shiftDown:
                        perform(audioFeedback: .modify)
                case .none:
                        break
                default:
                        perform(audioFeedback: .click)
                }
        }
        
        static func perform(audioFeedback: AudioFeedback) {
                guard isAudioFeedbackOn else { return }
                AudioServicesPlaySystemSound(audioFeedback.systemSoundId)
        }
        
        private static var isAudioFeedbackOn: Bool = {
                return UserDefaults.standard.bool(forKey: "audio_feedback")
        }()
        static func updateAudioFeedbackStatus() {
                isAudioFeedbackOn = UserDefaults.standard.bool(forKey: "audio_feedback")
        }
}
