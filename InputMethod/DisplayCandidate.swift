import Foundation
import CoreIME

struct DisplayCandidate: Hashable {

        let candidate: Candidate
        let candidateIndex: Int
        let text: String
        let comment: String?
        let secondaryComment: String?

        init(candidate: Candidate, candidateIndex: Int, characterStandard: CharacterStandard) {
                self.candidate = candidate
                self.candidateIndex = candidateIndex
                switch candidate.type {
                case .cantonese:
                        self.text = candidate.text
                        self.comment = candidate.romanization
                        self.secondaryComment = nil
                case .text:
                        self.text = candidate.text
                        self.comment = nil
                        self.secondaryComment = nil
                case .emoji:
                        let comment: String = Converter.convert(candidate.lexiconText, to: characterStandard)
                        self.text = candidate.text
                        self.comment = "(" + comment + ")"
                        self.secondaryComment = nil
                case .symbol:
                        let comment: String = Converter.convert(candidate.lexiconText, to: characterStandard)
                        self.text = candidate.text
                        self.comment = "(" + comment + ")"
                        self.secondaryComment = nil
                case .compose:
                        let cantoneseComment: String = candidate.lexiconText
                        let unicodeComment: String = candidate.romanization
                        let comment: String? = cantoneseComment.isEmpty ? nil : Converter.convert(cantoneseComment, to: characterStandard)
                        let secondaryComment: String? = unicodeComment.isEmpty ? nil : unicodeComment
                        self.text = candidate.text
                        self.comment = comment
                        self.secondaryComment = secondaryComment
                }
        }
}
