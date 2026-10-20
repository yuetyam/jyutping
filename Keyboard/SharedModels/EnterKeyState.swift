import CommonExtensions

enum EnterKeyState: Int {
        case bufferingMutilated
        case bufferingTraditional
        case standbyABC
        case standbyMutilated
        case standbyTraditional
        case unavailableABC
        case unavailableMutilated
        case unavailableTraditional
}

extension EnterKeyState {

        var isAvailable: Bool {
                switch self {
                case .unavailableABC,
                .unavailableMutilated,
                .unavailableTraditional: false
                default: true
                }
        }

        var isBuffering: Bool {
                switch self {
                case .bufferingMutilated,
                .bufferingTraditional: true
                default: false
                }
        }

        static func responsive(isAvailable: Bool, isABC: Bool, isMutilated: Bool, isBuffering: Bool) -> EnterKeyState {
                guard isBuffering.negative else {
                        return isMutilated ? .bufferingMutilated : .bufferingTraditional
                }
                guard isABC.negative else {
                        return isAvailable ? .standbyABC : .unavailableABC
                }
                guard isMutilated.negative else {
                        return isAvailable ? .standbyMutilated : .unavailableMutilated
                }
                return isAvailable ? .standbyTraditional : .unavailableTraditional
        }
}
