/// InputMethodType
enum CompositionType: Int {

        /// Jyutping and reverse lookup using character components. 粵拼以及兩分拆字反查粵拼
        case primary

        /// Reverse lookup using Mandarin Pinyin. 普通話拼音反查粵拼
        case pinyin

        /// Reverse lookup using Cangjie or Quick. 倉頡或速成反查粵拼
        case cangjie

        /// Reverse lookup using Stroke. 筆畫反查粵拼
        case stroke
}
