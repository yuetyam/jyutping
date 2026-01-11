enum InputStage: Int {

        /// Terminated or in background
        case idle

        /// Ready to buffer
        case standby

        /// Composing PunctuationKey
        case composing

        /// Started buffering
        case starting

        /// Continue buffering
        case ongoing

        /// Stopped buffering
        case ending

        /// Inputing
        var isBuffering: Bool {
                switch self {
                case .idle: false
                case .standby: false
                case .composing: true
                case .starting: true
                case .ongoing: true
                case .ending: false
                }
        }
}
