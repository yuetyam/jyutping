import Combine

final class DisplayObject: ObservableObject {

        @Published private(set) var items: [DisplayCandidate] = []
        @Published private(set) var highlightedIndex: Int = 0
        @Published private(set) var animationState: Int = 0

        func reset() {
                items = []
                highlightedIndex = 0
                animationState = 0
        }

        func setItems(_ newItems: [DisplayCandidate]) {
                let shouldAnimate: Bool = {
                        guard !items.isEmpty else { return false }
                        guard let oldFirst = items.first, let newFirst = newItems.first else { return false }
                        let hasLongerText: Bool = newFirst.text.count >= oldFirst.text.count
                        if hasLongerText {
                                return true
                        } else {
                                let oldCommentLength: Int = oldFirst.comment?.count ?? 0
                                let newCommentLength: Int = newFirst.comment?.count ?? 0
                                return newCommentLength >= oldCommentLength
                        }
                }()
                items = newItems
                if newItems.isEmpty {
                        animationState = 0
                } else if shouldAnimate {
                        animationState += 1
                }
        }

        func increaseHighlightedIndex() {
                guard highlightedIndex < (items.count - 1) else { return }
                highlightedIndex += 1
        }
        func decreaseHighlightedIndex() {
                guard highlightedIndex > 0 else { return }
                highlightedIndex -= 1
        }
        func resetHighlightedIndex() {
                highlightedIndex = 0
        }
}
