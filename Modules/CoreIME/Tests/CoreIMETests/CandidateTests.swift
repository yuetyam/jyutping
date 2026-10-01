import Testing
@testable import CoreIME
import CommonExtensions

@Suite("Candidates")
struct CandidateTests {

        @Test("Cantonese comments support full toneless and hidden forms")
        func CantoneseComments() {
                let lexicon = Lexicon(text: "你好", romanization: "nei5 hou2", input: "neihou")

                #expect(Candidate(lexicon: lexicon, commentForm: .full).comment == "nei5 hou2")
                #expect(Candidate(lexicon: lexicon, commentForm: .toneless).comment == "nei hou")
                #expect(Candidate(lexicon: lexicon, commentForm: .nothing).comment.isNil)
        }

        @Test("non-Cantonese candidates expose type-specific comments")
        func nonCantoneseComments() {
                let text = Candidate(lexicon: Lexicon(input: "swift", text: "Swift"))
                let emoji = Candidate(lexicon: Lexicon(symbol: "👋", cantonese: "你好", romanization: "nei5 hou2", input: "nei", isEmoji: true))
                let composed = Candidate(lexicon: Lexicon(text: "é", comment: "acute", secondaryComment: "U+00E9", input: "e"))
                let emptyComposed = Candidate(lexicon: Lexicon(text: "x", comment: nil, secondaryComment: nil, input: "x"))

                #expect(text.comment.isNil)
                #expect(emoji.comment.isNil)
                #expect(composed.comment == "acute")
                #expect(composed.secondaryComment == "U+00E9")
                #expect(emptyComposed.comment.isNil)
                #expect(emptyComposed.secondaryComment.isNil)
        }

        @Test("candidate equality follows visible comments and toneless Cantonese readings")
        func equalityAndHashing() {
                let first = Candidate(lexicon: Lexicon(text: "行", romanization: "haang4", input: "haang"), commentForm: .nothing)
                let sameReading = Candidate(lexicon: Lexicon(text: "行", romanization: "haang6", input: "haang"), commentForm: .nothing)
                let otherReading = Candidate(lexicon: Lexicon(text: "行", romanization: "hong4", input: "hong"), commentForm: .nothing)
                let text = Candidate(lexicon: Lexicon(input: "a", text: "A"))
                let sameText = Candidate(lexicon: Lexicon(input: "b", text: "A"))

                #expect(first == sameReading)
                #expect(first != otherReading)
                #expect(text == sameText)
                #expect(Set([first, sameReading, otherReading]).count == 2)
                #expect(Set([text, sameText]).count == 1)
                #expect(first.isCantonese)
                #expect(text.isNotCantonese)
                #expect(Candidate.sample.text == "例")
        }
}
