/// 10 Key keyboard element
public enum Combo: Int, Sendable {

        case ABC = 2
        case DEF = 3
        case GHI = 4
        case JKL = 5
        case MNO = 6
        case PQRS = 7
        case TUV = 8
        case WXYZ = 9

        public var text: String {
                return Self.textMap[self]!
        }
        private static let textMap: [Combo: String] = [
                Combo.ABC : "ABC",
                Combo.DEF : "DEF",
                Combo.GHI : "GHI",
                Combo.JKL : "JKL",
                Combo.MNO : "MNO",
                Combo.PQRS: "PQRS",
                Combo.TUV : "TUV",
                Combo.WXYZ: "WXYZ",
        ]

        public var letters: [String] {
                return Self.letterMap[self]!
        }
        private static let letterMap: [Combo: [String]] = [
                Combo.ABC : ["a", "b", "c"],
                Combo.DEF : ["d", "e", "f"],
                Combo.GHI : ["g", "h", "i"],
                Combo.JKL : ["j", "k", "l"],
                Combo.MNO : ["m", "n", "o"],
                Combo.PQRS: ["p", "s"],
                Combo.TUV : ["t", "u"],
                Combo.WXYZ: ["w", "y", "z"]
        ]
}
