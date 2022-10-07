enum InputState: Int {

        case cantonese = 1
        case english = 2
        case instantSettings = 3

        var isCantonese: Bool {
                return self == .cantonese
        }

        var isEnglish: Bool {
                return self == .english
        }

        var isInstantSettings: Bool {
                return self == .instantSettings
        }
}
