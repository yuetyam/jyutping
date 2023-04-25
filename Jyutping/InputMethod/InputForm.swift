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

        static func matchInputMethodMode() -> InputForm {
                switch Options.inputMethodMode {
                case .cantonese:
                        return .cantonese
                case .abc:
                        return .transparent
                }
        }
}
