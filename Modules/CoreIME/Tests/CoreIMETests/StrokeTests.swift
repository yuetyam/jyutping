import Testing
@testable import CoreIME
import CommonExtensions

@Suite("Stroke input")
struct StrokeTests {

        init() {
                prepareTestDatabase()
        }

        @Test("stroke keys expose codes display text and virtual keys")
        func properties() {
                let strokes: [StrokeVirtualKey] = [.horizontal, .vertical, .leftFalling, .rightFalling, .turning, .wildcard]

                #expect(strokes.map(\.code) == Array(1...6))
                #expect(strokes.map(\.strokeText) == ["⼀", "⼁", "⼃", "⼂", "乛", "＊"])
                #expect(strokes.map(\.virtualInputKey) == inputKeys("123456"))
                #expect(strokes.map(\.digitText) == ["1", "2", "3", "4", "5", "6"])
                #expect(StrokeVirtualKey.wildcard.isWildcard)
                #expect(StrokeVirtualKey.horizontal.isWildcard == false)
        }

        @Test("stroke mappings support standard alternate and numeric layouts")
        func mappings() {
                #expect(StrokeVirtualKey.displayText(from: inputKeys("wsadzx")) == "⼀⼁⼃⼂乛＊")
                #expect(StrokeVirtualKey.displayText(from: inputKeys("jkl uio")) == "⼀⼁⼃⼂乛＊")
                #expect(StrokeVirtualKey.displayText(from: inputKeys("123456")) == "⼀⼁⼃⼂乛＊")
                #expect(inputKeys("wht").allSatisfy({ $0.strokeKey == .horizontal }))
                #expect(VirtualInputKey.letterP.strokeKey == .leftFalling)
                #expect(VirtualInputKey.letterN.strokeKey == .rightFalling)
                #expect(VirtualInputKey.letterW.displayStrokeKeyText == "⼀")
                #expect(VirtualInputKey.letterH.displayStrokeKeyText.isNil)
                #expect(StrokeVirtualKey.isValidStrokes(inputKeys("wsadzx")))
                #expect(StrokeVirtualKey.isValidStrokes(inputKeys("wg")) == false)
        }

        @Test("shape lexicons compare by identity complexity and rank")
        func shapeLexicons() {
                let first = ShapeLexicon(text: "木", input: "1", complex: 1, number: 2)
                let duplicate = ShapeLexicon(text: "木", input: "1234", complex: 4, number: 1)
                let later = ShapeLexicon(text: "林", input: "12", complex: 2, number: 3)
                let preferred = ShapeLexicon(text: "森", input: "12", complex: 2, number: 2)

                #expect(first == duplicate)
                #expect(Set([first, duplicate]).count == 1)
                #expect(first < later)
                #expect(preferred < later)
        }

        @Test("stroke lookup supports exact prefix wildcard and invalid inputs")
        func reverseLookup() {
                let exact = Engine.strokeReverseLookup(inputKeys("wsad"))
                let prefix = Engine.strokeReverseLookup(inputKeys("w"))
                let wildcard = Engine.strokeReverseLookup(inputKeys("wxad"))

                #expect(exact.contains(where: { $0.text == "木" && $0.input == "1234" }))
                #expect(prefix.isNotEmpty)
                #expect(wildcard.isNotEmpty)
                let invalid = Engine.strokeReverseLookup(inputKeys("g"))
                #expect(invalid.isNotEmpty)
                #expect(invalid.allSatisfy({ $0.input.isEmpty }))
        }
}
