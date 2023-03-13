import Foundation
import CoreIME

struct DisplayCandidate: Identifiable, Hashable {

        var id: UUID {
                return UUID()
        }

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
                        let comment: String = Converter.convert(candidate.lexiconText, to: Logogram.current)
                        self.text = text
                        self.comment = comment
                        self.secondaryComment = nil
                case .symbol:
                        let comment: String = Converter.convert(candidate.lexiconText, to: Logogram.current)
                        self.text = text
                        self.comment = comment
                        self.secondaryComment = nil
                case .compose:
                        let commentText: String = candidate.lexiconText
                        let comment: String? = commentText.isEmpty ? nil : Converter.convert(commentText, to: Logogram.current)
                        let secondaryComment: String? = candidate.romanization.isEmpty ? nil : candidate.romanization
                        self.text = text
                        self.comment = comment
                        self.secondaryComment = secondaryComment
                }
        }
}

private extension DisplayCandidate {
        func isLonger(than another: DisplayCandidate) -> Bool {
                let textDifference: Int = self.text.count - another.text.count
                switch textDifference {
                case ..<0:
                        return false
                case 0:
                        let thisCommentsTextCount: Int = (self.comment?.count ?? 0) + (self.secondaryComment?.count ?? 0)
                        let anotherCommentsTextCount: Int = (another.comment?.count ?? 0) + (another.secondaryComment?.count ?? 0)
                        return thisCommentsTextCount > anotherCommentsTextCount
                default:
                        return true
                }
        }
}

extension Array where Element == DisplayCandidate {
        var longest: Element? {
                return self.sorted(by: { $0.isLonger(than: $1) }).first
        }
}
