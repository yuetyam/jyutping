import SwiftUI
import CommonExtensions

struct LeftKey: View {

        @EnvironmentObject private var context: KeyboardViewController

        @Environment(\.colorScheme) private var colorScheme

        private var keyColor: Color {
                switch colorScheme {
                case .light:
                        return .lightInput
                case .dark:
                        return .darkInput
                @unknown default:
                        return .lightInput
                }
        }
        private var keyPreviewColor: Color {
                switch colorScheme {
                case .light:
                        return .lightInput
                case .dark:
                        return .solidDarkInput
                @unknown default:
                        return .lightInput
                }
        }
        private var keyActiveColor: Color {
                switch colorScheme {
                case .light:
                        return .activeLightInput
                case .dark:
                        return .activeDarkInput
                @unknown default:
                        return .activeLightInput
                }
        }

        private func keyText(isABCMode: Bool, isBuffering: Bool) -> String {
                guard isABCMode.negative else { return "," }
                guard isBuffering.negative else { return "'" }
                return "，"
        }
        private func symbols(isABCMode: Bool) -> [String] {
                return isABCMode ? [",", ".", "?", "!"] : ["，", "、", "？", "！"]
        }

        @GestureState private var isTouching: Bool = false
        private let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
        @State private var buffer: Int = 0
        @State private var isLongPressing: Bool = false
        @State private var selectedIndex: Int = 0

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
                ZStack {
                        Color.interactiveClear
                        if isLongPressing {
                                let symbols: [String] = symbols(isABCMode: context.inputMethodMode.isABC)
                                let symbolCount: Int = symbols.count
                                let expansionCount: Int = symbolCount - 1
                                let leadingOffset: CGFloat = baseWidth * CGFloat(expansionCount)
                                ExpansiveBubbleShape(keyLocale: .leading, expansionCount: expansionCount)
                                        .fill(keyPreviewColor)
                                        .shadow(color: .shadowGray, radius: 1)
                                        .overlay {
                                                HStack(spacing: 0) {
                                                        ForEach(symbols.indices, id: \.self) { index in
                                                                ZStack {
                                                                        RoundedRectangle(cornerRadius: PresetConstant.keyCornerRadius, style: .continuous)
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
                                        .padding(.vertical, verticalPadding)
                                        .padding(.horizontal, horizontalPadding)
                        } else if (isTouching && shouldPreviewKey) {
                                BubbleShape()
                                        .fill(keyPreviewColor)
                                        .shadow(color: .shadowGray, radius: 1)
                                        .overlay {
                                                Text(verbatim: keyText(isABCMode: context.inputMethodMode.isABC, isBuffering: context.inputStage.isBuffering))
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
                                ZStack(alignment: .bottom) {
                                        Color.clear
                                        Text(verbatim: PresetConstant.separate).font(.keyFootnote)
                                }
                                .padding(.vertical, verticalPadding + 2)
                                .opacity(context.inputStage.isBuffering ? 0.5 : 0)
                                Text(verbatim: keyText(isABCMode: context.inputMethodMode.isABC, isBuffering: context.inputStage.isBuffering))
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
                                let distance: CGFloat = state.translation.width
                                if distance < (baseWidth / 2.0) {
                                        if selectedIndex != 0 {
                                                selectedIndex = 0
                                        }
                                } else {
                                        let memberCount: Int = 4
                                        let maxPoint: CGFloat = baseWidth * CGFloat(memberCount)
                                        let endIndex: Int = memberCount - 1
                                        let index = memberCount - Int((maxPoint - distance) / baseWidth)
                                        selectedIndex = min(endIndex, max(0, index))
                                }
                        }
                        .onEnded { _ in
                                buffer = 0
                                if isLongPressing {
                                        defer {
                                                selectedIndex = 0
                                                isLongPressing = false
                                        }
                                        let symbols: [String] = symbols(isABCMode: context.inputMethodMode.isABC)
                                        guard let selectedSymbol: String = symbols.fetch(selectedIndex) else { return }
                                        AudioFeedback.inputed()
                                        context.triggerSelectionHapticFeedback()
                                        context.operate(.input(selectedSymbol))
                                } else {
                                        if context.inputMethodMode.isABC {
                                                context.operate(.input(","))
                                        } else {
                                                if context.inputStage.isBuffering {
                                                        context.operate(.separate)
                                                } else {
                                                        context.operate(.input("，"))
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
