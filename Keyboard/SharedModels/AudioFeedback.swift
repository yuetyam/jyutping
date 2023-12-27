import AudioToolbox

enum AudioFeedback: SystemSoundID {

        case input = 1123
        case delete = 1155
        case modify = 1156

        static func perform(_ feedback: AudioFeedback) {
                guard Options.isAudioFeedbackOn else { return }
                AudioServicesPlaySystemSound(feedback.rawValue)
        }
        static func inputed() {
                guard Options.isAudioFeedbackOn else { return }
                AudioServicesPlaySystemSound(Self.input.rawValue)
        }
        static func deleted() {
                guard Options.isAudioFeedbackOn else { return }
                AudioServicesPlaySystemSound(Self.delete.rawValue)
        }
        static func modified() {
                guard Options.isAudioFeedbackOn else { return }
                AudioServicesPlaySystemSound(Self.modify.rawValue)
        }
}
