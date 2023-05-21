import AudioToolbox

enum AudioFeedback: Int {

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

        static func perform(_ feedback: AudioFeedback) {
                guard Options.isAudioFeedbackOn else { return }
                AudioServicesPlaySystemSound(feedback.soundID)
        }
}
