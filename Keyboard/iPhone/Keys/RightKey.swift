import SwiftUI
import CommonExtensions

struct RightKey: View {

        @EnvironmentObject private var context: KeyboardViewController

        @Environment(\.colorScheme) private var colorScheme
        private var keyColor: Color {
                switch colorScheme {
                case .light:
                        return .light
                case .dark:
                        return .dark
                @unknown default:
                        return .light
                }
        }
        private var keyPreviewColor: Color {
                switch colorScheme {
                case .light:
                        return .light
                case .dark:
                        return .darkOpacity
                @unknown default:
                        return .light
                }
        }
        private var keyActiveColor: Color {
                switch colorScheme {
                case .light:
                        return .lightEmphatic
                case .dark:
                        return .darkEmphatic
                @unknown default:
                        return .lightEmphatic
                }
        }

        @GestureState private var isTouching: Bool = false
        private let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
        @State private var buffer: Int = 0
        @State private var isLongPressing: Bool = false
        @State private var selectedIndex: Int = 0

        private func keyText(isABCMode: Bool, isBuffering: Bool, needsInputModeSwitchKey: Bool) -> String {
                if isABCMode {
                        return "."
                } else if isBuffering {
                        return "'"
                } else if needsInputModeSwitchKey {
                        return "，"
                } else {
                        return "。"
                }
        }
        private func symbols(isABCMode: Bool, needsInputModeSwitchKey: Bool) -> [String] {
                switch (isABCMode, needsInputModeSwitchKey) {
                case (true, true):
                        return [".", ",", "?", "!"]
                case (true, false):
                        return [".", ",", "?", "!"]
                case (false, true):
                        return ["，", "。", "？", "！"]
                case (false, false):
                        return ["。", ".", "？", "！"]
                }
        }

        var body: some View {
                let needsInputModeSwitchKey: Bool = context.needsInputModeSwitchKey
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
                ZStack {
                        Color.interactiveClear
                        if isLongPressing {
                                let symbols: [String] = symbols(isABCMode: context.inputMethodMode.isABC, needsInputModeSwitchKey: needsInputModeSwitchKey)
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
                                                                        RoundedRectangle(cornerRadius: 5, style: .continuous)
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
                                                Text(verbatim: keyText(isABCMode: context.inputMethodMode.isABC, isBuffering: context.inputStage.isBuffering, needsInputModeSwitchKey: needsInputModeSwitchKey))
                                                        .font(.largeTitle)
                                                        .padding(.bottom, previewBottomOffset)
                                        }
                                        .padding(.vertical, verticalPadding)
                                        .padding(.horizontal, horizontalPadding)
                        } else {
                                RoundedRectangle(cornerRadius: 5, style: .continuous)
                                        .fill(isTouching ? activeColor : keyColor)
                                        .shadow(color: .shadowGray, radius: 0.5, y: 0.5)
                                        .padding(.vertical, verticalPadding)
                                        .padding(.horizontal, horizontalPadding)
                                ZStack(alignment: .bottom) {
                                        Color.clear
                                        Text(verbatim: "分隔")
                                                .font(.keyFooter)
                                                .opacity(context.inputStage.isBuffering ? 0.66 : 0)
                                }
                                .padding(.vertical, verticalPadding + 2)
                                .padding(.horizontal, horizontalPadding + 2)
                                Text(verbatim: keyText(isABCMode: context.inputMethodMode.isABC, isBuffering: context.inputStage.isBuffering, needsInputModeSwitchKey: needsInputModeSwitchKey))
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
                                guard isLongPressing else { return }
                                let distance: CGFloat = -(state.translation.width)
                                guard distance > 0 else { return }
                                let step: CGFloat = baseWidth
                                if distance < step {
                                        selectedIndex = 0
                                } else if distance < (step * 2) {
                                        selectedIndex = 1
                                } else if distance < (step * 3) {
                                        selectedIndex = 2
                                } else {
                                        selectedIndex = 3
                                }
                        }
                        .onEnded { _ in
                                buffer = 0
                                if isLongPressing {
                                        defer {
                                                selectedIndex = 0
                                                isLongPressing = false
                                        }
                                        let symbols: [String] = symbols(isABCMode: context.inputMethodMode.isABC, needsInputModeSwitchKey: needsInputModeSwitchKey)
                                        guard let selectedSymbol: String = symbols.fetch(selectedIndex) else { return }
                                        AudioFeedback.inputed()
                                        context.triggerSelectionHapticFeedback()
                                        context.operate(.input(selectedSymbol))
                                } else {
                                        if context.inputMethodMode.isABC {
                                                context.operate(.input("."))
                                        } else {
                                                if context.inputStage.isBuffering {
                                                        context.operate(.separate)
                                                } else {
                                                        let symbol: String = needsInputModeSwitchKey ? "，" : "。"
                                                        context.operate(.input(symbol))
                                                }
                                        }
                                }
                         }
                )
                .onReceive(timer) { _ in
                        guard isTouching else { return }
                        if buffer > 3 {
                                let shouldPerformLongPress: Bool = isLongPressing.negative && context.inputStage.isBuffering.negative
                                if shouldPerformLongPress {
                                        isLongPressing = true
                                }
                        } else {
                                buffer += 1
                        }
                }
        }
}
