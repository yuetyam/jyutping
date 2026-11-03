import Testing
@testable import CoreIME

@Suite("Input events")
struct InputEventTests {

        @Test("basic input events preserve keys and keyboard cases")
        func basicInputEvents() {
                let lowercased = BasicInputEvent(key: .letterA, case: .lowercased)
                let uppercased = BasicInputEvent(key: .letterB, isCapitalized: true)
                let inferredLowercase = BasicInputEvent(key: .letterC, isCapitalized: false)

                #expect(lowercased.key == .letterA)
                #expect(lowercased.case == .lowercased)
                #expect(lowercased.isCapitalized == false)
                #expect(uppercased.case == .uppercased)
                #expect(uppercased.isCapitalized)
                #expect(inferredLowercase.case == .lowercased)
        }

        @Test("preview marks normalize tone keys and pairs")
        func previewToneKeys() {
                #expect(inputEvents("gwongvxqvvxxqq").normalizedPreviewMark() == "gwong1 2 3 4 5 6")
                #expect(inputEvents("vvvxxxqqq").normalizedPreviewMark() == "4 1 5 2 6 3")
        }

        @Test("preview marks preserve capitalization and space nonletters")
        func previewCapitalizationAndSpacing() {
                let events: [BasicInputEvent] = [
                        .init(key: .letterN, case: .uppercased),
                        .init(key: .letterG, case: .lowercased),
                        .init(key: .number5, case: .lowercased),
                        .init(key: .apostrophe, case: .lowercased),
                        .init(key: .letterA, case: .lowercased),
                        .init(key: .letterA, case: .lowercased),
                        .init(key: .number3, case: .lowercased)
                ]

                #expect(events.normalizedPreviewMark() == "Ng5 ' aa3")
                #expect([BasicInputEvent]().normalizedPreviewMark().isEmpty)
        }
}
