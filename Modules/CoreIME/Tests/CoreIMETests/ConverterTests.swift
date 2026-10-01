import Testing
@testable import CoreIME
import CommonExtensions

@Suite("Character conversion")
struct ConverterTests {

        init() {
                prepareTestDatabase()
        }

        @Test("pass-through standards preserve source text")
        func passThroughStandards() {
                let source = "香港ABC"
                for standard in [CharacterStandard.preset, .custom, .etymology, .opencc] {
                        #expect(Converter.convert(source, to: standard) == source)
                }
        }

        @Test("table-backed standards convert mapped characters and preserve others")
        func tableBackedStandards() {
                #expect(Converter.convert("僞A", to: .hongkong) == "偽A")
                #expect(Converter.convert("啓A", to: .taiwan) == "啟A")
                #expect(Converter.convert("⺓A", to: .inherited) == "⼳A")
                #expect(Converter.convert("㛊A", to: .ancientBooksPublishing) == "㛆A")
        }

        @Test("PRC and simplified conversion handles empty characters phrases and mixed text")
        func PRCAndSimplified() {
                #expect(Converter.convert("", to: .prcGeneral) == "")
                #expect(Converter.convert("丟", to: .prcGeneral) == "丢")
                #expect(Converter.convert("反覆", to: .prcGeneral) == "反復")
                #expect(Converter.convert("反覆思維!", to: .prcGeneral) == "反復思維!")
                #expect(Converter.convert("", to: .mutilated) == "")
                #expect(Converter.convert("絲", to: .mutilated) == "丝")
                #expect(Converter.convert("乾杯", to: .mutilated) == "干杯")
                #expect(Converter.convert("一目瞭然!", to: .mutilated) == "一目了然!")
        }

        @Test("Cangjie root conversion covers every letter and rejects nonletters")
        func CangjieRoots() {
                let roots = "日月金木水火土竹戈十大中一弓人心手口尸廿山女田難卜重"
                #expect(VirtualInputKey.alphabetSet.sorted().compactMap(Converter.cangjie(of:)).map(String.init).joined() == roots)
                #expect(Converter.cangjie(of: .number1).isNil)
        }

        @Test("candidate transformation converts only Cantonese text")
        func candidateTransformation() {
                let cantonese = Lexicon(text: "絲", romanization: "si1", input: "si")
                let plain = Lexicon(input: "絲", text: "絲")

                #expect([cantonese, plain].transformed(commentForm: .full, charset: .mutilated).map(\.text) == ["丝", "絲"])
                let prcCantonese = Lexicon(text: "丟", romanization: "diu1", input: "diu")
                #expect([prcCantonese, plain].transformed(commentForm: .full, charset: .prcGeneral).map(\.text) == ["丢", "絲"])
                #expect([cantonese, plain].transformed(commentForm: .full, charset: .hongkong).map(\.text) == ["絲", "絲"])
        }

        @Test("dispatch prioritizes memory and places related symbols after Cantonese entries")
        func dispatch() {
                let queried = [
                        Lexicon(text: "你好", romanization: "nei5 hou2", input: "neihou", number: 2_000_001),
                        Lexicon(text: "你", romanization: "nei5", input: "nei", number: 2)
                ]
                let ideal = Lexicon(text: "您好", romanization: "nei5 hou2", input: "neihou", number: -1)
                let notIdeal = Lexicon(text: "你好呀", romanization: "nei5 hou2 aa3", input: "neihouaa", number: -2)
                let defined = Lexicon(input: "neihou", text: "Hello")
                let text = Lexicon(input: "neihou", text: "NEI HOU")
                let symbol = Lexicon(symbol: "👋", cantonese: "你", romanization: "nei5", input: "nei", isEmoji: true)
                let candidates = Converter.dispatch(memory: [ideal, notIdeal], defined: [defined], texts: [text], symbols: [symbol], queried: queried, commentForm: .full, charset: .preset)

                #expect(candidates.first?.text == "您好")
                #expect(candidates.contains(where: { $0.text == "你好" }) == false)
                #expect(candidates.firstIndex(where: { $0.text == "👋" }) == candidates.firstIndex(where: { $0.text == "你" }).map({ $0 + 1 }))
        }

        @Test("ambiguous dispatch sorts queried candidates and removes duplicates")
        func ambiguousDispatch() throws {
                let memory = Lexicon(text: "記憶", romanization: "gei3 jik1", input: "g", number: -1)
                let longer = Lexicon(text: "長詞", romanization: "coeng4 ci4", input: "long", number: 2)
                let shorter = Lexicon(text: "短", romanization: "dyun2", input: "s", number: 1)
                let symbol = Lexicon(symbol: "💭", cantonese: "記憶", romanization: "gei3 jik1", input: "g", isEmoji: true)
                let candidates = Converter.ambiguouslyDispatch(memory: [memory], defined: [], texts: [], symbols: [symbol], queried: [shorter, longer], commentForm: .nothing, charset: .preset)

                #expect(candidates.first?.text == "記憶")
                #expect(candidates.firstIndex(where: { $0.text == "💭" }) == 1)
                let longerIndex = try #require(candidates.firstIndex(where: { $0.text == "長詞" }))
                let shorterIndex = try #require(candidates.firstIndex(where: { $0.text == "短" }))
                #expect(longerIndex < shorterIndex)
        }
}
