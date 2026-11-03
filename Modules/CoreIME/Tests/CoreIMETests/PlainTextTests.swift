import Testing
@testable import CoreIME

@Suite("Text marks")
struct PlainTextTests {

        init() {
                prepareTestDatabase()
        }

        @Test("letter searches return all marks for the exact input")
        func letterSearch() {
                let marks = Engine.searchPlainTexts(for: inputKeys("abc"))

                #expect(marks.map(\.text) == ["ABC", "🔤"])
                #expect(marks.allSatisfy({ $0.type == .text && $0.input == "abc" }))
                #expect(Engine.searchPlainTexts(for: inputKeys("zzzzzz")).isEmpty)
        }

        @Test("nine-key searches preserve the source input for colliding marks")
        func nineKeySearch() {
                let marks = Engine.queryPlainTexts(for: inputCombos([2, 2, 2]))

                #expect(marks.contains(where: { $0.text == "ABC" && $0.input == "abc" }))
        }
}
