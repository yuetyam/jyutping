import Testing
@testable import CommonExtensions

@Suite("String extensions")
struct StringExtensionsTests {

        @Test("hashCode follows Kotlin and Java UTF-16 hashing")
        func hashCode() {
                #expect("hello".hashCode() == 99_162_322)
                #expect("world".hashCode() == 113_318_802)
                #expect("hello".hashCode() != "world".hashCode())
        }

        @Test("characterCount totals all string elements")
        func characterCount() {
                #expect(["hello", "world", "test"].characterCount == 14)
                #expect([String]().characterCount == 0)
        }

        @Test("string constants match their Unicode code points")
        func constants() {
                #expect(String.empty == "")
                #expect(String.lowercasedLetterX == "x")
                #expect(String.uppercasedLetterX == "X")
                #expect(String.tab == "\t")
                #expect(String.newLine == "\n")
                #expect(String.space == " ")
                #expect(String.zeroWidthSpace == "\u{200B}")
                #expect(String.fullWidthSpace == "\u{3000}")
                #expect(String.apostrophe == "'")
                #expect(String.grave == "`")
                #expect(String.comma == ",")
                #expect(String.period == ".")
                #expect(String.cantoneseComma == "，")
                #expect(String.cantonesePeriod == "。")
                #expect(String.openingParenthesis == "(")
                #expect(String.closingParenthesis == ")")
                #expect(String.numberSign == "#")
                #expect(String.hashtag == String.numberSign)
        }

        @Test("Jyutping filters select only their intended characters")
        func JyutpingFilters() {
                let input = "nei5 hou2 07 Aa!"

                #expect(input.strippedTones() == "nei hou 07 Aa!")
                #expect(input.strippedSpaces() == "nei5hou207Aa!")
                #expect(input.toneDigitOnly() == "52")
                #expect(input.latinLetterOnly() == "neihouAa")
        }

        @Test("Foundation transforms convert Chinese, Pinyin, and width forms")
        func transforms() {
                #expect("测试".toTraditional() == "測試")
                #expect("測試".toSimplified() == "测试")
                #expect("蔡徐坤".toPinyin() == "cài xú kūn")
                #expect("蔡徐坤".toPinyin(withToneDiacritics: false) == "cai xu kun")
                #expect("ABC 123".toFullWidth() == "ＡＢＣ　１２３")
                #expect("ＡＢＣ　１２３".toHalfWidth() == "ABC 123")
        }

        @Test("trimmed and spaceSeparated preserve interior text")
        func trimmingAndSpacing() {
                #expect("  hello  ".trimmed() == "hello")
                #expect("\n\thello\n\t".trimmed() == "hello")
                #expect("\u{0000}hello\u{0001}".trimmed() == "hello")
                #expect("abc".spaceSeparated() == "a b c")
                #expect("測試".spaceSeparated() == "測 試")
                #expect("".spaceSeparated() == "")
        }

        @Test("occurrenceCount counts regular expression matches and rejects invalid patterns")
        func occurrenceCount() {
                #expect("hello world, hello universe".occurrenceCount(pattern: "hello") == 2)
                #expect("test123test456".occurrenceCount(pattern: "[0-9]+") == 2)
                #expect("hello".occurrenceCount(pattern: "goodbye") == 0)
                #expect("hello".occurrenceCount(pattern: "[") == 0)
        }
}
