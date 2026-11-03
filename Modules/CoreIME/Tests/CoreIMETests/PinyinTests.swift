import Testing
@testable import CoreIME

@Suite("Pinyin reverse lookup")
struct PinyinTests {

        init() {
                prepareTestDatabase()
        }

        @Test("separators select exact Pinyin syllable boundaries")
        func separators() async {
                let keys = inputKeys("xi'an'shi")
                let suggestions = await Engine.pinyinReverseLookup(keys, segmentation: PinyinSegmenter.segment(keys))

                #expect(suggestions.contains(where: { $0.text == "西安市" }))
                #expect(suggestions.contains(where: { $0.text == "現實" }) == false)
                #expect(suggestions.first(where: { $0.text == "西安市" })?.input == "xi'an'shi")
                #expect(suggestions.first(where: { $0.text == "西安市" })?.mark == "xi an shi")
        }

        @Test("unseparated Pinyin keeps ambiguous matches")
        func unseparated() async {
                let keys = inputKeys("xianshi")
                let suggestions = await Engine.pinyinReverseLookup(keys, segmentation: PinyinSegmenter.segment(keys))

                #expect(suggestions.contains(where: { $0.text == "現實" && $0.mark == "xian shi" }))
                #expect(suggestions.contains(where: { $0.text == "西安市" && $0.mark == "xi an shi" }))
        }

        @Test("Pinyin lookup handles anchors slices and no-match input")
        func fallbackSearches() async {
                let anchorKeys = inputKeys("nh")
                let anchorSuggestions = await Engine.pinyinReverseLookup(anchorKeys, segmentation: PinyinSegmenter.segment(anchorKeys))
                let sliceKeys = inputKeys("woz")
                let sliceSuggestions = await Engine.pinyinReverseLookup(sliceKeys, segmentation: PinyinSegmenter.segment(sliceKeys))

                #expect(anchorSuggestions.contains(where: { $0.text == "你好" }))
                #expect(sliceSuggestions.contains(where: { $0.text == "我" }))
                let unmatched = await Engine.pinyinReverseLookup([VirtualInputKey](), segmentation: [])
                #expect(unmatched.isEmpty)
        }

        @Test("nine-key Pinyin preserves complexity variants")
        func nineKey() async {
                let combos = inputCombos([9, 4, 2, 6, 7, 4, 4])
                let suggestions = await Engine.pinyinNineKeyReverseLookup(combos: combos, segmentation: PinyinNineKeySegmenter.segment(combos))

                #expect(suggestions.contains(where: { $0.text == "西安市" && $0.mark == "xi an shi" }))
                #expect(suggestions.contains(where: { $0.text == "現實" && $0.mark == "xian shi" }))
        }

        @Test("Pinyin separators cover leading trailing and partial boundaries")
        func separatorVariants() async {
                let leading = inputKeys("'xi")
                let trailing = inputKeys("xi'")
                let partial = inputKeys("x'i")
                let doubleTrailing = inputKeys("xi'an'")
                let compactTriple = inputKeys("x'i'a")

                let leadingSuggestions = await Engine.pinyinReverseLookup(leading, segmentation: PinyinSegmenter.segment(leading))
                let trailingSuggestions = await Engine.pinyinReverseLookup(trailing, segmentation: PinyinSegmenter.segment(trailing))
                #expect(leadingSuggestions.isEmpty)
                #expect(trailingSuggestions.allSatisfy({ $0.input.hasSuffix("'") }))
                _ = await Engine.pinyinReverseLookup(partial, segmentation: PinyinSegmenter.segment(partial))
                _ = await Engine.pinyinReverseLookup(doubleTrailing, segmentation: PinyinSegmenter.segment(doubleTrailing))
                _ = await Engine.pinyinReverseLookup(compactTriple, segmentation: PinyinSegmenter.segment(compactTriple))
        }
}
