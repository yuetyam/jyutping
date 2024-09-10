extension StringProtocol {
        var charcode: Int? {
                guard self.count < 10 else { return nil }
                let codes: [Int] = self.compactMap(\.intercode)
                guard codes.count == self.count else { return nil }
                let code: Int = codes.combined()
                return code
        }
        var tenKeyCharcode: Int? {
                guard self.count < 19 else { return nil }
                let codes: [Int] = self.compactMap(\.tenKeyIntercode)
                guard codes.count == self.count else { return nil }
                let code: Int = codes.tenKeyCombined()
                return code
        }
}

extension Collection where Element == Character {
        /// CharCode that replaced 'y' with 'j' for shortcut querying.
        var shortcutCode: Int? {
                let charCode: Int = self.compactMap(\.intercode)
                        .map({ $0 == 44 ? 29 : $0 }) // Replace 'y' with 'j'
                        .combined()
                return (charCode == 0) ? nil : charCode
        }
}

extension RandomAccessCollection where Element == Int {
        func combined() -> Int {
                guard self.count < 10 else { return 0 }
                return reduce(0, { $0 * 100 + $1 })
        }
        func tenKeyCombined() -> Int {
                guard self.count < 19 else { return 0 }
                return reduce(0, { $0 * 10 + $1 })
        }
}

private extension Character {
        /*
         static let digit0: Character = "0"
         static let digit1: Character = "1"
         static let digit2: Character = "2"
         static let digit3: Character = "3"
         static let digit4: Character = "4"
         static let digit5: Character = "5"
         static let digit6: Character = "6"
         static let digit7: Character = "7"
         static let digit8: Character = "8"
         static let digit9: Character = "9"
         */
        static let letterA: Character = "a"
        static let letterB: Character = "b"
        static let letterC: Character = "c"
        static let letterD: Character = "d"
        static let letterE: Character = "e"
        static let letterF: Character = "f"
        static let letterG: Character = "g"
        static let letterH: Character = "h"
        static let letterI: Character = "i"
        static let letterJ: Character = "j"
        static let letterK: Character = "k"
        static let letterL: Character = "l"
        static let letterM: Character = "m"
        static let letterN: Character = "n"
        static let letterO: Character = "o"
        static let letterP: Character = "p"
        static let letterQ: Character = "q"
        static let letterR: Character = "r"
        static let letterS: Character = "s"
        static let letterT: Character = "t"
        static let letterU: Character = "u"
        static let letterV: Character = "v"
        static let letterW: Character = "w"
        static let letterX: Character = "x"
        static let letterY: Character = "y"
        static let letterZ: Character = "z"
        // static let apostrophe: Character = "'"
}

extension Character {
        var intercode: Int? {
                switch self {
                /*
                case Self.digit0:
                        return 10
                case Self.digit1:
                        return 11
                case Self.digit2:
                        return 12
                case Self.digit3:
                        return 13
                case Self.digit4:
                        return 14
                case Self.digit5:
                        return 15
                case Self.digit6:
                        return 16
                case Self.digit7:
                        return 17
                case Self.digit8:
                        return 18
                case Self.digit9:
                        return 19
                */
                case Self.letterA:
                        return 20
                case Self.letterB:
                        return 21
                case Self.letterC:
                        return 22
                case Self.letterD:
                        return 23
                case Self.letterE:
                        return 24
                case Self.letterF:
                        return 25
                case Self.letterG:
                        return 26
                case Self.letterH:
                        return 27
                case Self.letterI:
                        return 28
                case Self.letterJ:
                        return 29
                case Self.letterK:
                        return 30
                case Self.letterL:
                        return 31
                case Self.letterM:
                        return 32
                case Self.letterN:
                        return 33
                case Self.letterO:
                        return 34
                case Self.letterP:
                        return 35
                case Self.letterQ:
                        return 36
                case Self.letterR:
                        return 37
                case Self.letterS:
                        return 38
                case Self.letterT:
                        return 39
                case Self.letterU:
                        return 40
                case Self.letterV:
                        return 41
                case Self.letterW:
                        return 42
                case Self.letterX:
                        return 43
                case Self.letterY:
                        return 44
                case Self.letterZ:
                        return 45
                /*
                case Self.apostrophe:
                        return 46
                */
                default:
                        return nil
                }
        }
}

extension Int {
        var convertedCharacter: Character? {
                switch self {
                case 20:
                        return Character.letterA
                case 21:
                        return Character.letterB
                case 22:
                        return Character.letterC
                case 23:
                        return Character.letterD
                case 24:
                        return Character.letterE
                case 25:
                        return Character.letterF
                case 26:
                        return Character.letterG
                case 27:
                        return Character.letterH
                case 28:
                        return Character.letterI
                case 29:
                        return Character.letterJ
                case 30:
                        return Character.letterK
                case 31:
                        return Character.letterL
                case 32:
                        return Character.letterM
                case 33:
                        return Character.letterN
                case 34:
                        return Character.letterO
                case 35:
                        return Character.letterP
                case 36:
                        return Character.letterQ
                case 37:
                        return Character.letterR
                case 38:
                        return Character.letterS
                case 39:
                        return Character.letterT
                case 40:
                        return Character.letterU
                case 41:
                        return Character.letterV
                case 42:
                        return Character.letterW
                case 43:
                        return Character.letterX
                case 44:
                        return Character.letterY
                case 45:
                        return Character.letterZ
                default:
                        return nil
                }
        }
}

extension Character {
        var tenKeyIntercode: Int? {
                switch self {
                case Self.letterA:
                        return 2
                case Self.letterB:
                        return 2
                case Self.letterC:
                        return 2
                case Self.letterD:
                        return 3
                case Self.letterE:
                        return 3
                case Self.letterF:
                        return 3
                case Self.letterG:
                        return 4
                case Self.letterH:
                        return 4
                case Self.letterI:
                        return 4
                case Self.letterJ:
                        return 5
                case Self.letterK:
                        return 5
                case Self.letterL:
                        return 5
                case Self.letterM:
                        return 6
                case Self.letterN:
                        return 6
                case Self.letterO:
                        return 6
                case Self.letterP:
                        return 7
                case Self.letterQ:
                        return 7
                case Self.letterR:
                        return 7
                case Self.letterS:
                        return 7
                case Self.letterT:
                        return 8
                case Self.letterU:
                        return 8
                case Self.letterV:
                        return 8
                case Self.letterW:
                        return 9
                case Self.letterX:
                        return 9
                case Self.letterY:
                        return 9
                case Self.letterZ:
                        return 9
                default:
                        return nil
                }
        }
}
