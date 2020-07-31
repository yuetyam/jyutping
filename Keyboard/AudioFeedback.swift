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
                        return 1104
                case .click:
                        return 1123
                case .delete:
                        return 1155
                case .modify:
                        return 1156
                }
        }
        
        static func play(for keyboardEvent: KeyboardEvent) {
                guard UserDefaults.standard.bool(forKey: "audio_feedback") else { return }
                switch keyboardEvent {
                case .text(_):
                        perform(audioFeedback: .input)
                case .backspace:
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
                guard UserDefaults.standard.bool(forKey: "audio_feedback") else { return }
                AudioServicesPlaySystemSound(audioFeedback.systemSoundId)
        }
}
