enum InputForm: Int {

        case cantonese = 1
        case transparent = 2
        case options = 3

        var isCantonese: Bool {
                return self == .cantonese
        }
        var isTransparent: Bool {
                return self == .transparent
        }
        var isOptions: Bool {
                return self == .options
        }

        private(set) static var current: InputForm = {
                switch InstantSettings.inputMethodMode {
                case .cantonese:
                        return .cantonese
                case .abc:
                        return .transparent
                }
        }()
        static func updateCurrent(to form: InputForm? = nil) {
                current = form ?? {
                        switch InstantSettings.inputMethodMode {
                        case .cantonese:
                                return .cantonese
                        case .abc:
                                return .transparent
                        }
                }()
        }
}
