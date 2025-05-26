extension Character {

        /// U+0020
        static let space: Character = "\u{20}"

        /// U+0020
        var isSpace: Bool {
                return self == Self.space
        }

        /// U+0027 ( ' ) apostrophe
        static let separator: Character = "\u{27}"

        /// U+0027 ( ' ) apostrophe
        var isSeparator: Bool {
                return self == Self.separator
        }

        /// A Boolean value indicating whether this character represents a Cantonese tone number (1-6).
        var isTone: Bool {
                return ("1"..."6") ~= self
        }

        /// A Boolean value indicating whether this character represents a space or a tone number.
        var isSpaceOrTone: Bool {
                return self.isSpace || self.isTone
        }

        /// A Boolean value indicating whether this character represents a separator or a tone number.
        var isSeparatorOrTone: Bool {
                return self.isSeparator || self.isTone
        }

        /// A Boolean value indicating whether this character represents a space / a tone number / a separator.
        var isSpaceOrToneOrSeparator: Bool {
                return self.isSpace || self.isTone || self.isSeparator
        }

        /// a-z or A-Z
        var isBasicLatinLetter: Bool {
                return ("a"..."z") ~= self || ("A"..."Z") ~= self
        }

        /// a-z
        var isLowercaseBasicLatinLetter: Bool {
                return ("a"..."z") ~= self
        }

        /// A-Z
        var isUppercaseBasicLatinLetter: Bool {
                return ("A"..."Z") ~= self
        }

        /// 0-9
        var isBasicDigit: Bool {
                return ("0"..."9") ~= self
        }

        /// is CJKV character
        var isIdeographic: Bool {
                guard let scalarValue: UInt32 = self.unicodeScalars.first?.value else { return false }
                switch scalarValue {
                case 0x3007: return true
                case 0x4E00...0x9FFF: return true
                case 0x3400...0x4DBF: return true
                case 0x20000...0x2A6DF: return true
                case 0x2A700...0x2B73F: return true
                case 0x2B740...0x2B81F: return true
                case 0x2B820...0x2CEAF: return true
                case 0x2CEB0...0x2EBEF: return true
                case 0x30000...0x3134F: return true
                case 0x31350...0x323AF: return true
                case 0x2EBF0...0x2EE5F: return true
                default: return false
                }
        }
}

extension UInt32 {
        /// is CJKV character code point
        var isIdeographicCodePoint: Bool {
                switch self {
                case 0x3007: true
                case 0x4E00...0x9FFF: true
                case 0x3400...0x4DBF: true
                case 0x20000...0x2A6DF: true
                case 0x2A700...0x2B73F: true
                case 0x2B740...0x2B81F: true
                case 0x2B820...0x2CEAF: true
                case 0x2CEB0...0x2EBEF: true
                case 0x30000...0x3134F: true
                case 0x31350...0x323AF: true
                case 0x2EBF0...0x2EE5F: true
                default: false
                }
        }
}

/*
U+3007: Character Zero
U+4E00-U+9FFF: CJK Unified Ideographs
U+3400-U+4DBF: CJK Unified Ideographs Extension A
U+20000-U+2A6DF: CJK Unified Ideographs Extension B
U+2A700-U+2B73F: CJK Unified Ideographs Extension C
U+2B740-U+2B81F: CJK Unified Ideographs Extension D
U+2B820-U+2CEAF: CJK Unified Ideographs Extension E
U+2CEB0-U+2EBEF: CJK Unified Ideographs Extension F
U+30000-U+3134F: CJK Unified Ideographs Extension G
U+31350-U+323AF: CJK Unified Ideographs Extension H
U+2EBF0-U+2EE5F: CJK Unified Ideographs Extension I
*/
