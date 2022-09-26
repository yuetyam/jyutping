enum InputMethodMode {

        case transparent
        case english
        case cantonese
        case instantSettings

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
                case .instantSettings:
                        return false
                }
        }
        var isInstantSettings: Bool {
                return self == .instantSettings
        }
}
