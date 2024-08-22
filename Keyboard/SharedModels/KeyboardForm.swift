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

        /// Cantonese SaamPing (粵拼三拼)
        case tripleStroke

        case pinyin

        /// Cangjie or Quick(Sucheng)
        case cangjie

        case stroke

        /// LoengFan Reverse Lookup. 拆字、兩分反查. 例如 木 + 旦 = 查: mukdaan
        case structure
}
