import Combine
import CoreIME

final class DisplayObject: ObservableObject {

        @Published private(set) var items: [DisplayCandidate] = []
        @Published private(set) var longest: DisplayCandidate = DisplayObject.defaultLongest
        private var maxIndex: Int = 0
        @Published private(set) var highlightedIndex: Int = 0
        @Published private(set) var animationState: Int = 0
        @Published private(set) var candidateTextAnimationConditions: [Bool] = []

        private static let defaultLongest: DisplayCandidate = DisplayCandidate(candidate: Candidate(text: "毋", romanization: "m4", input: "m", lexiconText: "毋"), candidateIndex: 0)

        func reset() {
                items = []
                longest = DisplayObject.defaultLongest
                maxIndex = 0
                highlightedIndex = 0
                animationState = 0
                candidateTextAnimationConditions = []
        }

        func update(with newItems: [DisplayCandidate], highlight: Highlight) {
                let newItemCount: Int = newItems.count
                guard newItemCount > 0 else {
                        reset()
                        return
                }
                let newLongest = newItems.longest!
                let pageSize: Int = AppSettings.displayCandidatePageSize
                let shouldAnimate: Bool = {
                        guard (newItemCount == pageSize) && (items.count == pageSize) else { return false }
                        guard newLongest.text.count >= longest.text.count else { return false }
                        return newLongest.candidate.romanization.count >= longest.candidate.romanization.count
                }()
                candidateTextAnimationConditions = Array(repeating: false, count: newItemCount)
                if shouldAnimate {
                        for index in 0..<newItemCount {
                                let oldTextCount = items[index].text.count
                                let newTextCount = newItems[index].text.count
                                let shouldAnimateCandidateText: Bool = !(oldTextCount == newTextCount)
                                candidateTextAnimationConditions[index] = shouldAnimateCandidateText
                        }
                }
                items = newItems
                longest = newLongest
                maxIndex = newItemCount - 1
                let newHighlightedIndex: Int = {
                        switch highlight {
                        case .start:
                                return 0
                        case .unchanged:
                                return min(highlightedIndex, maxIndex)
                        case .end:
                                return maxIndex
                        }
                }()
                highlightedIndex = newHighlightedIndex
                if shouldAnimate {
                        animationState += 1
                }
        }

        var isHighlightingStart: Bool {
                return highlightedIndex == 0
        }
        var isHighlightingEnd: Bool {
                return highlightedIndex == maxIndex
        }

        func increaseHighlightedIndex() {
                guard highlightedIndex < maxIndex else { return }
                highlightedIndex += 1
        }
        func decreaseHighlightedIndex() {
                guard highlightedIndex > 0 else { return }
                highlightedIndex -= 1
        }
}

enum Highlight: Int, Hashable {
        case start
        case unchanged
        case end
}
