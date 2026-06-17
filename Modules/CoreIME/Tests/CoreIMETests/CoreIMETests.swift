import Testing
@testable import CommonExtensions
@testable import CoreIME

@Suite("CoreIME")
struct CoreIMETests {
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
}
