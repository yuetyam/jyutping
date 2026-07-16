import Testing
@testable import CommonExtensions

@Suite("Character extensions")
struct CharacterExtensionsTests {

        @Test("code point representations preserve every Unicode scalar")
        func codePointRepresentations() {
                let decomposed: Character = "e\u{301}"

                #expect(Character("A").codePoints == ["U+0041"])
                #expect(Character("👋").codePoints == ["U+1F44B"])
                #expect(decomposed.codePoints == ["U+0065", "U+0301"])
                #expect(decomposed.codePointsText == "U+0065 U+0301")
        }

        @Test("code point initializer accepts valid values and rejects invalid scalars")
        func codePointInitializer() {
                #expect(Character(codePoint: " U+2512B ") == "𥄫")
                #expect(Character(codePoint: "u+41") == "A")
                #expect(Character(codePoint: "41") == "A")
                #expect(Character(codePoint: "invalid") == nil)
                #expect(Character(codePoint: "U+110000") == nil)
        }

        @Test("decimal initializer and decimal code round-trip Unicode scalars")
        func decimalCode() {
                #expect(Character("𥄫").decimalCode == 151851)
                #expect(Character(decimal: 151851) == "𥄫")
                #expect(Character(decimal: 65) == "A")
                #expect(Character(decimal: -1) == nil)
        }

        @Test("ASCII character constants and predicates identify only their documented characters")
        func ASCIIConstantsAndPredicates() {
                #expect(Character.space == " ")
                #expect(Character.apostrophe == "'")
                #expect(Character.grave == "`")
                #expect(Character(" ").isSpace)
                #expect(!Character("\t").isSpace)
                #expect(Character("'").isApostrophe)
                #expect(!Character("`").isApostrophe)
                #expect(Character("`").isGrave)
                #expect(!Character("'").isGrave)
        }

        @Test("ASCII classification predicates reject non-ASCII values")
        func ASCIIClassification() {
                #expect(Character("a").isLowercaseBasicLatinLetter)
                #expect(Character("z").isLowercaseBasicLatinLetter)
                #expect(!Character("A").isLowercaseBasicLatinLetter)
                #expect(Character("A").isUppercaseBasicLatinLetter)
                #expect(Character("Z").isUppercaseBasicLatinLetter)
                #expect(!Character("a").isUppercaseBasicLatinLetter)
                #expect(Character("a").isBasicLatinLetter)
                #expect(Character("Z").isBasicLatinLetter)
                #expect(!Character("1").isBasicLatinLetter)
                #expect(Character("0").isBasicDigit)
                #expect(Character("9").isBasicDigit)
                #expect(!Character("東").isBasicDigit)
                #expect(Character("a").isAlphanumeric)
                #expect(Character("5").isAlphanumeric)
                #expect(!Character("東").isAlphanumeric)
                #expect(Character("1").isCantoneseToneDigit)
                #expect(Character("6").isCantoneseToneDigit)
                #expect(!Character("0").isCantoneseToneDigit)
                #expect(!Character("7").isCantoneseToneDigit)
        }

        @Test("ideographic code point ranges include their boundaries")
        func ideographicCodePoints() {
                let ideographicBounds: [Int] = [
                        0x3007,
                        0x4E00, 0x9FFF,
                        0x3400, 0x4DBF,
                        0x20000, 0x2A6DF,
                        0x2A700, 0x2B73F,
                        0x2B740, 0x2B81F,
                        0x2B820, 0x2CEAF,
                        0x2CEB0, 0x2EBEF,
                        0x30000, 0x3134F,
                        0x31350, 0x323AF,
                        0x2EBF0, 0x2EE5F,
                        0x323B0, 0x33479
                ]

                for codePoint in ideographicBounds {
                        #expect(codePoint.isIdeographicCodePoint)
                }
                #expect(!0x3006.isIdeographicCodePoint)
                #expect(!0x2A6E0.isIdeographicCodePoint)
                #expect(!0x0041.isIdeographicCodePoint)
        }

        @Test("supplemental CJKV code point ranges include their boundaries")
        func supplementalCodePoints() {
                let supplementalBounds: [Int] = [
                        0x2E80, 0x2E99,
                        0x2E9B, 0x2EF3,
                        0x2F00, 0x2FD5,
                        0xF900, 0xFA6D,
                        0xFA70, 0xFAD9,
                        0x2F800, 0x2FA1D
                ]

                for codePoint in supplementalBounds {
                        #expect(codePoint.isSupplementalCJKVCodePoint)
                }
                #expect(!0x2E9A.isSupplementalCJKVCodePoint)
                #expect(!0xFA6E.isSupplementalCJKVCodePoint)
                #expect(!0x0041.isSupplementalCJKVCodePoint)
        }

        @Test("character CJKV predicates delegate to their code point categories")
        func CJKVCharacterPredicates() {
                #expect(Character("東").isIdeographic)
                #expect(!Character("⺥").isIdeographic)
                #expect(Character("⺥").isSupplementalCJKVCharacter)
                #expect(!Character("東").isSupplementalCJKVCharacter)
                #expect(Character("東").isGenericCJKVCharacter)
                #expect(Character("⺥").isGenericCJKVCharacter)
                #expect(!Character("a").isGenericCJKVCharacter)
                #expect(0x4E00.isGenericCJKVCodePoint)
                #expect(0x2E80.isGenericCJKVCodePoint)
                #expect(!0x0041.isGenericCJKVCodePoint)
        }
}
