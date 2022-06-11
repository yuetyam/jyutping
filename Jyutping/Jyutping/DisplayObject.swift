import Combine

final class DisplayObject: ObservableObject {

        @Published private(set) var items: [DisplayCandidate] = []
        @Published private(set) var longest: DisplayCandidate = DisplayObject.defaultLongest
        @Published private(set) var highlightedIndex: Int = 0
        @Published private(set) var animationState: Int = 0

        private static let defaultLongest: DisplayCandidate = DisplayCandidate("我", comment: "ngo5")

        func reset() {
                items = []
                longest = DisplayObject.defaultLongest
                highlightedIndex = 0
                animationState = 0
        }

        func setItems(_ newItems: [DisplayCandidate]) {
                guard !newItems.isEmpty else {
                        reset()
                        return
                }
                let newLongest: DisplayCandidate = newItems.sorted(by: { $0.isLonger(than: $1) }).first!
                let shouldUpdateLongest: Bool = newLongest.isLonger(than: longest)
                let shouldAnimate: Bool = {
                        let isUpdate: Bool = !items.isEmpty
                        guard isUpdate else { return false }
                        let isFilled: Bool = items.count == 10 && newItems.count == 10
                        guard isFilled else { return false }
                        guard shouldUpdateLongest else { return false }
                        return true
                }()

                items = newItems
                if shouldUpdateLongest {
                        longest = newLongest
                }
                highlightedIndex = 0
                if shouldAnimate {
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
}

