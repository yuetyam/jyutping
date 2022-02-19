import Combine

final class DisplayObject: ObservableObject {

        @Published private(set) var items: [DisplayCandidate] = []
        @Published private(set) var highlightedIndex: Int = 0

        func reset() {
                items = []
                highlightedIndex = 0
        }

        func setItems(_ newItems: [DisplayCandidate]) {
                items = newItems
        }
        func clearItems() {
                items = []
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
