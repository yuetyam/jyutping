import SwiftUI
import CommonExtensions

struct CandidateStackView: View {

        @EnvironmentObject private var context: InputContext

        private let pageOrientation: CandidatePageOrientation = AppSettings.candidatePageOrientation
        private let commentScene: CommentDisplayScene = AppSettings.commentDisplayScene
        private let savedCommentStyle: CommentDisplayStyle = AppSettings.commentDisplayStyle
        private let toneStyle: ToneDisplayStyle = AppSettings.toneDisplayStyle
        private let toneColor: ToneDisplayColor = AppSettings.toneDisplayColor
        private let labelSet: LabelSet = AppSettings.labelSet
        private let isLabelLastZero: Bool = AppSettings.isLabelLastZero
        private let isCompatibleModeOn: Bool = AppSettings.isCompatibleModeOn
        private let lineSpacing: CGFloat = CGFloat(AppSettings.candidateLineSpacing)
        private let innerCornerRadius: CGFloat = CGFloat(AppSettings.innerCornerRadius)

        var body: some View {
                let commentStyle: CommentDisplayStyle = switch commentScene {
                case .all: savedCommentStyle
                case .reverseLookup: context.isReverseLookup ? savedCommentStyle : .noComments
                case .noneOfAll: .noComments
                }
                let highlightedIndex: Int = context.highlightedIndex
                switch pageOrientation {
                case .horizontal:
                        HStack(alignment: commentStyle.horizontalPageAlignment, spacing: 0) {
                                ForEach(context.displayCandidates.indices, id: \.self) { index in
                                        ZStack {
                                                RoundedRectangle(cornerRadius: innerCornerRadius)
                                                        .fill(index == highlightedIndex ? Color.accentColor : Color.clear)
                                                HorizontalPageCandidateLabel(
                                                        isHighlighted: index == highlightedIndex,
                                                        index: index,
                                                        candidate: context.displayCandidates[index],
                                                        commentStyle: commentStyle,
                                                        toneStyle: toneStyle,
                                                        toneColor: toneColor,
                                                        labelSet: labelSet,
                                                        isLabelLastZero: isLabelLastZero,
                                                        compatibleMode: isCompatibleModeOn
                                                )
                                                .foregroundStyle(index == highlightedIndex ? Color.white : Color.primary)
                                                .padding(.vertical, 2)
                                                .padding(.trailing, 3)
                                                .padding(.horizontal, lineSpacing / 2.0)
                                        }
                                        .contentShape(.rect)
                                        .onHover { isHovering in
                                                guard isHovering else { return }
                                                guard index != highlightedIndex else { return }
                                                guard NSEvent.mouseLocation != context.mouseLocation else { return }
                                                NotificationCenter.default.post(name: .highlightIndex, object: nil, userInfo: [NotificationKey.highlightIndex : index])
                                        }
                                        .onTapGesture {
                                                NotificationCenter.default.post(name: .selectIndex, object: nil, userInfo: [NotificationKey.selectIndex : index])
                                        }
                                }
                        }
                case .vertical:
                        VStack(alignment: .leading, spacing: 0) {
                                ForEach(context.displayCandidates.indices, id: \.self) { index in
                                        ZStack(alignment: .leading) {
                                                RoundedRectangle(cornerRadius: innerCornerRadius)
                                                        .fill(index == highlightedIndex ? Color.accentColor : Color.clear)
                                                VerticalPageCandidateLabel(
                                                        isHighlighted: index == highlightedIndex,
                                                        index: index,
                                                        candidate: context.displayCandidates[index],
                                                        commentStyle: commentStyle,
                                                        toneStyle: toneStyle,
                                                        toneColor: toneColor,
                                                        labelSet: labelSet,
                                                        isLabelLastZero: isLabelLastZero,
                                                        compatibleMode: isCompatibleModeOn
                                                )
                                                .foregroundStyle(index == highlightedIndex ? Color.white : Color.primary)
                                                .padding(.horizontal, 3)
                                                .padding(.vertical, lineSpacing / 2.0)
                                                .fixedSize()
                                        }
                                        .contentShape(.rect)
                                        .onHover { isHovering in
                                                guard isHovering else { return }
                                                guard index != highlightedIndex else { return }
                                                guard NSEvent.mouseLocation != context.mouseLocation else { return }
                                                NotificationCenter.default.post(name: .highlightIndex, object: nil, userInfo: [NotificationKey.highlightIndex : index])
                                        }
                                        .onTapGesture {
                                                NotificationCenter.default.post(name: .selectIndex, object: nil, userInfo: [NotificationKey.selectIndex : index])
                                        }
                                }
                        }
                }
        }
}

private extension CommentDisplayStyle {
        var horizontalPageAlignment: VerticalAlignment {
                switch self {
                case .top: .lastTextBaseline
                case .bottom: .firstTextBaseline
                case .right: .center
                case .noComments: .center
                }
        }
}
