import Combine
import CoreIME

final class AppContext: ObservableObject {

        @Published private(set) var isClean: Bool = true
        @Published private(set) var displayCandidates: [DisplayCandidate] = []
        @Published private(set) var highlightedIndex: Int = 0
        @Published private(set) var optionsHighlightedIndex: Int = 0
        @Published private(set) var inputForm: InputForm = InputForm.matchInputMethodMode()
        @Published private(set) var windowPattern: WindowPattern = .regular

        private let minIndex: Int = 0
        private var maxIndex: Int = 0


        // MARK: - Update context

        func resetDisplayContext() {
                isClean = true
                displayCandidates = []
                highlightedIndex = minIndex
                optionsHighlightedIndex = minIndex
                maxIndex = minIndex
        }

        func update(with newDisplayCandidates: [DisplayCandidate], highlight: Highlight) {
                guard newDisplayCandidates.isNotEmpty else {
                        resetDisplayContext()
                        return
                }
                isClean = false
                displayCandidates = newDisplayCandidates
                maxIndex = newDisplayCandidates.count - 1
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

        func updateInputForm(to form: InputForm? = nil) {
                let newForm: InputForm = form ?? InputForm.matchInputMethodMode()
                if newForm.isOptions {
                        optionsHighlightedIndex = minIndex
                }
                inputForm = newForm
        }
        func updateWindowPattern(to pattern: WindowPattern) {
                windowPattern = pattern
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
}

enum Highlight: Int {
        case start
        case unchanged
        case end
}
