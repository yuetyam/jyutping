import SwiftUI
import CommonExtensions

struct ABCLeftKey: View {

        @EnvironmentObject private var context: KeyboardViewController
        @Environment(\.colorScheme) private var colorScheme

        @State private var isTouching: Bool = false
        @State private var buffer: Int = 0
        @State private var isLongPressing: Bool = false
        @State private var selectedIndex: Int = 0
        @State private var pulled: String? = nil

        private let symbols: [String] = [",", "!", "?", ";"]
        private let headerText: String = "!"

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
                                        let symbolCount: Int = symbols.count
                                        let expansionCount: Int = symbolCount - 1
                                        let leadingOffset: CGFloat = baseWidth * CGFloat(expansionCount)
                                        ExpansiveBubbleShape(side: .leading, expansionCount: expansionCount)
                                                .fill(colorScheme.previewBubbleColor)
                                                .shadow(color: .shadowGray, radius: 1)
                                                .overlay {
                                                        HStack(spacing: 0) {
                                                                ForEach(symbols.indices, id: \.self) { index in
                                                                        ZStack {
                                                                                RoundedRectangle(cornerRadius: PresetConstant.keyCornerRadius)
                                                                                        .fill(selectedIndex == index ? Color.accentColor : Color.clear)
                                                                                Text(verbatim: symbols[index])
                                                                                        .font(.title2)
                                                                                        .foregroundStyle(selectedIndex == index ? Color.white : Color.primary)
                                                                        }
                                                                        .frame(maxWidth: .infinity)
                                                                }
                                                        }
                                                        .frame(width: baseWidth * CGFloat(symbolCount), height: baseHeight)
                                                        .padding(.bottom, previewBottomOffset)
                                                        .padding(.leading, leadingOffset)
                                                }
                                                .padding(keyShapeInsets)
                                } else if (isTouching && shouldPreviewKey) {
                                        BubbleShape()
                                                .fill(colorScheme.previewBubbleColor)
                                                .shadow(color: .shadowGray, radius: 1)
                                                .overlay {
                                                        Text(verbatim: pulled ?? String.comma)
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
                                        .opacity(shouldShowExtraSymbols ? 0.5 : 0)
                                        Text(verbatim: String.comma).font(.letterCompact)
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
                                        let memberCount: Int = symbols.count
                                        let distance: CGFloat = state.translation.width
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
                                        guard let selectedSymbol: String = symbols.fetch(selectedIndex) else { return }
                                        AudioFeedback.inputed()
                                        context.triggerSelectionHapticFeedback()
                                        context.operate(.input(selectedSymbol))
                                } else if let pulledText = pulled {
                                        context.operate(.input(pulledText))
                                } else {
                                        context.operate(.input(String.comma))
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
                                                        isLongPressing = true
                                                } else {
                                                        buffer += 1
                                                }
                                        }
                                }
                        }
                }
        }
}
