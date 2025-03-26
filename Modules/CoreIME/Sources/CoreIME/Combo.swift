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
                switch self {
                case .ABC:
                        return "ABC"
                case .DEF:
                        return "DEF"
                case .GHI:
                        return "GHI"
                case .JKL:
                        return "JKL"
                case .MNO:
                        return "MNO"
                case .PQRS:
                        return "PQRS"
                case .TUV:
                        return "TUV"
                case .WXYZ:
                        return "WXYZ"
                }
        }

        public var characters: [Character] {
                switch self {
                case .ABC:
                        return ["a", "b", "c"]
                case .DEF:
                        return ["d", "e", "f"]
                case .GHI:
                        return ["g", "h", "i"]
                case .JKL:
                        return ["j", "k", "l"]
                case .MNO:
                        return ["m", "n", "o"]
                case .PQRS:
                        return ["p", "s"]
                case .TUV:
                        return ["t", "u"]
                case .WXYZ:
                        return ["w", "y", "z"]
                }
        }

        public var letters: [String] {
                return Self.letterMap[self]!
        }
        private static let letterMap: [Combo: [String]] = [
                Combo.ABC  : ["a", "b", "c"],
                Combo.DEF  : ["d", "e", "f"],
                Combo.GHI  : ["g", "h", "i"],
                Combo.JKL  : ["j", "k", "l"],
                Combo.MNO  : ["m", "n", "o"],
                Combo.PQRS : ["p", "s"],
                Combo.TUV  : ["t", "u"],
                Combo.WXYZ : ["w", "y", "z"]
        ]
}
