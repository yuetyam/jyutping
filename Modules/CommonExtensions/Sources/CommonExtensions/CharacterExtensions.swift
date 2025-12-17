extension Character {

        /// Unicode code points. Example: é = `["U+65", "U+301"]`
        public var codePoints: [String] {
                return self.unicodeScalars.map { "U+" + String($0.value, radix: 16, uppercase: true) }
        }

        /// Unicode code points as a String. Example: é = "U+65 U+301"
        public var codePointsText: String {
                return self.codePoints.joined(separator: String.space)
        }

        /// Create a Character from the given Unicode Code Point String (U+XXXX)
        public init?(codePoint: String) {
                let cropped = codePoint.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "U+", with: "", options: [.anchored, .caseInsensitive])
                guard let u32 = UInt32(cropped, radix: 16) else { return nil }
                guard let scalar = Unicode.Scalar(u32) else { return nil }
                self.init(scalar)
        }

        /// Unicode code point as decimal code
        public var decimalCode: Int? {
                guard let scalar = self.unicodeScalars.first else { return nil }
                let number = Int(scalar.value)
                return number
        }

        /// Create a Character from the given Unicode code point (decimal)
        public init?(decimal: Int) {
                guard let scalar = Unicode.Scalar(decimal) else { return nil }
                self.init(scalar)
        }

        /// U+0020
        public static let space: Character = "\u{20}"

        /// U+0020
        public var isSpace: Bool {
                return self == Self.space
        }

        /// U+0027 ( ' ) Separator; Delimiter; Quote
        public static let apostrophe: Character = "\u{27}"

        /// U+0027 ( ' ) Separator; Delimiter; Quote
        public var isApostrophe: Bool {
                return self == Self.apostrophe
        }

        /// U+0060 ( ` ) Grave accent; Backtick; Backquote
        public static let grave: Character = "\u{60}"

        /// U+0060 ( ` ) Grave accent; Backtick; Backquote
        public var isGrave: Bool {
                return self == Self.grave
        }

        /// a-z or A-Z
        public var isBasicLatinLetter: Bool {
                return ("a"..."z") ~= self || ("A"..."Z") ~= self
        }

        /// a-z
        public var isLowercaseBasicLatinLetter: Bool {
                return ("a"..."z") ~= self
        }

        /// A-Z
        public var isUppercaseBasicLatinLetter: Bool {
                return ("A"..."Z") ~= self
        }

        /// 0-9
        public var isBasicDigit: Bool {
                return ("0"..."9") ~= self
        }

        /// a-z, A-Z, or 0-9
        public var isAlphanumeric: Bool {
                return isBasicLatinLetter || isBasicDigit
        }

        /// 1-6
        public var isCantoneseToneDigit: Bool {
                return ("1"..."6") ~= self
        }

        /// is CJKV character
        public var isIdeographic: Bool {
                return unicodeScalars.first?.value.isIdeographicCodePoint ?? false
        }

        /// is supplemental ideographic character
        public var isSupplementalCJKVCharacter: Bool {
                return unicodeScalars.first?.value.isSupplementalCJKVCodePoint ?? false
        }

        /// ideographic or supplemental CJKV character
        public var isGenericCJKVCharacter: Bool {
                return unicodeScalars.first?.value.isGenericCJKVCodePoint ?? false
        }
}

extension BinaryInteger {
        /// CJKV character Unicode code point
        public var isIdeographicCodePoint: Bool {
                switch self {
                case 0x4E00...0x9FFF,
                     0x3400...0x4DBF,
                     0x20000...0x2A6DF,
                     0x2A700...0x2B73F,
                     0x2B740...0x2B81F,
                     0x2B820...0x2CEAF,
                     0x2CEB0...0x2EBEF,
                     0x30000...0x3134F,
                     0x31350...0x323AF,
                     0x2EBF0...0x2EE5F,
                     0x323B0...0x33479,
                     0x3007: true
                default: false
                }
        }

        /// CJKV supplemental code point
        public var isSupplementalCJKVCodePoint: Bool {
                switch self {
                case 0x2E80...0x2E99,
                     0x2E9B...0x2EF3,
                     0x2F00...0x2FD5,
                     0xF900...0xFA6D,
                     0xFA70...0xFAD9,
                     0x2F800...0x2FA1D: true
                default: false
                }
        }

        /// ideographic or supplemental CJKV code point
        public var isGenericCJKVCodePoint: Bool {
                return isIdeographicCodePoint || isSupplementalCJKVCodePoint
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
U+323B0-U+33479: CJK Unified Ideographs Extension J
*/

/*
U+2E80-U+2E99: CJK Radicals Supplement
U+2E9B-U+2EF3: CJK Radicals Supplement
U+2F00-U+2FD5: Kangxi Radicals
U+F900-U+FA6D: CJK Compatibility Ideographs
U+FA70-U+FAD9: CJK Compatibility Ideographs
U+2F800-U+2FA1D: CJK Compatibility Ideographs Supplement
*/

