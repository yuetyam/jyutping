enum InputStage: Int {

        /// Terminated or in background
        case idle

        /// Ready to buffer
        case standby

        /// Composing PunctuationKey
        case composing

        /// Start buffering
        case starting

        /// Continue buffering
        case ongoing

        /// Inputing
        var isBuffering: Bool {
                switch self {
                case .idle: false
                case .standby: false
                case .composing: true
                case .starting: true
                case .ongoing: true
                }
        }
}
