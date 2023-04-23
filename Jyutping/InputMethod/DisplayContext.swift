import Combine
import CoreIME

/// Handle Displaying Candidates and Options
final class DisplayContext: ObservableObject {

        @Published private(set) var items: [DisplayCandidate] = []
        @Published private(set) var longest: DisplayCandidate = DisplayContext.defaultLongest
        private let minIndex: Int = 0
        private var maxIndex: Int = 0
        @Published private(set) var highlightedIndex: Int = 0

        /// OptionsView highlighted index
        @Published private(set) var optionsHighlightedIndex: Int = 0


        // MARK: - Update context

        func reset() {
                items = []
                longest = DisplayContext.defaultLongest
                maxIndex = minIndex
                highlightedIndex = minIndex
                optionsHighlightedIndex = minIndex
        }

        func update(with newItems: [DisplayCandidate], highlight: Highlight) {
                guard !(newItems.isEmpty) else {
                        reset()
                        return
                }
                items = newItems
                longest = newItems.longest!
                maxIndex = newItems.count - 1
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
        }


        // MARK: - Highlighted index

        var isHighlightingStart: Bool {
                return highlightedIndex == minIndex
        }
        var isHighlightingEnd: Bool {
                return highlightedIndex == maxIndex
        }

        func increaseHighlightedIndex() {
                guard highlightedIndex < maxIndex else { return }
                highlightedIndex += 1
        }
        func decreaseHighlightedIndex() {
                guard highlightedIndex > minIndex else { return }
                highlightedIndex -= 1
        }


        // MARK: - OptionsView highlighted index

        func increaseOptionsHighlightedIndex() {
                let optionsMaxIndex: Int = 9
                guard optionsHighlightedIndex < optionsMaxIndex else { return }
                optionsHighlightedIndex += 1
        }
        func decreaseOptionsHighlightedIndex() {
                guard optionsHighlightedIndex > minIndex else { return }
                optionsHighlightedIndex -= 1
        }
        func resetOptionsHighlightedIndex() {
                optionsHighlightedIndex = minIndex
        }

        /// Default placeholder
        private static let defaultLongest: DisplayCandidate = DisplayCandidate(candidate: Candidate(text: "毋", romanization: "m4", input: "m", lexiconText: "毋"), candidateIndex: 0)
}

enum Highlight: Int {
        case start
        case unchanged
        case end
}
