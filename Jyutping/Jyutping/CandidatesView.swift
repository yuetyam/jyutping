import SwiftUI

struct CandidatesView: View {

        @EnvironmentObject private var displayObject: DisplayObject

        var body: some View {
                if #available(macOS 12.0, *) {
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
                        .background(RoundedRectangle(cornerRadius: 8, style: .continuous)
                                .fill(.regularMaterial)
                                .shadow(radius: 5)
                        )
                } else {
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
                        .background(RoundedRectangle(cornerRadius: 8, style: .continuous)
                                .fill(Color(NSColor.textBackgroundColor))
                                .shadow(radius: 5)
                        )
                }
        }
}
