extension Character {

        /// UNICODE code points. Example: é = ["U+65", "U+301"]
        public var codePoints: [String] {
                return self.unicodeScalars.map { "U+" + String($0.value, radix: 16, uppercase: true) }
        }

        /// UNICODE code points as a String. Example: é = "U+65 U+301"
        public var codePointsText: String {
                return self.codePoints.joined(separator: " ")
        }

        /// Create a Character from the given Unicode Code Point String (U+XXXX)
        public init?(codePoint: String) {
                let cropped = codePoint.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "U+", with: "", options: [.anchored, .caseInsensitive])
                guard let u32 = UInt32(cropped, radix: 16) else { return nil }
                guard let scalar = Unicode.Scalar(u32) else { return nil }
                self.init(scalar)
        }


        /// UNICODE code point as decimal code
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


        /// a-z or A-Z
        public var isBasicLatinLetter: Bool {
                return ("a"..."z") ~= self || ("A"..."Z") ~= self
        }


        /// is CJKV character
        public var isIdeographic: Bool {
                guard let scalarValue: UInt32 = self.unicodeScalars.first?.value else { return false }
                switch scalarValue {
                case 0x3007:
                        return true
                case 0x4E00...0x9FFF:
                        return true
                case 0x3400...0x4DBF:
                        return true
                case 0x20000...0x2A6DF:
                        return true
                case 0x2A700...0x2B73F:
                        return true
                case 0x2B740...0x2B81F:
                        return true
                case 0x2B820...0x2CEAF:
                        return true
                case 0x2CEB0...0x2EBEF:
                        return true
                case 0x30000...0x3134F:
                        return true
                case 0x31350...0x323AF:
                        return true
                default:
                        return false
                }
        }
}

/*
U+3007: 〇
U+4E00-U+9FFF: CJK Unified Ideographs
U+3400-U+4DBF: CJK Unified Ideographs Extension A
U+20000-U+2A6DF: CJK Unified Ideographs Extension B
U+2A700-U+2B73F: CJK Unified Ideographs Extension C
U+2B740-U+2B81F: CJK Unified Ideographs Extension D
U+2B820-U+2CEAF: CJK Unified Ideographs Extension E
U+2CEB0-U+2EBEF: CJK Unified Ideographs Extension F
U+30000-U+3134F: CJK Unified Ideographs Extension G
U+31350-U+323AF: CJK Unified Ideographs Extension H
*/
