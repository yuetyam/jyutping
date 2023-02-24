enum InputState: Int {

        case cantonese = 1
        case transparent = 2
        case switches = 3

        var isCantonese: Bool {
                return self == .cantonese
        }

        var isTransparent: Bool {
                return self == .transparent
        }

        var isSwitches: Bool {
                return self == .switches
        }

        private(set) static var current: InputState = {
                switch InstantSettings.inputMethodMode {
                case .cantonese:
                        return .cantonese
                case .abc:
                        return .transparent
                }
        }()
        static func updateCurrent(to state: InputState? = nil) {
                if let state {
                        current = state
                } else {
                        let newState: InputState = {
                                switch InstantSettings.inputMethodMode {
                                case .cantonese:
                                        return .cantonese
                                case .abc:
                                        return .transparent
                                }
                        }()
                        current = newState
                }
        }
}
