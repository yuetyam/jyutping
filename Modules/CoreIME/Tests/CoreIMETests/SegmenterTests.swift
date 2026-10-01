import Testing
@testable import CoreIME
import CommonExtensions

@Suite("Jyutping segmenter")
struct SegmenterTests {

        init() {
                prepareTestDatabase()
        }

        @Test("syllables expose aliases origins and ordering")
        func syllableProperties() {
                let alias = Syllable(aliasCode: inputKeys("g").conjoinedCode, originCode: inputKeys("g").conjoinedCode)
                let longer = Syllable(aliasCode: inputKeys("go").conjoinedCode, originCode: inputKeys("go").conjoinedCode)
                let duplicate = Syllable(aliasCode: inputKeys("g").conjoinedCode, originCode: inputKeys("g").conjoinedCode)

                #expect(alias == duplicate)
                #expect(alias != longer)
                #expect(Set([alias, duplicate]).count == 1)
                #expect(longer < alias)
        }

        @Test("schemes expose aggregate forms")
        func schemeProperties() {
                let scheme = Segmenter.segment(inputKeys("neihou")).first(where: { $0.syllableText == "nei hou" })

                #expect(scheme?.length == 6)
                #expect(scheme?.complexity == 33)
                #expect(scheme?.originKeys == inputKeys("neihou"))
                #expect(scheme?.aliasText == "neihou")
                #expect(scheme?.originText == "neihou")
                #expect(scheme?.aliasAnchors == inputKeys("nh"))
                #expect(scheme?.originAnchors == inputKeys("nh"))
                #expect(scheme?.aliasAnchorsText == "nh")
                #expect(scheme?.originAnchorsText == "nh")
                #expect(scheme?.mark == "nei hou")
        }

        @Test("segmenter accepts explicit long-a syllables")
        func explicitLongA() {
                #expect(Segmenter.segment(inputKeys("gaam")).contains(where: { $0.syllableText == "gaam" }))
                #expect(Segmenter.segment(inputKeys("gaang")).contains(where: { $0.syllableText == "gaang" }))
        }

        @Test("segmenter returns full prefix and ambiguous schemes")
        func fullPrefixAndAmbiguousSchemes() {
                let gong = Segmenter.segment(inputKeys("gong"))
                #expect(gong.contains(where: { $0.syllableText == "gong" }))
                #expect(gong.contains(where: { $0.syllableText == "go ng" }))
                #expect(gong.contains(where: { $0.syllableText == "go" }))

                let ngong = Segmenter.segment(inputKeys("ngong"))
                #expect(ngong.contains(where: { $0.syllableText == "ng ong" }))
                #expect(ngong.contains(where: { $0.syllableText == "ngo ng" }))
        }

        @Test("segmenter orders schemes by coverage then syllable count")
        func ordering() {
                let schemes = Segmenter.segment(inputKeys("ngong"))
                expectSegmentationOrder(schemes, length: \.length, count: \.count)
        }

        @Test("segmenter handles empty and invalid input")
        func edgeCases() {
                #expect(Segmenter.segment([VirtualInputKey]()).isEmpty)
                #expect(Segmenter.segment([.number1, .grave]).isEmpty)
                #expect(Segmenter.syllableText(of: inputKeys("gwong")) == "gwong")
                #expect(Segmenter.syllableText(of: inputKeys("zzzzzz")).isNil)
        }

        @Test("ambiguous segmentation keeps only best key coverage")
        func ambiguousSegmentation() {
                let items = Segmenter.bestSegmentedKeys(from: [
                        [.letterF, .letterG],
                        [.letterO],
                        [.letterN],
                        [.letterG, .letterH]
                ])

                #expect(items.contains(where: { item in
                        item.keys == inputKeys("gong") && item.segmentation.contains(where: { $0.syllableText == "gong" })
                }))
                #expect(items.allSatisfy({ ($0.segmentation.first?.length ?? 0) == 4 }))
                #expect(Segmenter.bestSegmentedKeys(from: []).isEmpty)
        }

        @Test("ambiguous segmentation preserves mami special handling")
        func mamiSpecialHandling() {
                let items = Segmenter.bestSegmentedKeys(from: [
                        [.letterM],
                        [.letterA],
                        [.letterM],
                        [.letterI]
                ])

                #expect(items.contains(where: { item in
                        item.keys == inputKeys("mami") && item.segmentation.contains(where: { $0.syllableText == "maa mi" })
                }))
        }

        @Test("ambiguous segmentation brute-forces inputs without syllable edges")
        func bruteForceFallback() {
                let items = Segmenter.bestSegmentedKeys(from: [
                        [.number1, .number2],
                        [.grave]
                ])

                #expect(items.count == 2)
                #expect(items.allSatisfy({ $0.segmentation.isEmpty }))
        }
}
