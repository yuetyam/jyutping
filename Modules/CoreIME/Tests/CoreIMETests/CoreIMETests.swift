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
}
