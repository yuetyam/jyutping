import SwiftUI

struct CandidatesView: View {

        @EnvironmentObject private var displayObject: DisplayObject

        var body: some View {
                VStack(spacing: 3) {
                        ForEach(0..<displayObject.items.count, id: \.self) { index in
                                let candidate = displayObject.items[index]
                                let isHighlighted: Bool = index == displayObject.highlightedIndex
                                HStack {
                                        Text(verbatim: "\(index + 1).").font(.serialNumber)
                                        HStack(spacing: 16) {
                                                Text(verbatim: candidate.text).font(.candidate)
                                                if let comment = candidate.comment {
                                                        Text(verbatim: comment).font(.comment)
                                                }
                                                if let secondaryComment = candidate.secondaryComment {
                                                        Text(verbatim: secondaryComment).font(.secondaryComment)
                                                }
                                                if let tertiaryComment = candidate.tertiaryComment {
                                                        Text(verbatim: tertiaryComment).font(.secondaryComment)
                                                }
                                                if let quaternaryComment = candidate.quaternaryComment {
                                                        Text(verbatim: quaternaryComment).font(.secondaryComment)
                                                }
                                        }
                                        Spacer()
                                }
                                .padding(.horizontal, 4)
                                .padding(.leading, 4)
                                .foregroundColor(isHighlighted ? .white : .primary)
                                .background(isHighlighted ? Color.accentColor : Color.clear, in: RoundedRectangle(cornerRadius: 4, style: .continuous))
                        }
                        Spacer()
                }
                .padding(10)
                .background(
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                                .fill(.regularMaterial)
                                .shadow(radius: 4)
                )
                .animation(.default, value: displayObject.items)
        }
}
