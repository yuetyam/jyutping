enum KeyboardMode {
        case transparent
        case english
        case cantonese

        var isCantoneseMode: Bool {
                return self == .cantonese
        }
        var isEnglishMode: Bool {
                switch self {
                case .transparent:
                        return true
                case .english:
                        return true
                case .cantonese:
                        return false
                }
        }
}
