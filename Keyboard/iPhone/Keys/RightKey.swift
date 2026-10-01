import SwiftUI
import CommonExtensions
import CoreIME

struct RightKey: View {

        @EnvironmentObject private var context: KeyboardViewController
        @Environment(\.colorScheme) private var colorScheme

        @State private var isTouching: Bool = false
        @State private var buffer: Int = 0
        @State private var isLongPressing: Bool = false
        @State private var selectedIndex: Int = 0
        @State private var pulled: String? = nil

        private let elements: [KeyElement] = [
                KeyElement("。"),
                KeyElement("？"),
                KeyElement("！"),
                KeyElement("…", header: "省略號"),
                KeyElement(".", header: "英文")
        ]
        private let headerText: String = "？"

        var body: some View {
                let keyWidth: CGFloat = context.widthUnit
                let keyHeight: CGFloat = context.heightUnit
                let keyboardInterface = context.keyboardInterface
                let keyShapeInsets = keyboardInterface.keyShapeInsets
                let baseWidth: CGFloat = keyWidth - keyShapeInsets.horizontalTotal
                let baseHeight: CGFloat = keyHeight - keyShapeInsets.verticalTotal
                let previewBottomOffset: CGFloat = keyboardInterface.previewBottomOffset(keyWidth: keyWidth, keyHeight: keyHeight, insets: keyShapeInsets)
                let shouldPreviewKey: Bool = Options.keyTextPreview
                let activeColor: Color = shouldPreviewKey ? colorScheme.inputKeyColor : colorScheme.activeInputKeyColor
                let shouldShowExtraSymbols: Bool = Options.inputKeyStyle.isSymbolApplied
                Button(action: {}) {
                        ZStack {
                                Color.interactiveClear
                                if isLongPressing {
                                        let symbolCount: Int = elements.count
                                        let expansionCount: Int = symbolCount - 1
                                        let trailingOffset: CGFloat = baseWidth * CGFloat(expansionCount)
                                        ExpansiveBubbleShape(keyLocale: .trailing, expansionCount: expansionCount)
                                                .fill(colorScheme.previewBubbleColor)
                                                .shadow(color: .shadowGray, radius: 1)
                                                .overlay {
                                                        HStack(spacing: 0) {
                                                                ForEach(elements.indices, id: \.self) { index in
                                                                        let reversedIndex = (symbolCount - 1) - index
                                                                        let element = elements[reversedIndex]
                                                                        ZStack {
                                                                                RoundedRectangle(cornerRadius: PresetConstant.keyCornerRadius)
                                                                                        .fill(selectedIndex == reversedIndex ? Color.accentColor : Color.clear)
                                                                                ZStack(alignment: .top) {
                                                                                        Color.interactiveClear
                                                                                        Text(verbatim: element.header ?? String.space)
                                                                                                .font(.labelCaption)
                                                                                                .shallow()
                                                                                }
                                                                                Text(verbatim: element.text)
                                                                                        .font(.title2)
                                                                                        .foregroundStyle(selectedIndex == reversedIndex ? Color.white : Color.primary)
                                                                        }
                                                                        .frame(maxWidth: .infinity)
                                                                }
                                                        }
                                                        .frame(width: baseWidth * CGFloat(symbolCount), height: baseHeight)
                                                        .padding(.bottom, previewBottomOffset)
                                                        .padding(.trailing, trailingOffset)
                                                }
                                                .padding(keyShapeInsets)
                                } else if (isTouching && shouldPreviewKey) {
                                        BubbleShape()
                                                .fill(colorScheme.previewBubbleColor)
                                                .shadow(color: .shadowGray, radius: 1)
                                                .overlay {
                                                        Text(verbatim: pulled ?? (context.inputStage.isBuffering ? String.apostrophe : String.cantonesePeriod))
                                                                .font(.largeTitle)
                                                                .padding(.bottom, previewBottomOffset)
                                                }
                                                .padding(keyShapeInsets)
                                } else {
                                        RoundedRectangle(cornerRadius: PresetConstant.keyCornerRadius)
                                                .fill(isTouching ? activeColor : colorScheme.inputKeyColor)
                                                .shadow(color: .shadowGray, radius: 0.5, y: 0.5)
                                                .padding(keyShapeInsets)
                                        ZStack(alignment: .topTrailing) {
                                                Color.clear
                                                Text(verbatim: headerText).font(.labelCaption)
                                        }
                                        .padding(keyShapeInsets.plused(horizontal: 2))
                                        .opacity((shouldShowExtraSymbols && context.inputStage.isBuffering.negative) ? 0.5 : 0)
                                        ZStack(alignment: .bottom) {
                                                Color.clear
                                                Text(verbatim: PresetConstant.separate).font(.labelCaption)
                                        }
                                        .padding(keyShapeInsets.plused(vertical: 2))
                                        .opacity(context.inputStage.isBuffering ? 0.5 : 0)
                                        Text(verbatim: context.inputStage.isBuffering ? String.apostrophe : String.cantonesePeriod).font(.letterCompact)
                                }
                        }
                        .frame(width: keyWidth, height: keyHeight)
                }
                .buttonStyle(PressButtonStyle($isTouching) {
                        AudioFeedback.inputed()
                        context.triggerHapticFeedback()
                })
                .simultaneousGesture(DragGesture(minimumDistance: 0)
                        .onChanged { state in
                                if isLongPressing {
                                        let memberCount: Int = elements.count
                                        let distance: CGFloat = -(state.translation.width)
                                        if distance < (baseWidth / 2.0) {
                                                if selectedIndex != 0 {
                                                        selectedIndex = 0
                                                }
                                        } else {
                                                let maxPoint: CGFloat = baseWidth * CGFloat(memberCount)
                                                let endIndex: Int = memberCount - 1
                                                let index = memberCount - Int((maxPoint - distance) / baseWidth)
                                                let newSelectedIndex = min(endIndex, max(0, index))
                                                if selectedIndex != newSelectedIndex {
                                                        selectedIndex = newSelectedIndex
                                                }
                                        }
                                } else {
                                        guard shouldShowExtraSymbols && pulled.isNil else { return }
                                        guard context.inputStage.isBuffering.negative else { return }
                                        let distance: CGFloat = state.translation.height
                                        let isSatisfied: Bool = abs(distance) > 36 || (buffer > 1 && abs(distance) > 24)
                                        guard isSatisfied else { return }
                                        pulled = headerText
                                }
                        }
                        .onEnded { _ in
                                buffer = 0
                                defer {
                                        selectedIndex = 0
                                        isLongPressing = false
                                        pulled = nil
                                }
                                if isLongPressing {
                                        guard let selectedSymbol: String = elements.fetch(selectedIndex)?.text else { return }
                                        AudioFeedback.inputed()
                                        context.triggerSelectionHapticFeedback()
                                        context.operate(.input(selectedSymbol))
                                } else if let pulledText = pulled {
                                        context.operate(.input(pulledText))
                                } else if context.inputStage.isBuffering {
                                        context.handle(.apostrophe)
                                } else {
                                        context.operate(.input(String.cantonesePeriod))
                                }
                         }
                )
                .task(id: isTouching) {
                        guard isTouching else { return }
                        while Task.isCancelled.negative {
                                try? await Task.sleep(for: .milliseconds(100)) // 0.1s
                                if isTouching {
                                        if isLongPressing.negative {
                                                let shouldTriggerLongPress: Bool = (buffer >= 6) || (buffer >= 3 && pulled.isNil)
                                                if shouldTriggerLongPress {
                                                        if context.inputStage.isBuffering.negative {
                                                                isLongPressing = true
                                                        }
                                                } else {
                                                        buffer += 1
                                                }
                                        }
                                }
                        }
                }
        }
}
