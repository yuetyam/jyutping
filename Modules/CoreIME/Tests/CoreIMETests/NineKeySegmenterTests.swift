import Testing
@testable import CoreIME

@Suite("Nine-key Jyutping segmenter")
struct NineKeySegmenterTests {

        init() {
                prepareTestDatabase()
        }

        @Test("nine-key syllables compare hash and classify aliases")
        func syllableSemantics() {
                let regular = NineKeySyllable(aliasCode: 646, originCode: 646, serialAliasCode: inputKeys("ngo").conjoinedCode, serialOriginCode: inputKeys("ngo").conjoinedCode)
                let duplicate = NineKeySyllable(aliasCode: 646, originCode: 646, serialAliasCode: 0, serialOriginCode: 0)
                let irregular = NineKeySyllable(aliasCode: 222, originCode: 646, serialAliasCode: inputKeys("aa").conjoinedCode, serialOriginCode: inputKeys("ngo").conjoinedCode)

                #expect(regular == duplicate)
                #expect(regular != irregular)
                #expect(Set([regular, duplicate, irregular]).count == 2)
                #expect(regular.isRegular)
                #expect(irregular.isIrregular)
                #expect(regular < irregular || irregular < regular)
        }

        @Test("nine-key syllables and schemes expose aggregate forms")
        func properties() {
                let schemes = NineKeySegmenter.segment(inputCombos([6, 4, 6]))
                let scheme = schemes.first

                #expect(scheme?.length == 3)
                #expect(scheme?.complexity == 3)
                #expect(scheme?.aliasCombos == inputCombos([6, 4, 6]))
                #expect(scheme?.originCombos == inputCombos([6, 4, 6]))
        }

        @Test("nine-key schemes are ordered by coverage then syllable count")
        func ordering() {
                let schemes = NineKeySegmenter.segment(inputCombos([6, 4, 6, 6, 4]))
                expectSegmentationOrder(schemes, length: \.length, count: \.count)
        }

        @Test("nine-key segmenter handles empty input")
        func edgeCases() {
                #expect(NineKeySegmenter.segment([Combo]()).isEmpty)
        }
}
