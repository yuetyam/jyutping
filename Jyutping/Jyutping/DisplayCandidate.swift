import Foundation

struct DisplayCandidate: Identifiable, Hashable {

        var id: UUID {
                return UUID()
        }

        let text: String
        let comment: String?
        let secondaryComment: String?

        init(_ text: String, comment: String? = nil, secondaryComment: String? = nil) {
                self.text = text
                self.comment = comment
                self.secondaryComment = secondaryComment
        }

        func isLonger(than another: DisplayCandidate) -> Bool {
                let textDifference: Int = self.text.count - another.text.count
                switch textDifference {
                case ..<0:
                        return false
                case 0:
                        let thisCommentsTextCount: Int = (self.comment?.count ?? 0) + (self.secondaryComment?.count ?? 0)
                        let anotherCommentsTextCount: Int = (another.comment?.count ?? 0) + (another.secondaryComment?.count ?? 0)
                        return thisCommentsTextCount >= anotherCommentsTextCount
                default:
                        return true
                }
        }
}
