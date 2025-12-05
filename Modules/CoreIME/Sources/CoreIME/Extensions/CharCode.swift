extension StringProtocol {
        var charCode: Int? {
                guard count < 10 else { return nil }
                let codes: [Int] = compactMap(\.interCode)
                guard codes.count == count else { return nil }
                return codes.radix100Combined()
        }
        var nineKeyCharCode: Int? {
                guard count < 19 else { return nil }
                let codes: [Int] = compactMap(\.nineKeyInterCode)
                guard codes.count == count else { return nil }
                return codes.decimalCombined()
        }
}

extension Collection where Element == Character {
        /// CharCode that replaced 'y' with 'j' for anchors.
        var anchorsCode: Int? {
                let charCode: Int = compactMap(\.interCode)
                        .map({ $0 == 44 ? 29 : $0 }) // Replace 'y' with 'j'
                        .radix100Combined()
                return (charCode == 0) ? nil : charCode
        }
}

extension RandomAccessCollection where Element == Int {
        func radix100Combined() -> Int {
                guard count < 10 else { return 0 }
                return reduce(0, { $0 * 100 + $1 })
        }
        func decimalCombined() -> Int {
                guard count < 19 else { return 0 }
                return reduce(0, { $0 * 10 + $1 })
        }
}

extension Character {

        var interCode: Int? {
                return Self.letterCodeMap[self]
        }

        var inputEventCode: Int? {
                return Self.letterCodeMap[self] ?? Self.numberCodeMap[self]
        }

        private static let letterCodeMap: [Character : Int] = [
                letterA : 20,
                letterB : 21,
                letterC : 22,
                letterD : 23,
                letterE : 24,
                letterF : 25,
                letterG : 26,
                letterH : 27,
                letterI : 28,
                letterJ : 29,
                letterK : 30,
                letterL : 31,
                letterM : 32,
                letterN : 33,
                letterO : 34,
                letterP : 35,
                letterQ : 36,
                letterR : 37,
                letterS : 38,
                letterT : 39,
                letterU : 40,
                letterV : 41,
                letterW : 42,
                letterX : 43,
                letterY : 44,
                letterZ : 45,
        ]
        private static let numberCodeMap: [Character : Int] = [
                number0 : 10,
                number1 : 11,
                number2 : 12,
                number3 : 13,
                number4 : 14,
                number5 : 15,
                number6 : 16,
                number7 : 17,
                number8 : 18,
                number9 : 19,
        ]
}

extension Character {

        var nineKeyInterCode: Int? {
                return Self.nineKeyCodeMap[self]
        }

        private static let nineKeyCodeMap: [Character : Int] = [
                letterA : 2,
                letterB : 2,
                letterC : 2,
                letterD : 3,
                letterE : 3,
                letterF : 3,
                letterG : 4,
                letterH : 4,
                letterI : 4,
                letterJ : 5,
                letterK : 5,
                letterL : 5,
                letterM : 6,
                letterN : 6,
                letterO : 6,
                letterP : 7,
                letterQ : 7,
                letterR : 7,
                letterS : 7,
                letterT : 8,
                letterU : 8,
                letterV : 8,
                letterW : 9,
                letterX : 9,
                letterY : 9,
                letterZ : 9,
        ]
}

private extension Character {
        static let number0: Character = "0"
        static let number1: Character = "1"
        static let number2: Character = "2"
        static let number3: Character = "3"
        static let number4: Character = "4"
        static let number5: Character = "5"
        static let number6: Character = "6"
        static let number7: Character = "7"
        static let number8: Character = "8"
        static let number9: Character = "9"
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
}
