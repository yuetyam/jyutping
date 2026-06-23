import Testing
@testable import CommonExtensions
@testable import CoreIME

@Suite("CoreIME")
struct CoreIMETests {
        @Test("String tone conversion maps tone letters")
        func stringToneConversionMapsToneLetters() {
                #expect("gwongv".toneConverted() == "gwong1")
                #expect("gwongx".toneConverted() == "gwong2")
                #expect("gwongq".toneConverted() == "gwong3")
                #expect("gwongvv".toneConverted() == "gwong4")
                #expect("gwongxx".toneConverted() == "gwong5")
                #expect("gwongqq".toneConverted() == "gwong6")
        }

        @Test("String tone conversion consumes paired tone letters")
        func stringToneConversionConsumesPairedToneLetters() {
                #expect("vxqvvxxqq".toneConverted() == "123456")
                #expect("vvvxxxqqq".toneConverted() == "415263")
        }

        @Test("String mark formatting spaces non-letters")
        func stringMarkFormattingSpacesNonLetters() {
                #expect("gwong2".markFormatted() == "gwong2 ")
                #expect("ngo5'aa3".markFormatted() == "ngo5 ' aa3 ")
                #expect("AaZz".markFormatted() == "AaZz")
        }

        @Test("Preview mark normalization maps tone keys")
        func previewMarkNormalizationMapsToneKeys() {
                let events: [BasicInputEvent] = [
                        .init(key: .letterG, case: .lowercased),
                        .init(key: .letterW, case: .lowercased),
                        .init(key: .letterO, case: .lowercased),
                        .init(key: .letterN, case: .lowercased),
                        .init(key: .letterG, case: .lowercased),
                        .init(key: .letterV, case: .lowercased),
                        .init(key: .letterX, case: .lowercased),
                        .init(key: .letterQ, case: .lowercased),
                        .init(key: .letterV, case: .lowercased),
                        .init(key: .letterV, case: .lowercased),
                        .init(key: .letterX, case: .lowercased),
                        .init(key: .letterX, case: .lowercased),
                        .init(key: .letterQ, case: .lowercased),
                        .init(key: .letterQ, case: .lowercased)
                ]

                #expect(events.previewMarkNormalized() == "gwong1 2 3 4 5 6")
        }

        @Test("Preview mark normalization preserves letters and spaces non-letters")
        func previewMarkNormalizationPreservesLettersAndSpacesNonLetters() {
                let events: [BasicInputEvent] = [
                        .init(key: .letterN, case: .uppercased),
                        .init(key: .letterG, case: .lowercased),
                        .init(key: .number5, case: .lowercased),
                        .init(key: .apostrophe, case: .lowercased),
                        .init(key: .letterA, case: .lowercased),
                        .init(key: .letterA, case: .lowercased),
                        .init(key: .number3, case: .lowercased)
                ]

                #expect(events.previewMarkNormalized() == "Ng5 ' aa3")
                #expect([BasicInputEvent]().previewMarkNormalized().isEmpty)
        }

        @Test("Segmenter rejects cross-syllable long-a matches")
        func segmenterRejectsCrossSyllableLongA() {
                let gamSchemes = Segmenter.segment([
                        .letterG,
                        .letterA,
                        .letterM
                ])
                #expect(gamSchemes.contains(where: { $0.syllableText == "gaa m" }).negative)

                let gangSchemes = Segmenter.segment([
                        .letterG,
                        .letterA,
                        .letterN,
                        .letterG
                ])
                #expect(gangSchemes.contains(where: { $0.syllableText == "gaa ng" }).negative)
        }

        @Test("Segmenter accepts explicit long-a syllables")
        func segmenterAcceptsExplicitLongA() {
                let gaamSchemes = Segmenter.segment([
                        .letterG,
                        .letterA,
                        .letterA,
                        .letterM
                ])
                #expect(gaamSchemes.contains(where: { $0.syllableText == "gaam" }))

                let gaangSchemes = Segmenter.segment([
                        .letterG,
                        .letterA,
                        .letterA,
                        .letterN,
                        .letterG
                ])
                #expect(gaangSchemes.contains(where: { $0.syllableText == "gaang" }))
        }

        @Test("Segmenter returns full and prefix schemes")
        func segmenterReturnsFullAndPrefixSchemes() {
                let schemes = Segmenter.segment([
                        .letterG,
                        .letterO,
                        .letterN,
                        .letterG
                ])

                #expect(schemes.contains(where: { $0.syllableText == "gong" }))
                #expect(schemes.contains(where: { $0.syllableText == "go ng" }))
                #expect(schemes.contains(where: { $0.syllableText == "go" }))
        }

        @Test("Segmenter returns ambiguous full schemes")
        func segmenterReturnsAmbiguousFullSchemes() {
                let schemes = Segmenter.segment([
                        .letterN,
                        .letterG,
                        .letterO,
                        .letterN,
                        .letterG
                ])

                #expect(schemes.contains(where: { $0.syllableText == "ng ong" }))
                #expect(schemes.contains(where: { $0.syllableText == "ngo ng" }))
        }

        @Test("Segmenter finds best segmented keys from ambiguous input")
        func segmenterFindsBestSegmentedKeysFromAmbiguousInput() {
                let items = Segmenter.bestSegmentedKeys(from: [
                        [.letterF, .letterG],
                        [.letterO],
                        [.letterN],
                        [.letterG, .letterH]
                ])

                #expect(items.contains(where: { item in
                        item.keys == [.letterG, .letterO, .letterN, .letterG] && item.segmentation.contains(where: { $0.syllableText == "gong" })
                }))
                #expect(items.allSatisfy({ ($0.segmentation.first?.length ?? 0) == 4 }))
        }

        @Test("Segmenter preserves special ambiguous mami segmentation")
        func segmenterPreservesSpecialAmbiguousMamiSegmentation() {
                let items = Segmenter.bestSegmentedKeys(from: [
                        [.letterM],
                        [.letterA],
                        [.letterM],
                        [.letterI]
                ])

                #expect(items.contains(where: { item in
                        item.keys == [.letterM, .letterA, .letterM, .letterI] && item.segmentation.contains(where: { $0.syllableText == "maa mi" })
                }))
        }

        @Test("Segmenter best segmented keys matches brute force")
        func segmenterBestSegmentedKeysMatchesBruteForce() {
                let keySets: [Set<VirtualInputKey>] = [
                        [.letterF, .letterG],
                        [.number1, .letterO],
                        [.letterO],
                        [.letterN],
                        [.letterG, .letterH]
                ]
                let optimized = Segmenter.bestSegmentedKeys(from: keySets)
                let bruteForced = bruteForceBestSegmentedKeys(from: keySets)

                #expect(normalized(optimized) == normalized(bruteForced))
        }

        private func bruteForceBestSegmentedKeys(from keySets: [Set<VirtualInputKey>]) -> [(keys: [VirtualInputKey], segmentation: Segmentation)] {
                guard keySets.isNotEmpty else { return [] }
                var bestLength: Int = 0
                var items: [(keys: [VirtualInputKey], segmentation: Segmentation)] = []
                var keys: [VirtualInputKey] = []
                keys.reserveCapacity(keySets.count)
                func appendKeys(at index: Int) {
                        guard index < keySets.count else {
                                let segmentation = Segmenter.segment(keys)
                                let length = segmentation.first?.length ?? 0
                                guard length >= bestLength else { return }
                                if length > bestLength {
                                        bestLength = length
                                        items.removeAll(keepingCapacity: true)
                                }
                                items.append((keys, segmentation))
                                return
                        }
                        for key in keySets[index] {
                                keys.append(key)
                                appendKeys(at: index + 1)
                                keys.removeLast()
                        }
                }
                appendKeys(at: 0)
                return items
        }

        private func normalized(_ items: [(keys: [VirtualInputKey], segmentation: Segmentation)]) -> Set<String> {
                return Set(items.map({ item in
                        let keyText = item.keys.map(\.text).joined()
                        let segmentationText = item.segmentation.map(\.syllableText).joined(separator: "|")
                        return keyText + ":" + segmentationText
                }))
        }
}
