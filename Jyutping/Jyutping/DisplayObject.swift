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
                        let pageSize: Int = AppSettings.displayCandidatesSize
                        let isFilled: Bool = items.count == pageSize && newItems.count == pageSize
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
                let lastIndex: Int = items.count - 1
                guard highlightedIndex < lastIndex else { return }
                highlightedIndex += 1
        }
        func decreaseHighlightedIndex() {
                let firstIndex: Int = 0
                guard highlightedIndex > firstIndex else { return }
                highlightedIndex -= 1
        }
}

