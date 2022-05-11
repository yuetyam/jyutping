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
}
