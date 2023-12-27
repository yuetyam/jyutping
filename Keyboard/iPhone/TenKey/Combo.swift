enum Combo: Int {

        case ABC = 2
        case DEF = 3
        case GHI = 4
        case JKL = 5
        case MNO = 6
        case PQRS = 7
        case TUV = 8
        case WXYZ = 9

        var text: String {
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

        var keys: [String] {
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
        var anchors: [String] {
                switch self {
                case .ABC:
                        return ["b", "c"]
                case .DEF:
                        return ["d", "f"]
                case .GHI:
                        return ["g", "h"]
                case .JKL:
                        return ["j", "k", "l"]
                case .MNO:
                        return ["m", "n"]
                case .PQRS:
                        return ["p", "s"]
                case .TUV:
                        return ["t"]
                case .WXYZ:
                        return ["w", "y", "z"]
                }
        }
}
