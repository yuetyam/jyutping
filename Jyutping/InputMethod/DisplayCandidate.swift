import Foundation
import CoreIME

struct DisplayCandidate: Hashable {

        let candidate: Candidate
        let candidateIndex: Int
        let text: String
        let comment: String?
        let secondaryComment: String?

        init(candidate: Candidate, candidateIndex: Int) {
                self.candidate = candidate
                self.candidateIndex = candidateIndex
                let text: String = candidate.text
                switch candidate.type {
                case .cantonese:
                        self.text = text
                        self.comment = candidate.romanization
                        self.secondaryComment = nil
                case .specialMark:
                        self.text = text
                        self.comment = nil
                        self.secondaryComment = nil
                case .emoji:
                        let comment: String = Converter.convert(candidate.lexiconText, to: Options.characterStandard)
                        self.text = text
                        self.comment = comment
                        self.secondaryComment = nil
                case .symbol:
                        let comment: String = Converter.convert(candidate.lexiconText, to: Options.characterStandard)
                        self.text = text
                        self.comment = comment
                        self.secondaryComment = nil
                case .compose:
                        let commentText: String = candidate.lexiconText
                        let comment: String? = commentText.isEmpty ? nil : Converter.convert(commentText, to: Options.characterStandard)
                        let secondaryComment: String? = candidate.romanization.isEmpty ? nil : candidate.romanization
                        self.text = text
                        self.comment = comment
                        self.secondaryComment = secondaryComment
                }
        }
}
