import SwiftUI

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

        private func responsiveSymbols(isABCMode: Bool, needsInputModeSwitchKey: Bool) -> [String] {
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
                let shouldPreviewKey: Bool = Options.keyTextPreview
                let activeColor: Color = shouldPreviewKey ? keyColor : keyActiveColor
                ZStack {
                        if isLongPressing {
                                let symbols: [String] = responsiveSymbols(isABCMode: context.inputMethodMode.isABC, needsInputModeSwitchKey: context.needsInputModeSwitchKey)
                                let symbolsCount: Int = symbols.count
                                let expansions: Int = symbolsCount - 1
                                KeyLeftExpansionPath(expansions: expansions)
                                        .fill(keyPreviewColor)
                                        .shadow(color: .shadowGray, radius: 1)
                                        .overlay {
                                                HStack(spacing: 0) {
                                                        ForEach(symbols.indices, id: \.self) { index in
                                                                let reversedIndex = (symbolsCount - 1) - index
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
                                                .frame(width: context.widthUnit * CGFloat(symbolsCount), height: context.heightUnit - 12)
                                                .padding(.bottom, context.heightUnit * 2)
                                                .padding(.trailing, context.widthUnit * CGFloat(expansions))
                                        }
                                        .padding(.vertical, 6)
                                        .padding(.horizontal, 3)
                        } else if (isTouching && shouldPreviewKey) {
                                KeyPreviewPath()
                                        .fill(keyPreviewColor)
                                        .shadow(color: .shadowGray, radius: 1)
                                        .overlay {
                                                RightKeyText(isABCMode: context.inputMethodMode.isABC, isBuffering: context.inputStage.isBuffering, needsInputModeSwitchKey: context.needsInputModeSwitchKey)
                                                        .font(.largeTitle)
                                                        .padding(.bottom, context.heightUnit * 2)
                                        }
                                        .padding(.vertical, 6)
                                        .padding(.horizontal, 3)
                        } else {
                                Color.interactiveClear
                                RoundedRectangle(cornerRadius: 5, style: .continuous)
                                        .fill(isTouching ? activeColor : keyColor)
                                        .shadow(color: .shadowGray, radius: 0.5, y: 0.5)
                                        .padding(.vertical, 6)
                                        .padding(.horizontal, 3)
                                ZStack(alignment: .bottom) {
                                        Color.clear
                                        Text(verbatim: "分隔")
                                                .font(.keyFooter)
                                                .foregroundStyle(Color.secondary)
                                                .padding(.bottom, 8)
                                }
                                .opacity(context.inputStage.isBuffering ? 1 : 0)
                                RightKeyText(isABCMode: context.inputMethodMode.isABC, isBuffering: context.inputStage.isBuffering, needsInputModeSwitchKey: context.needsInputModeSwitchKey)
                        }
                }
                .frame(width: context.widthUnit, height: context.heightUnit)
                .contentShape(Rectangle())
                .gesture(DragGesture(minimumDistance: 0)
                        .updating($isTouching) { _, tapped, _ in
                                if !tapped {
                                        AudioFeedback.inputed()
                                        context.triggerHapticFeedback()
                                        tapped = true
                                }
                        }
                        .onChanged { state in
                                guard isLongPressing else { return }
                                let distance: CGFloat = -(state.translation.width)
                                guard distance > 0 else { return }
                                let step: CGFloat = context.widthUnit
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
                                        let symbols: [String] = responsiveSymbols(isABCMode: context.inputMethodMode.isABC, needsInputModeSwitchKey: context.needsInputModeSwitchKey)
                                        guard let selectedSymbol: String = symbols.fetch(selectedIndex) else { return }
                                        AudioFeedback.inputed()
                                        context.triggerSelectionHapticFeedback()
                                        context.operate(.input(selectedSymbol))
                                        selectedIndex = 0
                                        isLongPressing = false
                                } else {
                                        if context.inputMethodMode.isABC {
                                                context.operate(.input("."))
                                        } else {
                                                if context.inputStage.isBuffering {
                                                        context.operate(.separate)
                                                } else {
                                                        let symbol: String = context.needsInputModeSwitchKey ? "，" : "。"
                                                        context.operate(.input(symbol))
                                                }
                                        }
                                }
                         }
                )
                .onReceive(timer) { _ in
                        guard isTouching else { return }
                        if buffer > 3 {
                                let shouldPerformLongPress: Bool = !isLongPressing && !(context.inputStage.isBuffering)
                                if shouldPerformLongPress {
                                        isLongPressing = true
                                }
                        } else {
                                buffer += 1
                        }
                }
        }
}

private struct RightKeyText: View {

        init(isABCMode: Bool, isBuffering: Bool, needsInputModeSwitchKey: Bool) {
                self.symbol = {
                        if isABCMode {
                                return "."
                        } else if isBuffering {
                                return "'"
                        } else if needsInputModeSwitchKey {
                                return "，"
                        } else {
                                return "。"
                        }
                }()
        }

        private let symbol: String

        var body: some View {
                Text(verbatim: symbol)
        }
}
