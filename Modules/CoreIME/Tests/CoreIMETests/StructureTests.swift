import Testing
@testable import CoreIME

@Suite("Character structure lookup")
struct StructureTests {

        init() {
                prepareTestDatabase()
        }

        @Test("component romanizations return the composed character")
        func basicLookup() {
                let keys = inputKeys("mukmuk")
                let items = Engine.structureReverseLookup(keys, segmentation: Segmenter.segment(keys))

                #expect(items.contains(where: { $0.text == "林" && $0.input == "mukmuk" }))
        }

        @Test("nine-key component lookup returns the character's Jyutping and component mark")
        func nineKeyLookup() throws {
                let combos = inputCombos([6, 8, 5, 6, 8, 5])
                let items = Engine.structureNineKeyReverseLookup(combos: combos, segmentation: NineKeySegmenter.segment(combos))
                let item = try #require(items.first(where: { $0.text == "林" && $0.romanization == "lam4" }))

                #expect(item.inputCount == combos.count)
                #expect(item.mark == "muk muk")
                #expect(items.count == Set(items).count)
        }

        @Test("nine-key component lookup consumes the complete input")
        func nineKeyCompleteInput() {
                let combos = inputCombos([6, 8, 5, 6, 8, 5, 6, 8, 5])
                let items = Engine.structureNineKeyReverseLookup(combos: combos, segmentation: NineKeySegmenter.segment(combos))

                #expect(items.contains(where: { $0.text == "森" && $0.mark == "muk muk muk" && $0.inputCount == 9 }))
                #expect(items.contains(where: { $0.text == "林" }).negative)
                let extra = inputCombos([6, 8, 5, 6, 8, 5, 9])
                let extraItems = Engine.structureNineKeyReverseLookup(combos: extra, segmentation: NineKeySegmenter.segment(extra))
                #expect(extraItems.contains(where: { $0.text == "林" }).negative)
        }

        @Test("nine-key alternate component spellings resolve to canonical components")
        func nineKeyAliases() {
                let combos = inputCombos([6, 6, 3, 4, 9, 4]) // noei + zi -> neoi + zi
                let items = Engine.structureNineKeyReverseLookup(combos: combos, segmentation: NineKeySegmenter.segment(combos))

                #expect(items.contains(where: { $0.text == "好" && $0.romanization == "hou2" && $0.mark == "neoi zi" && $0.inputCount == combos.count }))
        }

        @Test("nine-key aliases retain the number of keys actually entered")
        func nineKeyAliasInputCount() {
                let syllable = NineKeySyllable(aliasCode: 22, originCode: 685, serialAliasCode: inputKeys("aa").conjoinedCode, serialOriginCode: inputKeys("muk").conjoinedCode)
                let combos = inputCombos([2, 2, 2, 2])
                let items = Engine.structureNineKeyReverseLookup(combos: combos, segmentation: [[syllable, syllable]])

                #expect(items.contains(where: { $0.text == "林" && $0.mark == "muk muk" && $0.inputCount == 4 }))
        }

        @Test("nine-key component lookup handles empty and unmatched input")
        func nineKeyUnmatched() {
                #expect(Engine.structureNineKeyReverseLookup(combos: [Combo](), segmentation: []).isEmpty)
                let combos = inputCombos([9, 9, 9])
                #expect(Engine.structureNineKeyReverseLookup(combos: combos, segmentation: NineKeySegmenter.segment(combos)).isEmpty)
                #expect(Engine.structureNineKeyReverseLookup(combos: inputCombos([6, 8, 5, 6, 8, 5]), segmentation: []).isEmpty)
        }

        @Test("tone and separator filters preserve valid component boundaries")
        func filtering() {
                let toned = inputKeys("mukqqmukqq")
                let separated = inputKeys("muk'muk")

                #expect(Engine.structureReverseLookup(toned, segmentation: Segmenter.segment(toned)).contains(where: { $0.text == "林" }))
                #expect(Engine.structureReverseLookup(separated, segmentation: Segmenter.segment(separated)).contains(where: { $0.text == "林" }))
                #expect(Engine.structureReverseLookup(inputKeys("zzzz"), segmentation: []).isEmpty)
        }

        @Test("structure lookup covers tone placement and count variants")
        func toneVariants() {
                let leadingTone = inputKeys("mukqqmuk")
                let trailingTone = inputKeys("mukmukqq")
                let separatorLeadingTone = inputKeys("mukqq'muk")
                let separatorTrailingTone = inputKeys("muk'mukqq")
                let tooManySeparatorTones = inputKeys("mukqq'mukqq")
                let tooManyTones = inputKeys("mukqqmukqqqq")

                #expect(Engine.structureReverseLookup(leadingTone, segmentation: Segmenter.segment(leadingTone)).contains(where: { $0.text == "林" }))
                #expect(Engine.structureReverseLookup(trailingTone, segmentation: Segmenter.segment(trailingTone)).contains(where: { $0.text == "林" }))
                #expect(Engine.structureReverseLookup(separatorLeadingTone, segmentation: Segmenter.segment(separatorLeadingTone)).contains(where: { $0.text == "林" }))
                #expect(Engine.structureReverseLookup(separatorTrailingTone, segmentation: Segmenter.segment(separatorTrailingTone)).contains(where: { $0.text == "林" }))
                #expect(Engine.structureReverseLookup(tooManySeparatorTones, segmentation: Segmenter.segment(tooManySeparatorTones)).isEmpty)
                #expect(Engine.structureReverseLookup(tooManyTones, segmentation: Segmenter.segment(tooManyTones)).isEmpty)
        }
}
