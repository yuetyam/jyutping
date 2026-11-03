/// A letter group on a nine-key keypad, with its keypad digit as the raw value.
public enum KeypadCombo: Int, CaseIterable, Sendable {

        /// The ABC group on digit 2.
        case ABC  = 2

        /// The DEF group on digit 3.
        case DEF  = 3

        /// The GHI group on digit 4.
        case GHI  = 4

        /// The JKL group on digit 5.
        case JKL  = 5

        /// The MNO group on digit 6.
        case MNO  = 6

        /// The PQRS group on digit 7.
        case PQRS = 7

        /// The TUV group on digit 8.
        case TUV  = 8

        /// The WXYZ group on digit 9.
        case WXYZ = 9

        /// The keypad digit from 2 through 9, equal to `rawValue`.
        public var digit: Int { rawValue }

        /// The full uppercase letter group displayed on the key, including non-Jyutping letters.
        public var text: String {
                return Self.textMap[self]!
        }
        private static let textMap: [KeypadCombo: String] = [
                ABC : "ABC",
                DEF : "DEF",
                GHI : "GHI",
                JKL : "JKL",
                MNO : "MNO",
                PQRS: "PQRS",
                TUV : "TUV",
                WXYZ: "WXYZ",
        ]

        /// The lowercase letters usable in Jyutping syllables, in keypad order.
        ///
        /// The PQRS, TUV, and WXYZ groups omit `q`, `r`, `v`, and `x`.
        public var letters: [String] {
                return Self.letterMap[self]!
        }
        private static let letterMap: [KeypadCombo: [String]] = [
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

extension RandomAccessCollection where Element == KeypadCombo {
        /// Combines the decimal digit codes using wrapping arithmetic.
        ///
        /// For example, `[.ABC, .DEF]` produces `23`. An empty collection produces `0`;
        /// values exceeding the range of `Int` wrap rather than trapping.
        public var decimalCombinedCode: Int {
                return reduce(0, { $0 &* 10 &+ $1.digit })
        }
}

/// An alternate name for a nine-key keypad letter group.
public typealias Combo = KeypadCombo
