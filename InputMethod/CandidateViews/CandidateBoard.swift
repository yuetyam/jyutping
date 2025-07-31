import SwiftUI
import CommonExtensions

struct CandidateBoard: View {

        @EnvironmentObject private var context: AppContext

        private let pageOrientation: CandidatePageOrientation = AppSettings.candidatePageOrientation
        private let commentStyle: CommentDisplayStyle = AppSettings.commentDisplayStyle
        private let toneStyle: ToneDisplayStyle = AppSettings.toneDisplayStyle
        private let toneColor: ToneDisplayColor = AppSettings.toneDisplayColor
        private let labelSet: LabelSet = AppSettings.labelSet
        private let isLabelLastZero: Bool = AppSettings.isLabelLastZero
        private let isCompatibleModeOn: Bool = AppSettings.isCompatibleModeOn
        private let lineSpacing: CGFloat = CGFloat(AppSettings.candidateLineSpacing)
        private let pageCornerRadius: CGFloat = CGFloat(AppSettings.pageCornerRadius)
        private let contentInsets: CGFloat = CGFloat(AppSettings.contentInsets)
        private let innerCornerRadius: CGFloat = CGFloat(AppSettings.innerCornerRadius)

        var body: some View {
                let highlightedIndex: Int = context.highlightedIndex
                switch pageOrientation {
                case .horizontal:
                        HStack(alignment: commentStyle.horizontalPageAlignment, spacing: 0) {
                                ForEach(context.displayCandidates.indices, id: \.self) { index in
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
                                        .padding(.vertical, 2)
                                        .padding(.trailing, 3)
                                        .padding(.horizontal, lineSpacing / 2.0)
                                        .foregroundStyle(index == highlightedIndex ? Color.white : Color.primary)
                                        .background(index == highlightedIndex ? Color.accentColor : Color.clear, in: RoundedRectangle(cornerRadius: innerCornerRadius, style: .continuous))
                                        .contentShape(Rectangle())
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
                        .padding(contentInsets)
                        .background(VisualEffectView())
                        .clipShape(RoundedRectangle(cornerRadius: pageCornerRadius, style: .continuous))
                        .shadow(radius: 2)
                        .padding(8)
                        .fixedSize()
                case .vertical:
                        VStack(alignment: .leading, spacing: 0) {
                                ForEach(context.displayCandidates.indices, id: \.self) { index in
                                        ZStack(alignment: .leading) {
                                                RoundedRectangle(cornerRadius: innerCornerRadius, style: .continuous)
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
                                                .padding(.horizontal, 3)
                                                .padding(.vertical, lineSpacing / 2.0)
                                                .foregroundStyle(index == highlightedIndex ? Color.white : Color.primary)
                                                .fixedSize()
                                        }
                                        .contentShape(Rectangle())
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
                        .padding(contentInsets)
                        .background(VisualEffectView())
                        .clipShape(RoundedRectangle(cornerRadius: pageCornerRadius, style: .continuous))
                        .shadow(radius: 2)
                        .padding(8)
                        .fixedSize()
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
