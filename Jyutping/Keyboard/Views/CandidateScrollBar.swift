import SwiftUI
import CoreIME

struct CandidateScrollBar: View {

        @EnvironmentObject private var context: KeyboardViewController

        var body: some View {
                let commentStyle: CommentStyle = Options.commentStyle
                let commentToneStyle: CommentToneStyle = Options.commentToneStyle
                HStack(spacing: 0) {
                        ScrollView(.horizontal) {
                                LazyHStack(spacing: 0) {
                                        ForEach(0..<context.candidates.count, id: \.self) { index in
                                                let candidate = context.candidates[index]
                                                ZStack {
                                                        Color.interactiveClear
                                                        switch commentStyle {
                                                        case .aboveCandidates:
                                                                VStack {
                                                                        RomanizationLabel(candidate: candidate, toneStyle: commentToneStyle)
                                                                        Text(verbatim: candidate.text)
                                                                                .lineLimit(1)
                                                                                .font(.candidate)
                                                                }
                                                                .padding(.horizontal, 1)
                                                                .padding(.bottom, 8)
                                                        case .belowCandidates:
                                                                VStack {
                                                                        Text(verbatim: candidate.text)
                                                                                .lineLimit(1)
                                                                                .font(.candidate)
                                                                        RomanizationLabel(candidate: candidate, toneStyle: commentToneStyle)
                                                                }
                                                                .padding(.horizontal, 1)
                                                                .padding(.bottom, 8)
                                                        case .noComments:
                                                                Text(verbatim: candidate.text)
                                                                        .lineLimit(1)
                                                                        .font(.candidate)
                                                                        .padding(.horizontal, 1)
                                                                        .padding(.bottom, 4)
                                                        }
                                                }
                                                .frame(width: candidateWidth(of: candidate))
                                                .frame(maxHeight: .infinity)
                                                .contentShape(Rectangle())
                                                .onTapGesture {
                                                        AudioFeedback.inputed()
                                                        context.triggerSelectionHapticFeedback()
                                                        context.operate(.select(candidate))
                                                }
                                        }
                                }
                        }
                        .frame(width: context.keyboardWidth - expanderWidth, height: Constant.toolBarHeight)
                        ZStack {
                                Color.interactiveClear
                                HStack {
                                        Rectangle().fill(Color.black).opacity(0.3).frame(width: 1, height: 24)
                                        Spacer()
                                }
                                Image(systemName: "chevron.down")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 20, height: 20)
                        }
                        .frame(width: expanderWidth, height: Constant.toolBarHeight)
                        .contentShape(Rectangle())
                        .onTapGesture {
                                AudioFeedback.modified()
                                context.triggerHapticFeedback()
                                context.updateKeyboardForm(to: .candidateBoard)
                        }
                }
        }

        private let expanderWidth: CGFloat = 44

        private func candidateWidth(of candidate: Candidate) -> CGFloat {
                return CGFloat(candidate.text.count * 20 + 28)
        }
}


private struct RomanizationLabel: View {

        init(candidate: Candidate, toneStyle: CommentToneStyle) {
                self.candidate = candidate
                self.toneStyle = toneStyle
                self.syllables = {
                        let blocks = candidate.romanization.split(separator: " ")
                        let items: [Syllable] = blocks.map({ syllable -> Syllable in
                                let phone: String = syllable.filter({ !$0.isTone })
                                let tone: String = syllable.filter(\.isTone)
                                return Syllable(phone: phone, tone: tone)
                        })
                        return items
                }()
        }

        let candidate: Candidate
        let toneStyle: CommentToneStyle
        let syllables: [Syllable]

        var body: some View {
                switch toneStyle {
                case .normal:
                        Text(verbatim: candidate.isCantonese ? candidate.romanization : String.space)
                                .minimumScaleFactor(0.2)
                                .lineLimit(1)
                                .font(.romanization)
                case .superscript:
                        if candidate.isCantonese {
                                HStack(alignment: .top, spacing: 0) {
                                        ForEach(0..<syllables.count, id: \.self) { index in
                                                let syllable = syllables[index]
                                                let leadingText: String = (index == 0) ? syllable.phone : (String.space + syllable.phone)
                                                Text(verbatim: leadingText)
                                                        .minimumScaleFactor(0.2)
                                                        .lineLimit(1)
                                                        .font(.romanization)
                                                Text(verbatim: syllable.tone).font(.tone)
                                        }
                                }
                        } else {
                                Text(verbatim: String.space).font(.romanization)
                        }
                case .subscript:
                        if candidate.isCantonese {
                                HStack(alignment: .bottom, spacing: 0) {
                                        ForEach(0..<syllables.count, id: \.self) { index in
                                                let syllable = syllables[index]
                                                let leadingText: String = (index == 0) ? syllable.phone : (String.space + syllable.phone)
                                                Text(verbatim: leadingText)
                                                        .minimumScaleFactor(0.2)
                                                        .lineLimit(1)
                                                        .font(.romanization)
                                                Text(verbatim: syllable.tone).font(.tone)
                                        }
                                }
                        } else {
                                Text(verbatim: String.space).font(.romanization)
                        }
                case .noTones:
                        Text(verbatim: candidate.isCantonese ? candidate.romanization.removedTones() : String.space)
                                .minimumScaleFactor(0.2)
                                .lineLimit(1)
                                .font(.romanization)
                }
        }
}

private struct Syllable {
        let phone: String
        let tone: String
}
