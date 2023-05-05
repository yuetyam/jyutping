enum Appearance: Int {
        case light
        case dark
        var isLight: Bool {
                return self == .light
        }
        var isDark: Bool {
                return self == .dark
        }
}
