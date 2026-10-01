import Testing
@testable import CoreIME
import CommonExtensions

@Suite("Lexicons")
struct LexiconTests {

        @Test("initializer preserves values and derives display metadata")
        func initialization() {
                let lexicon = Lexicon(type: .cantonese, text: "你好", romanization: "nei5 hou2", input: "neihou", mark: "nei hou", number: 42, attached: "greeting")

                #expect(lexicon.type == .cantonese)
                #expect(lexicon.text == "你好")
                #expect(lexicon.romanization == "nei5 hou2")
                #expect(lexicon.input == "neihou")
                #expect(lexicon.inputCount == 6)
                #expect(lexicon.mark == "nei hou")
                #expect(lexicon.number == 42)
                #expect(lexicon.attached == "greeting")
                #expect(Lexicon(text: "我", romanization: "ngo5", input: "ngo").mark == "ngo")
        }

        @Test("equality and hashing follow lexicon type semantics")
        func equalityAndHashing() {
                let cantonese = Lexicon(text: "行", romanization: "haang4", input: "haang")
                let sameCantonese = Lexicon(text: "行", romanization: "haang4", input: "h")
                let otherReading = Lexicon(text: "行", romanization: "hong4", input: "hong")
                let text = Lexicon(input: "swift", text: "Swift")
                let sameText = Lexicon(type: .text, text: "Swift", romanization: "ignored", input: "s")

                #expect(cantonese == sameCantonese)
                #expect(cantonese != otherReading)
                #expect(cantonese != Lexicon(type: .text, text: "行", romanization: "haang4", input: "haang"))
                #expect(text == sameText)
                #expect(Set([cantonese, sameCantonese, otherReading]).count == 2)
                #expect(Set([text, sameText]).count == 1)
        }

        @Test("comparison prefers longer input then lower rank")
        func comparison() {
                let long = Lexicon(text: "長", romanization: "coeng4", input: "coeng", number: 100)
                let short = Lexicon(text: "短", romanization: "dyun2", input: "d", number: 1)
                let preferred = Lexicon(text: "甲", romanization: "gaap3", input: "abc", number: 1)
                let later = Lexicon(text: "乙", romanization: "jyut6", input: "abc", number: 2)

                #expect(long < short)
                #expect(preferred < later)
        }

        @Test("concatenation joins Cantonese values only")
        func concatenation() throws {
                let first = Lexicon(text: "你", romanization: "nei5", input: "nei", mark: "nei", number: 1)
                let second = Lexicon(text: "好", romanization: "hou2", input: "hou", mark: "hou", number: 2)
                let result: Lexicon? = first + second
                let combined = try #require(result)

                #expect(combined.text == "你好")
                #expect(combined.romanization == "nei5 hou2")
                #expect(combined.input == "neihou")
                #expect(combined.mark == "nei hou")
                #expect(combined.number == 2_000_003)
                #expect((first + Lexicon(input: "text", text: "Text")).isNil)
        }

        @Test("collection joining preserves order and rejects non-Cantonese entries")
        func joining() throws {
                let entries = [
                        Lexicon(text: "香", romanization: "hoeng1", input: "hoeng", number: 1),
                        Lexicon(text: "港", romanization: "gong2", input: "gong", number: 2)
                ]
                let joined = try #require(entries.joined())

                #expect(joined.text == "香港")
                #expect(joined.romanization == "hoeng1 gong2")
                #expect(joined.number == 2_000_003)
                #expect([Lexicon]().joined()?.text == "")
                #expect((entries + [Lexicon(input: "app", text: "App")]).joined().isNil)
        }

        @Test("type and memory predicates classify lexicons")
        func predicates() {
                let emoji = Lexicon(symbol: "👋", cantonese: "你好", romanization: "nei5 hou2", input: "neihou", isEmoji: true)
                let symbol = Lexicon(symbol: "✓", cantonese: "剔", romanization: "tik1", input: "tik", isEmoji: false)
                let composed = Lexicon(text: "é", comment: "acute", secondaryComment: "U+00E9", input: "e")

                #expect(emoji.isEmojiOrSymbol)
                #expect(symbol.isEmojiOrSymbol)
                #expect(composed.isComposed)
                #expect(composed.attached == "acute")
                #expect(composed.romanization == "U+00E9")
                #expect(Lexicon(text: "詞", romanization: "ci4", input: "ci", number: 1_000_001).isCompound)
                #expect(Lexicon(text: "詞", romanization: "ci4", input: "ci", number: -1).isIdealInputMemory)
                #expect(Lexicon(text: "詞", romanization: "ci4", input: "ci", number: -2).isNotIdealInputMemory)
                #expect(Lexicon(text: "詞", romanization: "ci4", input: "ci", number: -3).isInputMemory)
                #expect(Lexicon.sample.text == "例")
        }

        @Test("replacing input preserves all other metadata")
        func replacingInput() {
                let origin = Lexicon(type: .symbol, text: "✓", romanization: "tik1", input: "old", mark: "mark", number: 7, attached: "剔")
                let replaced = origin.replacedInput(with: "new")

                #expect(replaced.input == "new")
                #expect(replaced.mark == "mark")
                #expect(replaced.type == origin.type)
                #expect(replaced.text == origin.text)
                #expect(replaced.romanization == origin.romanization)
                #expect(replaced.number == origin.number)
                #expect(replaced.attached == origin.attached)
        }
}
