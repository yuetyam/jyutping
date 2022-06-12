import SwiftUI

struct CandidatesView: View {

        @EnvironmentObject private var displayObject: DisplayObject

        var body: some View {
                let longest: DisplayCandidate = displayObject.longest
                VStack(alignment: .leading, spacing: 1) {
                        ForEach(0..<displayObject.items.count, id: \.self) { index in
                                let candidate = displayObject.items[index]
                                let isHighlighted: Bool = index == displayObject.highlightedIndex
                                ZStack(alignment: .leading) {
                                        HStack(spacing: componentsSpacing) {
                                                Text(verbatim: "0.").font(.serial)
                                                Text(verbatim: longest.text).font(.candidate)
                                                if let comment = longest.comment {
                                                        Text(verbatim: comment).font(.comment)
                                                }
                                                if let secondaryComment = longest.secondaryComment {
                                                        Text(verbatim: secondaryComment).font(.secondaryComment)
                                                }
                                        }
                                        .opacity(0)
                                        HStack(spacing: componentsSpacing) {
                                                Text(verbatim: serialText(index)).font(.serial)
                                                Text(verbatim: candidate.text).font(.candidate)
                                                if let comment = candidate.comment {
                                                        Text(verbatim: comment).font(.comment)
                                                }
                                                if let secondaryComment = candidate.secondaryComment {
                                                        Text(verbatim: secondaryComment).font(.secondaryComment)
                                                }
                                        }
                                }
                                .padding(.horizontal, 8)
                                .padding(.vertical, 1)
                                .foregroundColor(isHighlighted ? .white : .primary)
                                .background(isHighlighted ? Color.accentColor : Color.clear, in: RoundedRectangle(cornerRadius: 4, style: .continuous))
                        }
                }
                .padding(8)
                .background(
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                                .fill(.thinMaterial)
                                .shadow(radius: 4)
                )
                .animation(.default, value: displayObject.animationState)
        }

        /// Distance between text, comment and secondaryComment
        private let componentsSpacing: CGFloat = 14

        private func serialText(_ index: Int) -> String {
                switch index {
                case 9:
                        return "0."
                default:
                        return "\(index + 1)."
                }
        }
}
