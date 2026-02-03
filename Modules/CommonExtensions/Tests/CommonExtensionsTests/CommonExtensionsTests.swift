import Testing
@testable import CommonExtensions

@Suite("CommonExtensions")
struct CommonExtensionsTests {

        // MARK: - StringExtensions

        @Test("String hashCode produces consistent results")
        func stringHashCode() {
                let string1 = "hello"
                let string2 = "hello"
                let string3 = "world"
                #expect(string1.hashCode() == string2.hashCode())
                #expect(string1.hashCode() != string3.hashCode())
        }

        @Test("Sequence characterCount")
        func characterCount() {
                let strings = ["hello", "world", "test"]
                #expect(strings.characterCount == 14)
                let emptyStrings: [String] = []
                #expect(emptyStrings.characterCount == 0)
        }

        @Test("String static constants")
        func stringStaticConstants() {
                #expect(String.empty == "")
                #expect(String.tab == "\t")
                #expect(String.newLine == "\n")
                #expect(String.space == "\u{20}")
                #expect(String.zeroWidthSpace == "\u{200B}")
                #expect(String.fullWidthSpace == "\u{3000}")
                #expect(String.apostrophe == "\u{27}")
                #expect(String.grave == "\u{60}")
                #expect(String.comma == "\u{2C}")
                #expect(String.period == "\u{2E}")
                #expect(String.cantoneseComma == "\u{FF0C}")
                #expect(String.cantonesePeriod == "\u{3002}")
                #expect(String.openingParenthesis == "\u{28}")
                #expect(String.closingParenthesis == "\u{29}")
        }

        @Test("Convert simplified to traditional Chinese")
        func convertedS2T() {
                let simplified = "测试"
                let traditional = simplified.convertedS2T()
                #expect(traditional == "測試")
        }

        @Test("Convert traditional to simplified Chinese")
        func convertedT2S() {
                let traditional = "測試"
                let simplified = traditional.convertedT2S()
                #expect(simplified == "测试")
        }

        @Test("String trimmed")
        func stringTrimmed() {
                #expect("  hello  ".trimmed() == "hello")
                #expect("\n\thello\n\t".trimmed() == "hello")
                #expect("   ".trimmed() == "")
                #expect("hello".trimmed() == "hello")
        }

        @Test("String spaceSeparated")
        func spaceSeparated() {
                #expect("abc".spaceSeparated() == "a b c")
                #expect("".spaceSeparated() == "")
                #expect("x".spaceSeparated() == "x")
                #expect("測試".spaceSeparated() == "測 試")
        }

        @Test("String occurrenceCount")
        func occurrenceCount() {
                let text = "hello world, hello universe"
                #expect(text.occurrenceCount(pattern: "hello") == 2)
                #expect(text.occurrenceCount(pattern: "world") == 1)
                #expect(text.occurrenceCount(pattern: "goodbye") == 0)
                #expect(text.occurrenceCount(pattern: "[0-9]") == 0)
                #expect("test123test456".occurrenceCount(pattern: "[0-9]+") == 2)
        }

        @Test("String textBlocks with mixed content")
        func textBlocksMixed() {
                let mixed = "你好world測試123"
                let blocks = mixed.textBlocks
                #expect(blocks.count == 4)
                #expect(blocks[0].text == "你好")
                #expect(blocks[0].isIdeographic == true)
                #expect(blocks[1].text == "world")
                #expect(blocks[1].isIdeographic == false)
                #expect(blocks[2].text == "測試")
                #expect(blocks[2].isIdeographic == true)
                #expect(blocks[3].text == "123")
                #expect(blocks[3].isIdeographic == false)
        }

        @Test("String textBlocks with only ideographic")
        func textBlocksOnlyIdeographic() {
                let text = "你好"
                let blocks = text.textBlocks
                #expect(blocks.count == 1)
                #expect(blocks[0].text == "你好")
                #expect(blocks[0].isIdeographic == true)
        }

        @Test("String textBlocks with only non-ideographic")
        func textBlocksOnlyNonIdeographic() {
                let text = "hello123"
                let blocks = text.textBlocks
                #expect(blocks.count == 1)
                #expect(blocks[0].text == "hello123")
                #expect(blocks[0].isIdeographic == false)
        }

        @Test("String textBlocks empty")
        func textBlocksEmpty() {
                let text = ""
                let blocks = text.textBlocks
                #expect(blocks.count == 0)
        }

        // MARK: - CharacterExtensions

        @Test("Character codePoints")
        func characterCodePoints() {
                let char: Character = "A"
                #expect(char.codePoints == ["U+41"])

                let emoji: Character = "👋"
                #expect(emoji.codePoints == ["U+1F44B"])

                let composed: Character = "é"
                #expect(composed.codePoints.contains("U+E9") || composed.codePoints.contains("U+65"))
        }

        @Test("Character codePointsText")
        func characterCodePointsText() {
                let char: Character = "A"
                #expect(char.codePointsText == "U+41")

                let cjkvChar: Character = "東"
                #expect(cjkvChar.codePointsText == "U+6771")
        }

        @Test("Character init from code point")
        func characterCodePointInitializer() {
                let expected: Character = "𥄫"
                let codePoint: String = "U+2512B"
                let found: Character = Character(codePoint: codePoint)!
                #expect(found == expected)

                #expect(Character(codePoint: "u+41") != nil)
                #expect(Character(codePoint: "41") == Character("A"))
                #expect(Character(codePoint: "invalid") == nil)
        }

        @Test("Character decimalCode")
        func characterDecimalCode() {
                let expected: Int = 151851
                let char: Character = "𥄫"
                let found: Int = char.decimalCode!
                #expect(found == expected)
                #expect(Character("A").decimalCode == 65)
        }

        @Test("Character init from decimal code")
        func characterDecimalInitializer() {
                let expected: Character = "𥄫"
                let decimal: Int = 151851
                let found: Character = Character(decimal: decimal)!
                #expect(found == expected)
                #expect(Character(decimal: 65) == Character("A"))
                #expect(Character(decimal: -1) == nil)
        }

        @Test("Character static properties")
        func characterStaticProperties() {
                #expect(Character.space == " ")
                #expect(Character.apostrophe == "'")
                #expect(Character.grave == "`")
        }

        @Test("Character isSpace")
        func characterIsSpace() {
                #expect(Character(" ").isSpace == true)
                #expect(Character("a").isSpace == false)
                #expect(Character("\t").isSpace == false)
        }

        @Test("Character isApostrophe")
        func characterIsApostrophe() {
                #expect(Character("'").isApostrophe == true)
                #expect(Character("`").isApostrophe == false)
                #expect(Character("\"").isApostrophe == false)
                #expect(Character("a").isApostrophe == false)
        }

        @Test("Character isGrave")
        func characterIsGrave() {
                #expect(Character("`").isGrave == true)
                #expect(Character("'").isGrave == false)
                #expect(Character("a").isGrave == false)
        }

        @Test("Character isBasicLatinLetter")
        func characterIsBasicLatinLetter() {
                #expect(Character("a").isBasicLatinLetter == true)
                #expect(Character("Z").isBasicLatinLetter == true)
                #expect(Character("m").isBasicLatinLetter == true)
                #expect(Character("1").isBasicLatinLetter == false)
                #expect(Character("東").isBasicLatinLetter == false)
                #expect(Character(" ").isBasicLatinLetter == false)
        }

        @Test("Character isLowercaseBasicLatinLetter")
        func characterIsLowercaseBasicLatinLetter() {
                #expect(Character("a").isLowercaseBasicLatinLetter == true)
                #expect(Character("z").isLowercaseBasicLatinLetter == true)
                #expect(Character("A").isLowercaseBasicLatinLetter == false)
                #expect(Character("Z").isLowercaseBasicLatinLetter == false)
                #expect(Character("1").isLowercaseBasicLatinLetter == false)
        }

        @Test("Character isUppercaseBasicLatinLetter")
        func characterIsUppercaseBasicLatinLetter() {
                #expect(Character("A").isUppercaseBasicLatinLetter == true)
                #expect(Character("Z").isUppercaseBasicLatinLetter == true)
                #expect(Character("a").isUppercaseBasicLatinLetter == false)
                #expect(Character("z").isUppercaseBasicLatinLetter == false)
                #expect(Character("1").isUppercaseBasicLatinLetter == false)
        }

        @Test("Character isBasicDigit")
        func characterIsBasicDigit() {
                #expect(Character("0").isBasicDigit == true)
                #expect(Character("5").isBasicDigit == true)
                #expect(Character("9").isBasicDigit == true)
                #expect(Character("a").isBasicDigit == false)
                #expect(Character("九").isBasicDigit == false)
        }

        @Test("Character isAlphanumeric")
        func characterIsAlphanumeric() {
                #expect(Character("a").isAlphanumeric == true)
                #expect(Character("Z").isAlphanumeric == true)
                #expect(Character("5").isAlphanumeric == true)
                #expect(Character(" ").isAlphanumeric == false)
                #expect(Character("東").isAlphanumeric == false)
                #expect(Character("!").isAlphanumeric == false)
        }

        @Test("Character isCantoneseToneDigit")
        func characterIsCantoneseToneDigit() {
                #expect(Character("1").isCantoneseToneDigit == true)
                #expect(Character("3").isCantoneseToneDigit == true)
                #expect(Character("6").isCantoneseToneDigit == true)
                #expect(Character("0").isCantoneseToneDigit == false)
                #expect(Character("7").isCantoneseToneDigit == false)
                #expect(Character("9").isCantoneseToneDigit == false)
        }

        @Test("Character isIdeographic")
        func characterIsIdeographic() {
                #expect(Character("東").isIdeographic == true)
                #expect(Character("〇").isIdeographic == true)
                #expect(Character("⺥").isIdeographic == false)
                #expect(Character("a").isIdeographic == false)
                #expect(Character("1").isIdeographic == false)
        }

        @Test("Character isSupplementalCJKVCharacter")
        func characterIsSupplementalCJKVCharacter() {
                #expect(Character("⺥").isSupplementalCJKVCharacter == true)
                #expect(Character("東").isSupplementalCJKVCharacter == false)
                #expect(Character("a").isSupplementalCJKVCharacter == false)
        }

        @Test("Character isGenericCJKVCharacter")
        func characterIsGenericCJKVCharacter() {
                #expect(Character("東").isGenericCJKVCharacter == true)
                #expect(Character("⺥").isGenericCJKVCharacter == true)
                #expect(Character("a").isGenericCJKVCharacter == false)
        }

        @Test("BinaryInteger isIdeographicCodePoint")
        func binaryIntegerIsIdeographicCodePoint() {
                #expect(0x4E00.isIdeographicCodePoint == true)
                #expect(0x9FFF.isIdeographicCodePoint == true)
                #expect(0x3007.isIdeographicCodePoint == true)
                #expect(0x0041.isIdeographicCodePoint == false)
                #expect(0x1234.isIdeographicCodePoint == false)
        }

        @Test("BinaryInteger isSupplementalCJKVCodePoint")
        func binaryIntegerIsSupplementalCJKVCodePoint() {
                #expect(0x2EA5.isSupplementalCJKVCodePoint == true)
                #expect(0xF900.isSupplementalCJKVCodePoint == true)
                #expect(0x4E00.isSupplementalCJKVCodePoint == false)
                #expect(0x0041.isSupplementalCJKVCodePoint == false)
        }

        @Test("BinaryInteger isGenericCJKVCodePoint")
        func binaryIntegerIsGenericCJKVCodePoint() {
                #expect(0x4E00.isGenericCJKVCodePoint == true)
                #expect(0x2EA5.isGenericCJKVCodePoint == true)
                #expect(0x0041.isGenericCJKVCodePoint == false)
        }

        // MARK: - ArrayExtensions

        @Test("Array fetch")
        func arrayFetch() {
                let list: [Int] = [0, 1, 2, 3]
                #expect(list.fetch(2) == 2)
                #expect(list.fetch(5) == nil)
                #expect(list.fetch(-1) == nil)
                #expect(list.fetch(0) == 0)
                #expect(list.fetch(3) == 3)
        }

        @Test("Array chunked evenly")
        func arrayChunked() {
                let array = [1, 2, 3, 4, 5, 6, 7, 8, 9]
                let chunked = array.chunked(size: 3)
                #expect(chunked.count == 3)
                #expect(chunked[0] == [1, 2, 3])
                #expect(chunked[1] == [4, 5, 6])
                #expect(chunked[2] == [7, 8, 9])
        }

        @Test("Array chunked unevenly")
        func arrayChunkedUneven() {
                let array = [1, 2, 3, 4, 5, 6, 7]
                let chunked = array.chunked(size: 3)
                #expect(chunked.count == 3)
                #expect(chunked[0] == [1, 2, 3])
                #expect(chunked[1] == [4, 5, 6])
                #expect(chunked[2] == [7])
        }

        @Test("Array chunked with size larger than array")
        func arrayChunkedLargeSize() {
                let array = [1, 2, 3]
                let chunked = array.chunked(size: 10)
                #expect(chunked.count == 1)
                #expect(chunked[0] == [1, 2, 3])
        }

        @Test("Array chunked empty")
        func arrayChunkedEmpty() {
                let array: [Int] = []
                let chunked = array.chunked(size: 3)
                #expect(chunked.count == 0)
        }

        // MARK: - CollectionExtensions

        @Test("Sequence distinct")
        func sequenceDistinct() {
                let list: [Int] = [0, 1, 3, 4, 3, 2, 1, 1]
                let expected: [Int] = [0, 1, 3, 4, 2]
                #expect(list.distinct() == expected)
        }

        @Test("Sequence distinct already unique")
        func sequenceDistinctAlreadyUnique() {
                let list: [Int] = [1, 2, 3, 4]
                #expect(list.distinct() == list)
        }

        @Test("Sequence distinct empty")
        func sequenceDistinctEmpty() {
                let list: [Int] = []
                #expect(list.distinct() == [])
        }

        @Test("Sequence flattenedCount")
        func sequenceFlattenedCount() {
                let arrays = [[1, 2, 3], [4, 5], [6, 7, 8, 9]]
                #expect(arrays.flattenedCount == 9)

                let empty: [[Int]] = []
                #expect(empty.flattenedCount == 0)

                let mixed = [[1], [], [2, 3], []]
                #expect(mixed.flattenedCount == 3)
        }

        @Test("Collection isNotEmpty")
        func collectionIsNotEmpty() {
                let nonEmpty = [1, 2, 3]
                #expect(nonEmpty.isNotEmpty == true)

                let empty: [Int] = []
                #expect(empty.isNotEmpty == false)

                #expect("hello".isNotEmpty == true)
                #expect("".isNotEmpty == false)
        }

        @Test("Sequence notContains")
        func sequenceNotContains() {
                let list = [1, 2, 3, 4, 5]
                #expect(list.notContains(6) == true)
                #expect(list.notContains(3) == false)

                let strings = ["hello", "world"]
                #expect(strings.notContains("test") == true)
                #expect(strings.notContains("hello") == false)
        }

        @Test("Comparable clamped")
        func comparableClamped() {
                #expect(5.clamped(min: 0, max: 10) == 5)
                #expect((-5).clamped(min: 0, max: 10) == 0)
                #expect(15.clamped(min: 0, max: 10) == 10)
                #expect(0.clamped(min: 0, max: 10) == 0)
                #expect(10.clamped(min: 0, max: 10) == 10)

                #expect(2.5.clamped(min: 0.0, max: 5.0) == 2.5)
                #expect(7.5.clamped(min: 0.0, max: 5.0) == 5.0)
        }

        // MARK: - NumericExtensions

        @Test("Sequence summation")
        func sequenceSummation() {
                let integers = [1, 2, 3, 4, 5]
                #expect(integers.summation == 15)

                let doubles = [1.5, 2.5, 3.0]
                #expect(abs(doubles.summation - 7.0) < 0.001)

                let empty: [Int] = []
                #expect(empty.summation == 0)

                let single = [42]
                #expect(single.summation == 42)
        }

        // MARK: - BoolExtensions

        @Test("Bool negative")
        func boolNegative() {
                #expect(false.negative == true)
                #expect(true.negative == false)
        }

        @Test("Bool then")
        func boolThen() {
                var executed = false
                true.then {
                        executed = true
                }
                #expect(executed == true)

                var notExecuted = false
                false.then {
                        notExecuted = true
                }
                #expect(notExecuted == false)
        }
}
