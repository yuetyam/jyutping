import Testing
@testable import CoreIME

@Suite("Nine-key combos")
struct ComboTests {

        @Test("combos expose keypad digits labels and compatible letters")
        func properties() {
                let expectedTexts = ["ABC", "DEF", "GHI", "JKL", "MNO", "PQRS", "TUV", "WXYZ"]
                #expect(Combo.allCases.map(\.text) == expectedTexts)
                #expect(Combo.allCases.map(\.digit) == Array(2...9))
                #expect(Combo.ABC.letters == ["a", "b", "c"])
                #expect(Combo.PQRS.letters == ["p", "s"])
                #expect(Combo.WXYZ.letters == ["w", "y", "z"])
        }

        @Test("combo collections combine decimal keypad codes")
        func combinedCode() {
                #expect([Combo.MNO, .GHI, .MNO].decimalCombinedCode == 646)
                #expect([Combo]().decimalCombinedCode == 0)
        }
}
