import Testing
@testable import CoreIME

@Suite("Pinyin segmenters")
struct PinyinSegmenterTests {

        init() {
                prepareTestDatabase()
        }

        @Test("Pinyin syllables compare and hash by code")
        func syllableIdentity() {
                let xi = PinyinSyllable(code: inputKeys("xi").conjoinedCode, text: "xi")
                let duplicate = PinyinSyllable(code: inputKeys("xi").conjoinedCode, text: "ignored")
                let xian = PinyinSyllable(code: inputKeys("xian").conjoinedCode, text: "xian")

                #expect(xi == duplicate)
                #expect(Set([xi, duplicate]).count == 1)
                #expect(xian < xi)
        }

        @Test("Pinyin schemes expose length complexity keys and marks")
        func schemeProperties() {
                let scheme = PinyinSegmenter.segment(inputKeys("xianshi")).first(where: { $0.mark == "xian shi" })

                #expect(scheme?.length == 7)
                #expect(scheme?.complexity == 43)
                #expect(scheme?.keys == inputKeys("xianshi"))
                #expect(scheme?.mark == "xian shi")
        }

        @Test("Pinyin segmentation distinguishes ambiguities and orders schemes")
        func segmentation() {
                let schemes = PinyinSegmenter.segment(inputKeys("xianshi"))

                #expect(schemes.contains(where: { $0.mark == "xian shi" && $0.complexity == 43 }))
                #expect(schemes.contains(where: { $0.mark == "xi an shi" && $0.complexity == 223 }))
                expectSegmentationOrder(schemes, length: \.length, count: \.count)
                #expect(PinyinSegmenter.segment([VirtualInputKey]()).isEmpty)
                #expect(PinyinSegmenter.segment([.number1]).isEmpty)
        }

        @Test("nine-key Pinyin segmentation preserves complexity variants")
        func nineKeySegmentation() {
                let combos = inputCombos([9, 4, 2, 6, 7, 4, 4])
                let schemes = PinyinNineKeySegmenter.segment(combos)

                #expect(schemes.contains(where: { $0.length == 7 && $0.complexity == 43 }))
                #expect(schemes.contains(where: { $0.length == 7 && $0.complexity == 223 }))
                #expect(schemes.first?.combos == combos)
                expectSegmentationOrder(schemes, length: \.length, count: \.count)
                #expect(PinyinNineKeySegmenter.segment([Combo]()).isEmpty)
        }

        @Test("nine-key Pinyin syllables decode and hash keypad codes")
        func nineKeySyllableIdentity() {
                let syllable = PinyinNineKeySyllable(code: 9426)
                let duplicate = PinyinNineKeySyllable(code: 9426)
                let zero = PinyinNineKeySyllable(code: 0)

                #expect(syllable.combos == inputCombos([9, 4, 2, 6]))
                #expect(syllable == duplicate)
                #expect(Set([syllable, duplicate, zero]).count == 2)
                #expect(zero.combos.isEmpty)
        }
}
