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
                case .none:
                        break
                case .input, .text, .hidden(.text), .space, .tab:
                        AudioServicesPlaySystemSound(Self.input.soundID)
                case .backspace, .hidden(.backspace):
                        AudioServicesPlaySystemSound(Self.delete.soundID)
                case .capsLock, .globe, .keyboard, .newLine, .shift, .transform:
                        AudioServicesPlaySystemSound(Self.modify.soundID)
                default:
                        AudioServicesPlaySystemSound(Self.input.soundID)
                }
        }
        
        static func perform(_ feedback: AudioFeedback) {
                guard isAudioFeedbackOn else { return }
                AudioServicesPlaySystemSound(feedback.soundID)
        }
        
        private(set) static var isAudioFeedbackOn: Bool = UserDefaults.standard.bool(forKey: "audio_feedback")
        static func updateAudioFeedbackStatus() {
                isAudioFeedbackOn = UserDefaults.standard.bool(forKey: "audio_feedback")
        }
}