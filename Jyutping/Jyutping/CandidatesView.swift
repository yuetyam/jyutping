import SwiftUI

struct CandidatesView: View {

        @EnvironmentObject private var displayObject: DisplayObject

        var body: some View {
                let longest: DisplayCandidate = displayObject.longest
                VStack(spacing: 3) {
                        ForEach(0..<displayObject.items.count, id: \.self) { index in
                                let candidate = displayObject.items[index]
                                let isHighlighted: Bool = index == displayObject.highlightedIndex
                                ZStack {
                                        HStack(spacing: 14) {
                                                Text(verbatim: "0.").font(.serial)
                                                Text(verbatim: longest.text).font(.candidate)
                                                if let comment = longest.comment {
                                                        Text(verbatim: comment).font(.comment)
                                                }
                                                if let secondaryComment = longest.secondaryComment {
                                                        Text(verbatim: secondaryComment).font(.secondaryComment)
                                                }
                                                Spacer()
                                        }
                                        .opacity(0)
                                        HStack(spacing: 14) {
                                                Text(verbatim: serialText(index)).font(.serial)
                                                Text(verbatim: candidate.text).font(.candidate)
                                                if let comment = candidate.comment {
                                                        Text(verbatim: comment).font(.comment)
                                                }
                                                if let secondaryComment = candidate.secondaryComment {
                                                        Text(verbatim: secondaryComment).font(.secondaryComment)
                                                }
                                                Spacer()
                                        }
                                }
                                .padding(.leading, 8)
                                .foregroundColor(isHighlighted ? .white : .primary)
                                .background(isHighlighted ? Color.accentColor : Color.clear, in: RoundedRectangle(cornerRadius: 4, style: .continuous))
                        }
                        Spacer()
                }
                .padding(.horizontal, 8)
                .padding(.top, 8)
                .background(
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                                .fill(.thinMaterial)
                                .shadow(radius: 4)
                )
                .animation(.default, value: displayObject.animationState)
        }

        private func serialText(_ index: Int) -> String {
                switch index {
                case 9:
                        return "0."
                default:
                        return "\(index + 1)."
                }
        }
}
