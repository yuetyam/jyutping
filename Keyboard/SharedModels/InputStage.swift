enum InputStage: Int {

        /// Terminated or in background
        case idle

        /// Ready to buffer
        case standby

        /// Started buffering
        case starting

        /// Continue buffering
        case ongoing

        /// Stopped buffering
        case ending

        /// Inputing
        var isBuffering: Bool {
                switch self {
                case .idle:
                        return false
                case .standby:
                        return false
                case .starting:
                        return true
                case .ongoing:
                        return true
                case .ending:
                        return false
                }
        }
}
