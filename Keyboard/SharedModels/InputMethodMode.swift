/// Cantonese / ABC
enum InputMethodMode: Int {
        case cantonese = 1
        case abc = 2
        var isCantonese: Bool { self == .cantonese }
        var isABC: Bool { self == .abc }
}
