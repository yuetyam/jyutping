import Testing
@testable import CoreIME

@Suite("Nine-key engine")
struct NineKeyEngineTests {

        init() {
                prepareTestDatabase()
        }

        @Test("nine-key suggestions resolve full syllables")
        func fullSyllables() async {
                let combos = inputCombos([6, 4, 6])
                let suggestions = await NineKeyEngine.suggest(combos: combos, segmentation: NineKeySegmenter.segment(combos))

                #expect(suggestions.contains(where: { $0.text == "我" && $0.romanization == "ngo5" }))
        }

        @Test("nine-key suggestions handle anchors slices and empty input")
        func fallbacks() async {
                let anchors = inputCombos([6, 4])
                let anchorSuggestions = await NineKeyEngine.suggest(combos: anchors, segmentation: NineKeySegmenter.segment(anchors))
                #expect(anchorSuggestions.isNotEmpty)
                let emptySuggestions = await NineKeyEngine.suggest(combos: [Combo](), segmentation: [])
                #expect(emptySuggestions.isEmpty)
        }

        @Test("irregular nine-key syllables use their serial Jyutping spelling")
        func irregularSyllables() async {
                let syllable = NineKeySyllable(
                        aliasCode: 222,
                        originCode: 646,
                        serialAliasCode: inputKeys("aa").conjoinedCode,
                        serialOriginCode: inputKeys("ngo").conjoinedCode
                )
                let suggestions = await NineKeyEngine.suggest(combos: inputCombos([2, 2, 2]), segmentation: [[syllable]])

                #expect(suggestions.contains(where: { $0.text == "我" && $0.romanization == "ngo5" }))
        }
}
