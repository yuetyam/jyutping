extension String {
        var code: Int {
                let codes: [Int] = self.map { (character) -> Int in
                        switch character {
                        case "0": return 10
                        case "1": return 11
                        case "2": return 12
                        case "3": return 13
                        case "4": return 14
                        case "5": return 15
                        case "6": return 16
                        case "7": return 17
                        case "8": return 18
                        case "9": return 19

                        case "a": return 21
                        case "b": return 22
                        case "c": return 23
                        case "d": return 24
                        case "e": return 25
                        case "f": return 26
                        case "g": return 27
                        case "h": return 28
                        case "i": return 29
                        case "j": return 30
                        case "k": return 31
                        case "l": return 32
                        case "m": return 33
                        case "n": return 34
                        case "o": return 35
                        case "p": return 36
                        case "q": return 37
                        case "r": return 38
                        case "s": return 39
                        case "t": return 40
                        case "u": return 41
                        case "v": return 42
                        case "w": return 43
                        case "x": return 44
                        case "y": return 45
                        case "z": return 46

                        case "A": return 51
                        case "B": return 52
                        case "C": return 53
                        case "D": return 54
                        case "E": return 55
                        case "F": return 56
                        case "G": return 57
                        case "H": return 58
                        case "I": return 59
                        case "J": return 60
                        case "K": return 61
                        case "L": return 62
                        case "M": return 63
                        case "N": return 64
                        case "O": return 65
                        case "P": return 66
                        case "Q": return 67
                        case "R": return 68
                        case "S": return 69
                        case "T": return 70
                        case "U": return 71
                        case "V": return 72
                        case "W": return 73
                        case "X": return 74
                        case "Y": return 75
                        case "Z": return 76

                        case " ": return 20
                        default: return 50
                        }
                }
                let codeString: String = codes.reduce("") { $0 + String($1) }
                return Int(codeString) ?? 50
        }
}
