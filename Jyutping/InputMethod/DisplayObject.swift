import Combine
import CoreIME

final class DisplayObject: ObservableObject {

        @Published private(set) var items: [DisplayCandidate] = []
        @Published private(set) var longest: DisplayCandidate = DisplayObject.defaultLongest
        @Published private(set) var highlightedIndex: Int = 0
        @Published private(set) var animationState: Int = 0
        @Published private(set) var candidateTextAnimationConditions: [Bool] = []

        private static let defaultLongest: DisplayCandidate = DisplayCandidate(candidate: Candidate(text: "毋", romanization: "m4", input: "m", lexiconText: "毋"), candidateIndex: 0)

        func reset() {
                items = []
                longest = DisplayObject.defaultLongest
                highlightedIndex = 0
                animationState = 0
                candidateTextAnimationConditions = []
        }

        func update(with newItems: [DisplayCandidate]) {
                guard !newItems.isEmpty else {
                        reset()
                        return
                }
                let newLongest = newItems.longest!
                let pageSize: Int = AppSettings.displayCandidatePageSize
                let shouldAnimate: Bool = {
                        guard items.count == pageSize && newItems.count == pageSize else { return false }
                        guard newLongest.text.count >= longest.text.count else { return false }
                        return newLongest.candidate.romanization.count >= longest.candidate.romanization.count
                }()
                candidateTextAnimationConditions = Array(repeating: false, count: newItems.count)
                if shouldAnimate {
                        for index in 0..<newItems.count {
                                let oldTextCount = items[index].text.count
                                let newTextCount = newItems[index].text.count
                                let shouldAnimateCandidateText: Bool = !(oldTextCount == newTextCount)
                                candidateTextAnimationConditions[index] = shouldAnimateCandidateText
                        }
                }
                items = newItems
                longest = newLongest
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

