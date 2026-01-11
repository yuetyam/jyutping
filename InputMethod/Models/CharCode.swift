import Foundation

extension StringProtocol {
        var charCode: Int? {
                guard count < 10 else { return nil }
                let codes: [Int] = compactMap(\.interCode)
                guard codes.count == count else { return nil }
                return codes.radix100Combined()
        }
}

extension RandomAccessCollection where Element == Int {
        func radix100Combined() -> Int {
                guard count < 10 else { return 0 }
                return reduce(0, { $0 * 100 + $1 })
        }
}

private extension Character {
        var interCode: Int? {
                return Self.letterCodeMap[self]
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
