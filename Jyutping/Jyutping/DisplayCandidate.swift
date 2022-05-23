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
}
