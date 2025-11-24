/// 10 key keyboard element
public enum Combo: Int, Sendable {

        case ABC  = 2
        case DEF  = 3
        case GHI  = 4
        case JKL  = 5
        case MNO  = 6
        case PQRS = 7
        case TUV  = 8
        case WXYZ = 9

        /// Same value as the `self.rawValue`
        public var code: Int { rawValue }

        /// Key text
        public var text: String {
                return Self.textMap[self]!
        }
        private static let textMap: [Combo: String] = [
                ABC : "ABC",
                DEF : "DEF",
                GHI : "GHI",
                JKL : "JKL",
                MNO : "MNO",
                PQRS: "PQRS",
                TUV : "TUV",
                WXYZ: "WXYZ",
        ]

        /// Jyutping syllable compatible letters
        public var letters: [String] {
                return Self.letterMap[self]!
        }
        private static let letterMap: [Combo: [String]] = [
                ABC : ["a", "b", "c"],
                DEF : ["d", "e", "f"],
                GHI : ["g", "h", "i"],
                JKL : ["j", "k", "l"],
                MNO : ["m", "n", "o"],
                PQRS: ["p", "s"],
                TUV : ["t", "u"],
                WXYZ: ["w", "y", "z"]
        ]
}
