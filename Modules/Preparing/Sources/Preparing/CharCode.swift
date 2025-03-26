extension StringProtocol {
        var charcode: Int? {
                guard self.count < 10 else { return nil }
                let codes: [Int] = self.compactMap(\.intercode)
                guard codes.count == self.count else { return nil }
                let code: Int = codes.radix100Combined()
                return code
        }
        var tenKeyCharcode: Int? {
                guard self.count < 19 else { return nil }
                let codes: [Int] = self.compactMap(\.tenKeyIntercode)
                guard codes.count == self.count else { return nil }
                let code: Int = codes.decimalCombined()
                return code
        }
}

extension Collection where Element == Character {
        /// CharCode that replaced 'y' with 'j' for anchors.
        var anchorsCode: Int? {
                let charCode: Int = self.compactMap(\.intercode)
                        .map({ $0 == 44 ? 29 : $0 }) // Replace 'y' with 'j'
                        .radix100Combined()
                return (charCode == 0) ? nil : charCode
        }
}

extension RandomAccessCollection where Element == Int {
        func radix100Combined() -> Int {
                guard self.count < 10 else { return 0 }
                return reduce(0, { $0 * 100 + $1 })
        }
        func decimalCombined() -> Int {
                guard self.count < 19 else { return 0 }
                return reduce(0, { $0 * 10 + $1 })
        }
}

extension Character {

        var intercode: Int? {
                return Self.codeMap[self]
        }

        private static let codeMap: [Character : Int] = [
                Self.letterA : 20,
                Self.letterB : 21,
                Self.letterC : 22,
                Self.letterD : 23,
                Self.letterE : 24,
                Self.letterF : 25,
                Self.letterG : 26,
                Self.letterH : 27,
                Self.letterI : 28,
                Self.letterJ : 29,
                Self.letterK : 30,
                Self.letterL : 31,
                Self.letterM : 32,
                Self.letterN : 33,
                Self.letterO : 34,
                Self.letterP : 35,
                Self.letterQ : 36,
                Self.letterR : 37,
                Self.letterS : 38,
                Self.letterT : 39,
                Self.letterU : 40,
                Self.letterV : 41,
                Self.letterW : 42,
                Self.letterX : 43,
                Self.letterY : 44,
                Self.letterZ : 45,
        ]
}

extension Character {

        var tenKeyIntercode: Int? {
                return Self.tenKeyCodeMap[self]
        }

        private static let tenKeyCodeMap: [Character : Int] = [
                Self.letterA : 2,
                Self.letterB : 2,
                Self.letterC : 2,
                Self.letterD : 3,
                Self.letterE : 3,
                Self.letterF : 3,
                Self.letterG : 4,
                Self.letterH : 4,
                Self.letterI : 4,
                Self.letterJ : 5,
                Self.letterK : 5,
                Self.letterL : 5,
                Self.letterM : 6,
                Self.letterN : 6,
                Self.letterO : 6,
                Self.letterP : 7,
                Self.letterQ : 7,
                Self.letterR : 7,
                Self.letterS : 7,
                Self.letterT : 8,
                Self.letterU : 8,
                Self.letterV : 8,
                Self.letterW : 9,
                Self.letterX : 9,
                Self.letterY : 9,
                Self.letterZ : 9,
        ]
}

private extension Character {
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
