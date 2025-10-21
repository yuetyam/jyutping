import Foundation

extension StringProtocol {
        /// Produces the same value as Kotlin's hashCode()
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
}

extension StringTransform {
        /// A constant containing the transformation of a string from simplified Chinese characters to traditional forms.
        public static let simplifiedToTraditional: StringTransform = StringTransform("Simplified-Traditional")
}

extension StringProtocol {

        /// Convert simplified CJKV characters to traditional
        /// - Returns: Traditional CJKV characters
        public func convertedS2T() -> String {
                return applyingTransform(.simplifiedToTraditional, reverse: false) ?? (self as? String) ?? String(self)
        }

        /// Convert traditional CJKV characters to simplified
        /// - Returns: Simplified CJKV characters
        public func convertedT2S() -> String {
                return applyingTransform(.simplifiedToTraditional, reverse: true) ?? (self as? String) ?? String(self)
        }

        /// Returns a new String made by removing `.whitespacesAndNewlines` & `.controlCharacters` from both ends of the String.
        public func trimmed() -> String {
                return trimmingCharacters(in: .whitespacesAndNewlines).trimmingCharacters(in: .controlCharacters)
        }
}

extension Sequence where Element == Character {

        /// Returns a new string by concatenating the elements of the sequence, adding a space between each element.
        public func spaceSeparated() -> String {
                return reduce(into: String.empty) { partialResult, character in
                        if partialResult.isNotEmpty {
                                partialResult.append(String.space)
                        }
                        partialResult.append(character)
                }
        }
}

extension String {

        /// CJKV && !CJKV
        public var textBlocks: [TextUnit] {
                var blocks: [TextUnit] = []
                var ideographicCache: String = String.empty
                var otherCache: String = String.empty
                var wasLastIdeographic: Bool = true
                for character in self {
                        if character.isIdeographic {
                                if wasLastIdeographic.negative && otherCache.isNotEmpty {
                                        let newElement: TextUnit = TextUnit(text: otherCache, isIdeographic: false)
                                        blocks.append(newElement)
                                        otherCache = String.empty
                                }
                                ideographicCache.append(character)
                                wasLastIdeographic = true
                        } else {
                                if wasLastIdeographic && ideographicCache.isNotEmpty {
                                        let newElement: TextUnit = TextUnit(text: ideographicCache, isIdeographic: true)
                                        blocks.append(newElement)
                                        ideographicCache = String.empty
                                }
                                otherCache.append(character)
                                wasLastIdeographic = false
                        }
                }
                if ideographicCache.isNotEmpty {
                        let tailElement: TextUnit = TextUnit(text: ideographicCache, isIdeographic: true)
                        blocks.append(tailElement)
                } else if otherCache.isNotEmpty {
                        let tailElement: TextUnit = TextUnit(text: otherCache, isIdeographic: false)
                        blocks.append(tailElement)
                }
                return blocks
        }
}

public struct TextUnit {
        public let text: String
        public let isIdeographic: Bool
}
