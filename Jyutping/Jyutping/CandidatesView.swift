import SwiftUI

struct CandidatesView: View {

        @EnvironmentObject private var displayObject: DisplayObject

        var body: some View {
                VStack {
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
                                .foregroundColor(isHighlighted ? .blue : .primary)
                        }
                        Spacer()
                }
                .padding(.vertical, 8)
                .padding(.horizontal)
                .background(RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(.regularMaterial)
                        .shadow(radius: 5)
                )
        }
}
