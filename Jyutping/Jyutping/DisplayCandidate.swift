import Foundation

struct DisplayCandidate: Identifiable, Hashable {

        var id: UUID {
                return UUID()
        }

        let text: String
        let comment: String?
        let secondaryComment: String?
        let tertiaryComment: String?
        let quaternaryComment: String?

        init(_ text: String, comment: String? = nil, secondaryComment: String? = nil, tertiaryComment: String? = nil, quaternaryComment: String? = nil) {
                self.text = text
                self.comment = comment
                self.secondaryComment = secondaryComment
                self.tertiaryComment = tertiaryComment
                self.quaternaryComment = quaternaryComment
        }
}
