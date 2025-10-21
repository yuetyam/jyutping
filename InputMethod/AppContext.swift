import SwiftUI
import Combine
import CoreIME
import CommonExtensions

final class AppContext: ObservableObject {

        @Published private(set) var isClean: Bool = true
        @Published private(set) var displayCandidates: [DisplayCandidate] = []
        @Published private(set) var highlightedIndex: Int = 0
        @Published private(set) var optionsHighlightedIndex: Int = 0
        @Published private(set) var inputForm: InputForm = InputForm.matchInputMethodMode()
        @Published private(set) var quadrant: Quadrant = .upperRight
        @Published private(set) var mouseLocation: CGPoint = .zero

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
                mouseLocation = NSEvent.mouseLocation
                guard newDisplayCandidates.isNotEmpty else {
                        resetDisplayContext()
                        return
                }
                isClean = false
                displayCandidates = newDisplayCandidates
                maxIndex = newDisplayCandidates.count - 1
                let newHighlightedIndex: Int = switch highlight {
                case .start    : minIndex
                case .unchanged: min(highlightedIndex, maxIndex)
                case .end      : maxIndex
                }
                highlightedIndex = newHighlightedIndex
        }

        func updateInputForm(to form: InputForm) {
                if form.isOptions {
                        optionsHighlightedIndex = minIndex
                }
                inputForm = form
        }
        func updateQuadrant(to newQuadrant: Quadrant) {
                quadrant = newQuadrant
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
        func resetHighlightedIndex() {
                highlightedIndex = minIndex
        }
        func updateHighlightedIndex(to newIndex: Int) {
                guard newIndex >= minIndex && newIndex <= maxIndex else { return }
                highlightedIndex = newIndex
        }


        // MARK: - OptionsView highlighted index

        private let optionsMinIndex: Int = 0
        private let optionsMaxIndex: Int = 9
        func increaseOptionsHighlightedIndex() {
                guard optionsHighlightedIndex < optionsMaxIndex else { return }
                optionsHighlightedIndex += 1
        }
        func decreaseOptionsHighlightedIndex() {
                guard optionsHighlightedIndex > optionsMinIndex else { return }
                optionsHighlightedIndex -= 1
        }
        func resetOptionsHighlightedIndex() {
                optionsHighlightedIndex = minIndex
        }
        func updateOptionsHighlightedIndex(to newIndex: Int) {
                guard newIndex >= optionsMinIndex && newIndex <= optionsMaxIndex else { return }
                optionsHighlightedIndex = newIndex
        }
}

enum Highlight: Int {
        case start
        case unchanged
        case end
}
