import SwiftUI
import CommonExtensions

struct ABCRightKey: View {

        @EnvironmentObject private var context: KeyboardViewController
        @Environment(\.colorScheme) private var colorScheme

        private var keyColor: Color {
                return colorScheme.isDark ? .darkInput : .lightInput
        }
        private var keyActiveColor: Color {
                return colorScheme.isDark ? .activeDarkInput : .activeLightInput
        }
        private var keyPreviewColor: Color {
                return colorScheme.isDark ? .solidDarkInput : .lightInput
        }

        @GestureState private var isTouching: Bool = false
        private let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
        @State private var buffer: Int = 0
        @State private var isLongPressing: Bool = false
        @State private var selectedIndex: Int = 0
        @State private var pulled: String? = nil

        private let symbols: [String] = [".", "?", "!", "…"]
        private let headerText: String = "?"

        var body: some View {
                let keyWidth: CGFloat = context.widthUnit
                let keyHeight: CGFloat = context.heightUnit
                let isPhoneLandscape: Bool = context.keyboardInterface.isPhoneLandscape
                let verticalPadding: CGFloat = isPhoneLandscape ? 3 : 6
                let horizontalPadding: CGFloat = isPhoneLandscape ? 6 : 3
                let baseWidth: CGFloat = keyWidth - (horizontalPadding * 2)
                let baseHeight: CGFloat = keyHeight - (verticalPadding * 2)
                let shapeHeight: CGFloat = isPhoneLandscape ? (baseHeight / (2 / 6.0)) : baseHeight / ((2.5 / 6.0))
                let curveHeight: CGFloat = isPhoneLandscape ? (shapeHeight / 3.0) : (shapeHeight / 6.0)
                let previewBottomOffset: CGFloat = (baseHeight * 2) + (curveHeight * 1.5)
                let shouldPreviewKey: Bool = Options.keyTextPreview
                let activeColor: Color = shouldPreviewKey ? keyColor : keyActiveColor
                let shouldShowExtraHeader: Bool = (Options.inputKeyStyle == .numbersAndSymbols)
                ZStack {
                        Color.interactiveClear
                        if isLongPressing {
                                let symbolCount: Int = symbols.count
                                let expansionCount: Int = symbolCount - 1
                                let trailingOffset: CGFloat = baseWidth * CGFloat(expansionCount)
                                ExpansiveBubbleShape(keyLocale: .trailing, expansionCount: expansionCount)
                                        .fill(keyPreviewColor)
                                        .shadow(color: .shadowGray, radius: 1)
                                        .overlay {
                                                HStack(spacing: 0) {
                                                        ForEach(symbols.indices, id: \.self) { index in
                                                                let reversedIndex = (symbolCount - 1) - index
                                                                ZStack {
                                                                        RoundedRectangle(cornerRadius: PresetConstant.keyCornerRadius, style: .continuous)
                                                                                .fill(selectedIndex == reversedIndex ? Color.accentColor : Color.clear)
                                                                        Text(verbatim: symbols[reversedIndex])
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
                                        .padding(.vertical, verticalPadding)
                                        .padding(.horizontal, horizontalPadding)
                        } else if (isTouching && shouldPreviewKey) {
                                BubbleShape()
                                        .fill(keyPreviewColor)
                                        .shadow(color: .shadowGray, radius: 1)
                                        .overlay {
                                                Text(verbatim: pulled ?? String.period)
                                                        .font(.largeTitle)
                                                        .padding(.bottom, previewBottomOffset)
                                        }
                                        .padding(.vertical, verticalPadding)
                                        .padding(.horizontal, horizontalPadding)
                        } else {
                                RoundedRectangle(cornerRadius: PresetConstant.keyCornerRadius, style: .continuous)
                                        .fill(isTouching ? activeColor : keyColor)
                                        .shadow(color: .shadowGray, radius: 0.5, y: 0.5)
                                        .padding(.vertical, verticalPadding)
                                        .padding(.horizontal, horizontalPadding)
                                ZStack(alignment: .topTrailing) {
                                        Color.clear
                                        Text(verbatim: headerText).font(.keyFootnote)
                                }
                                .padding(.vertical, verticalPadding)
                                .padding(.horizontal, horizontalPadding + 2)
                                .opacity(shouldShowExtraHeader ? 0.5 : 0)
                                Text(verbatim: String.period).font(.letterCompact)
                        }
                }
                .frame(width: keyWidth, height: keyHeight)
                .contentShape(Rectangle())
                .gesture(DragGesture(minimumDistance: 0)
                        .updating($isTouching) { _, tapped, _ in
                                if tapped.negative {
                                        AudioFeedback.inputed()
                                        context.triggerHapticFeedback()
                                        tapped = true
                                }
                        }
                        .onChanged { state in
                                if isLongPressing {
                                        let memberCount: Int = symbols.count
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
                                        guard shouldShowExtraHeader else { return }
                                        guard pulled == nil else { return }
                                        let distance: CGFloat = state.translation.height
                                        guard abs(distance) > 30 else { return }
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
                                        context.operate(.input(String.period))
                                }
                        }
                )
                .onReceive(timer) { _ in
                        guard isTouching else { return }
                        guard isLongPressing.negative else { return }
                        let shouldTriggerLongPress: Bool = buffer > 6 || (buffer > 3 && pulled == nil)
                        if shouldTriggerLongPress {
                                isLongPressing = true
                        } else {
                                buffer += 1
                        }
                }
        }
}
