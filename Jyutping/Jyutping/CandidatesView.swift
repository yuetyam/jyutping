import SwiftUI

struct CandidatesView: View {

        @EnvironmentObject private var displayObject: DisplayObject

        var body: some View {
                VStack {
                        ForEach((0..<displayObject.items.count), id: \.self) { index in
                                let candidate = displayObject.items[index]
                                let isHighlighted: Bool = index == displayObject.highlightedIndex
                                HStack {
                                        Text(verbatim: "\(index + 1).").font(.serialNumber)
                                        HStack(spacing: 16) {
                                                Text(verbatim: candidate.text).font(.candidate)
                                                if let comment: String = candidate.comment {
                                                        Text(verbatim: comment).font(.comment)
                                                }
                                                if let secondaryComment: String = candidate.secondaryComment {
                                                        Text(verbatim: secondaryComment).font(.secondaryComment)
                                                }
                                        }
                                        Spacer()
                                }
                                .foregroundColor(isHighlighted ? .blue : .primary)
                        }
                        Spacer()
                }
                .padding(.vertical, 8)
                .padding(.horizontal)
                .background(.ultraThickMaterial, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
        }
}


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
