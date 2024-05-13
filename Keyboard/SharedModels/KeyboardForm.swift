enum KeyboardForm: Int {
        case alphabetic
        case candidateBoard
        case decimalPad
        case editingPanel
        case emojiBoard
        case numberPad
        case numeric
        case settings
        case symbolic
        case tenKeyNumeric
}

enum QwertyForm: Int {

        /// Alphabetic, English
        case abc

        /// Alphabetic, Cantonese (粵拼全鍵盤)
        case jyutping

        /// Cantonense SaamPing (粵拼三拼)
        case tripleStroke

        case pinyin
        case cangjie
        case stroke

        /// LoengFan (粵拼兩分反查)
        case compose
}
