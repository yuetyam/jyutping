import Testing
@testable import CoreIME
import CommonExtensions

@Suite("Emoji and symbols")
struct EmojiTests {

        init() {
                prepareTestDatabase()
        }

        @Test("categories and emoji identities use stable identifiers")
        func identity() {
                #expect(Emoji.Category.allCases.map(\.id) == Array(0...8))
                let first = Emoji(category: .frequent, uniqueNumber: 1, unicodeVersion: 15, text: "👋", cantonese: "你好", romanization: "nei5 hou2")
                let duplicate = Emoji(category: .frequent, uniqueNumber: 2, unicodeVersion: 16, text: "👋", cantonese: "other", romanization: "other")
                let otherCategory = Emoji(category: .smileysAndPeople, uniqueNumber: 1, unicodeVersion: 15, text: "👋", cantonese: "你好", romanization: "nei5 hou2")

                #expect(first.id == 1)
                #expect(first == duplicate)
                #expect(first != otherCategory)
                #expect(Set([first, duplicate, otherCategory]).count == 2)
        }

        @Test("frequent emoji generation uses the synthetic metadata contract")
        func frequentGeneration() {
                let emoji = Emoji.generateFrequentEmoji(with: "👋", uniqueNumber: 42)

                #expect(emoji.category == .frequent)
                #expect(emoji.id == 42)
                #expect(emoji.unicodeVersion == 110000)
                #expect(emoji.cantonese.isEmpty)
                #expect(emoji.romanization.isEmpty)
        }

        @Test("symbol generation handles scalar sequences and invalid values")
        func symbolGeneration() {
                #expect(Emoji.generateSymbol(from: "1F600") == "😀")
                #expect(Emoji.generateSymbol(from: "270C.FE0F") == "✌️")
                #expect(Emoji.generateSymbol(from: "1F468.200D.1F9B0") == "👨‍🦰")
                #expect(Emoji.generateSymbol(from: "").isNil)
                #expect(Emoji.generateSymbol(from: "NOTHEX").isNil)
                #expect(Emoji.generateSymbol(from: "110000").isNil)
                #expect(Emoji.generateSymbol(from: "1F600.INVALID") == "😀")
        }

        @Test("database fetches return categorized and default emoji sequences")
        func databaseFetches() {
                let emojis = Engine.fetchEmojiSequence()
                let smileys = Engine.fetchEmojiSequence(category: .smileysAndPeople)
                let defaults = Engine.fetchDefaultFrequentEmojis()

                #expect(emojis.isNotEmpty)
                #expect(emojis.allSatisfy({ $0.category != .frequent }))
                #expect(smileys.isNotEmpty)
                #expect(defaults.isNotEmpty)
                #expect(defaults.allSatisfy({ $0.category == .frequent }))
                #expect(defaults.contains(where: { $0.text == "👋" && $0.cantonese == "你好" }))
        }

        @Test("Jyutping and nine-key symbol searches return typed lexicons")
        func symbolSearches() {
                let keys = inputKeys("hou")
                let symbols = Engine.searchSymbols(for: keys, segmentation: Segmenter.segment(keys))
                let combos = inputCombos([4, 6, 8])
                let nineKeySymbols = Engine.nineKeySearchSymbols(combos: combos, segmentation: NineKeySegmenter.segment(combos))

                #expect(symbols.contains(where: { $0.text == "👌" && $0.attached == "好" }))
                #expect(symbols.allSatisfy({ $0.isEmojiOrSymbol }))
                #expect(nineKeySymbols.contains(where: { $0.attached == "好" }))
                #expect(nineKeySymbols.allSatisfy({ $0.isEmojiOrSymbol }))
                #expect(Engine.searchSymbols(for: inputKeys("zzzz"), segmentation: []).isEmpty)
                #expect(Engine.nineKeySearchSymbols(combos: [.special], segmentation: []).isEmpty)
        }
}
