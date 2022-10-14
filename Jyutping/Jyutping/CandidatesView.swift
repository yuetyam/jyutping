import SwiftUI

struct CandidatesView: View {

        @EnvironmentObject private var displayObject: DisplayObject

        private let toneStyle: ToneDisplayStyle = AppSettings.toneDisplayStyle
        private let lineSpacing: CGFloat = CGFloat(AppSettings.candidateLineSpacing) / 2.0

        var body: some View {
                let longest: DisplayCandidate = displayObject.longest
                VStack(alignment: .leading, spacing: 0) {
                        ForEach(0..<displayObject.items.count, id: \.self) { index in
                                let candidate = displayObject.items[index]
                                let isHighlighted: Bool = index == displayObject.highlightedIndex
                                ZStack(alignment: .leading) {
                                        HStack(spacing: 14) {
                                                SerialNumberLabel(7)
                                                Text(verbatim: longest.text).font(.candidate)
                                                if let comment = longest.comment {
                                                        CommentLabel(comment, toneStyle: toneStyle)
                                                }
                                                if let secondaryComment = longest.secondaryComment {
                                                        Text(verbatim: secondaryComment).font(.comment)
                                                }
                                        }
                                        .opacity(0)
                                        HStack(spacing: 14) {
                                                SerialNumberLabel(index)
                                                Text(verbatim: candidate.text).font(.candidate)
                                                if let comment = candidate.comment {
                                                        CommentLabel(comment, toneStyle: toneStyle)
                                                }
                                                if let secondaryComment = candidate.secondaryComment {
                                                        Text(verbatim: secondaryComment).font(.comment)
                                                }
                                        }
                                }
                                .padding(.horizontal, 8)
                                .padding(.vertical, lineSpacing)
                                .foregroundColor(isHighlighted ? .white : .primary)
                                .background(isHighlighted ? Color.accentColor : Color.clear, in: RoundedRectangle(cornerRadius: 4, style: .continuous))
                        }
                }
                .padding(8)
                .animation(.default, value: displayObject.animationState)
        }
}


struct SerialNumberLabel: View {
        init(_ index: Int) {
                self.number = (index == 9) ? 0 : (index + 1)
        }
        private let number: Int
        var body: some View {
                HStack(spacing: 0) {
                        Text(verbatim: "\(number)").font(.label)
                        Text(verbatim: ".").font(.labelDot)
                }
        }
}


private struct CommentLabel: View {

        private struct SyllableUnit {
                let syllable: String
                let tone: String
        }

        init(_ comment: String, toneStyle: ToneDisplayStyle) {
                self.comment = comment
                self.toneStyle = toneStyle
                self.syllableUnits = {
                        guard toneStyle == .superscript || toneStyle == .subscript else { return [] }
                        let parts = comment.split(separator: " ")
                        let units: [SyllableUnit] = parts.map { text -> SyllableUnit in
                                let syllable: String = String(text.dropLast())
                                let tone: String = String(text.last ?? "0")
                                return SyllableUnit(syllable: syllable, tone: tone)
                        }
                        return units
                }()
        }

        private let comment: String
        private let toneStyle: ToneDisplayStyle
        private let syllableUnits: [SyllableUnit]

        var body: some View {
                switch toneStyle {
                case .normal:
                        Text(verbatim: comment).font(.comment)
                case .noTones:
                        Text(verbatim: comment.filter({ !($0.isNumber) })).font(.comment)
                case .superscript:
                        if !(comment.last?.isNumber ?? false) {
                                Text(verbatim: comment).font(.comment)
                        } else {
                                HStack(alignment: .top, spacing: 0) {
                                        ForEach(0..<syllableUnits.count, id: \.self) { index in
                                                let unit = syllableUnits[index]
                                                let syllableText: String = (index == 0) ? unit.syllable : " \(unit.syllable)"
                                                Text(verbatim: syllableText).font(.comment)
                                                Text(verbatim: unit.tone).font(.commentTone)
                                        }
                                        Spacer()
                                }
                        }
                case .subscript:
                        if !(comment.last?.isNumber ?? false) {
                                Text(verbatim: comment).font(.comment)
                        } else {
                                HStack(alignment: .bottom, spacing: 0) {
                                        ForEach(0..<syllableUnits.count, id: \.self) { index in
                                                let unit = syllableUnits[index]
                                                let syllableText: String = (index == 0) ? unit.syllable : " \(unit.syllable)"
                                                Text(verbatim: syllableText).font(.comment)
                                                Text(verbatim: unit.tone).font(.commentTone)
                                        }
                                        Spacer()
                                }
                        }
                }
        }
}

