/// Cantonese / ABC
enum InputMethodMode: Int {
        case cantonese = 1
        case abc = 2
        var isCantonese: Bool {
                return self == .cantonese
        }
        var isABC: Bool {
                return self == .abc
        }
}

enum KeyboardForm {
        case alphabet
        case candidateBoard
        case decimalPad
        case editingPanel
        case emojiBoard
        case numberPad
        case numeric
        case settings
        case symbolic
}
