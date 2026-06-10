import Foundation
import RegexBuilder

extension StringProtocol {
        /// Produces the same value as Kotlin / Java `hashCode()`
        public func hashCode() -> Int32 {
                return utf16.reduce(Int32(0)) { $0 &* 31 &+ Int32($1) }
        }
}

extension Sequence where Element: StringProtocol {
        /// The total number of characters in all string elements.
        var characterCount: Int {
                return reduce(0) { $0 + $1.count }
        }
}

extension String {

        /// Empty String. `String.init()`
        public static let empty: String = String.init()

        /// U+0078. letter x
        public static let lowercasedLetterX: String = "x"

        /// U+0058. Letter X
        public static let uppercasedLetterX: String = "X"

        /// U+0009. Horizontal tab. `\t`
        public static let tab: String = "\t"

        /// U+000A. `\n`
        public static let newLine: String = "\n"

        /// U+0020
        public static let space: String = "\u{20}"

        /// U+200B
        public static let zeroWidthSpace: String = "\u{200B}"

        /// U+3000. Ideographic Space. 全寬空格
        public static let fullWidthSpace: String = "\u{3000}"

        /// U+0027 ( ' ) Separator; Delimiter; Quote
        public static let apostrophe: String = "\u{27}"

        /// U+0060 ( ` ) Grave accent; Backtick; Backquote
        public static let grave: String = "\u{60}"

        /// U+002C. English comma mark.
        public static let comma: String = "\u{2C}"

        /// U+002E. English period (full-stop) mark.
        public static let period: String = "\u{2E}"

        /// U+FF0C. Chinese comma mark. Full-width comma mark.
        public static let cantoneseComma: String = "\u{FF0C}"

        /// U+3002. Chinese period (full-stop) mark. Full-width period mark.
        public static let cantonesePeriod: String = "\u{3002}"

        /// U+0028. Left round bracket (
        public static let openingParenthesis: String = "\u{28}"

        /// U+0029. Right round bracket )
        public static let closingParenthesis: String = "\u{29}"

        /// U+0023. ( # ) Number sign; hash; hashtag
        public static let numberSign: String = "\u{23}"

        /// U+0023. ( # ) Number sign; hash; hashtag
        public static let hashtag: String = numberSign
}

extension String {

        /// Filter out Cantonese tone digits (1-6)
        /// - Returns: A new String with Cantonese tone digits (1-6) excluded
        public func strippedTones() -> String {
                return filter(\.isCantoneseToneDigit.negative)
        }

        /// Filter out spaces
        /// - Returns: A new String with spaces excluded
        public func strippedSpaces() -> String {
                return filter(\.isSpace.negative)
        }

        /// Filter out all other elements but Cantonese tone digits (1-6)
        /// - Returns: A subsequence that only containing Cantonese tone digits (1-6)
        public func toneDigitOnly() -> String {
                return filter(\.isCantoneseToneDigit)
        }

        /// Filter out all other elements but basic latin letters (a-z and A-Z)
        /// - Returns: A subsequence that only containing basic latin letters (a-z and A-Z)
        public func latinLetterOnly() -> String {
                return filter(\.isBasicLatinLetter)
        }
}

private extension StringTransform {
        /// A constant containing the transformation of a string from simplified Chinese characters to traditional forms.
        static let simplifiedToTraditional: StringTransform = StringTransform("Simplified-Traditional")
}

extension StringProtocol {

        /// Convert simplified CJKV characters to traditional
        /// - Returns: Traditional CJKV characters
        public func toTraditional() -> String {
                return applyingTransform(.simplifiedToTraditional, reverse: false) ?? (self as? String) ?? String(self)
        }

        /// Convert traditional CJKV characters to simplified
        /// - Returns: Simplified CJKV characters
        public func toSimplified() -> String {
                return applyingTransform(.simplifiedToTraditional, reverse: true) ?? (self as? String) ?? String(self)
        }

        /// Transform CJKV characters to Mandarin Pinyin
        /// - Parameter withToneDiacritics: True for the tone-marked Pinyin form, false for the pure-ASCII Pinyin form.
        /// - Returns: Mandarin Pinyin syllables
        public func toPinyin(withToneDiacritics: Bool = true) -> String {
                if withToneDiacritics {
                        return applyingTransform(.mandarinToLatin, reverse: false) ?? (self as? String) ?? String(self)
                } else {
                        return applyingTransform(.mandarinToLatin, reverse: false)?.applyingTransform(.stripDiacritics, reverse: false) ?? (self as? String) ?? String(self)
                }
        }

        /// Convert full-width CJKV characters to half-width forms.
        /// - Returns: Full-width form characters
        public func toFullWidth() -> String {
                return applyingTransform(.fullwidthToHalfwidth, reverse: true) ?? (self as? String) ?? String(self)
        }

        /// Convert half-width CJKV characters to full-width forms.
        /// - Returns: Half-width form characters
        public func toHalfWidth() -> String {
                return applyingTransform(.fullwidthToHalfwidth, reverse: false) ?? (self as? String) ?? String(self)
        }

        /// Returns a new String made by removing `.whitespacesAndNewlines` & `.controlCharacters` from both ends of the String.
        public func trimmed() -> String {
                return trimmingCharacters(in: .whitespacesAndNewlines).trimmingCharacters(in: .controlCharacters)
        }

        /// Returns a new string by concatenating the characters, adding a space between each character.
        public func spaceSeparated() -> String {
                var result: String = String.empty
                result.reserveCapacity(count * 2)
                for character in self {
                        if result.isNotEmpty {
                                result.append(Character.space)
                        }
                        result.append(character)
                }
                return result
        }
}

extension String {
        /// Occurrence count of pattern in this String
        /// - Parameter pattern: Regular expression pattern
        /// - Returns: Number of occurrences
        public func occurrenceCount(pattern: String) -> Int {
                guard let regex = try? Regex(pattern) else { return 0 }
                return matches(of: regex).count
        }
}
