import SwiftUI
import CommonExtensions
import CoreIME

typealias EnhancedInputKey = ExpansibleInputKey

// TODO: Rename to EnhancedInputKey
struct ExpansibleInputKey: View {

        /// Create an ExpansibleInputKey
        /// - Parameters:
        ///   - keyLocale: Key location, left half (leading) or right half (trailing).
        ///   - widthUnitTimes: Times of widthUnit
        ///   - event: InputEvent
        ///   - keyModel: KeyModel
        init(keyLocale: HorizontalEdge, widthUnitTimes: CGFloat = 1, event: InputEvent? = nil, keyModel: KeyModel) {
                self.keyLocale = keyLocale
                self.widthUnitTimes = widthUnitTimes
                self.event = event
                self.keyModel = keyModel
        }

        private let keyLocale: HorizontalEdge
        private let widthUnitTimes: CGFloat
        private let event: InputEvent?
        private let keyModel: KeyModel

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

        var body: some View {
                let keyWidth: CGFloat = context.widthUnit * widthUnitTimes
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
                let shouldShowLowercaseKeys: Bool = Options.showLowercaseKeys && context.keyboardCase.isLowercased
                let textCase: Text.Case = shouldShowLowercaseKeys ? .lowercase : .uppercase
                let shouldAdjustKeyTextPosition: Bool = shouldShowLowercaseKeys && (context.keyboardForm == .alphabetic)
                let keyTextBottomInset: CGFloat = shouldAdjustKeyTextPosition ? 3 : 0
                ZStack {
                        Color.interactiveClear
                        if isLongPressing {
                                let memberCount: Int = keyModel.members.count
                                let expansionCount: Int = memberCount - 1
                                let offsetX: CGFloat = baseWidth * CGFloat(expansionCount)
                                let leadingOffset: CGFloat = keyLocale.isLeading ? offsetX : 0
                                let trailingOffset: CGFloat = keyLocale.isTrailing ? offsetX : 0
                                ExpansiveBubbleShape(keyLocale: keyLocale, expansionCount: expansionCount)
                                        .fill(keyPreviewColor)
                                        .shadow(color: .shadowGray, radius: 1)
                                        .overlay {
                                                HStack(spacing: 0) {
                                                        ForEach(keyModel.members.indices, id: \.self) { index in
                                                                let elementIndex: Int = keyLocale.isLeading ? index : ((memberCount - 1) - index)
                                                                let element: KeyElement = keyModel.members[elementIndex]
                                                                ZStack {
                                                                        RoundedRectangle(cornerRadius: PresetConstant.keyCornerRadius, style: .continuous)
                                                                                .fill(selectedIndex == elementIndex ? Color.accentColor : Color.clear)
                                                                        ZStack(alignment: .top) {
                                                                                Color.interactiveClear
                                                                                Text(verbatim: element.header ?? String.space)
                                                                                        .font(.keyFootnote)
                                                                                        .shallow()
                                                                        }
                                                                        ZStack(alignment: .bottom) {
                                                                                Color.interactiveClear
                                                                                Text(verbatim: element.footer ?? String.space)
                                                                                        .font(.keyFootnote)
                                                                                        .shallow()
                                                                        }
                                                                        Text(verbatim: element.text)
                                                                                .textCase(textCase)
                                                                                .font(element.isTextSingular ? .title2 : .title3)
                                                                                .foregroundStyle(selectedIndex == elementIndex ? Color.white : Color.primary)
                                                                }
                                                                .frame(maxWidth: .infinity)
                                                        }
                                                }
                                                .frame(width: baseWidth * CGFloat(memberCount), height: baseHeight)
                                                .padding(.bottom, previewBottomOffset)
                                                .padding(.leading, leadingOffset)
                                                .padding(.trailing, trailingOffset)
                                        }
                                        .padding(.vertical, verticalPadding)
                                        .padding(.horizontal, horizontalPadding)
                        } else if (isTouching && shouldPreviewKey) {
                                BubbleShape()
                                        .fill(keyPreviewColor)
                                        .shadow(color: .shadowGray, radius: 1)
                                        .overlay {
                                                Text(verbatim: pulled ?? keyModel.primary.text)
                                                        .textCase(textCase)
                                                        .font(keyModel.primary.isTextSingular ? .title : .title3)
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
                                        Text(verbatim: keyModel.primary.header ?? String.space)
                                                .textCase(textCase)
                                                .font(.keyFootnote)
                                                .shallow()
                                }
                                .padding(.vertical, verticalPadding)
                                .padding(.horizontal, horizontalPadding + 2)
                                ZStack(alignment: .bottomTrailing) {
                                        Color.clear
                                        Text(verbatim: keyModel.primary.footer ?? String.space)
                                                .textCase(textCase)
                                                .font(.keyFootnote)
                                                .shallow()
                                }
                                .padding(.vertical, verticalPadding)
                                .padding(.horizontal, horizontalPadding + 2)
                                Text(verbatim: keyModel.primary.text)
                                        .textCase(textCase)
                                        .font(keyModel.primary.isTextSingular ? .letterCompact : .dualLettersCompact)
                                        .padding(.bottom, keyTextBottomInset)
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
                                        let memberCount: Int = keyModel.members.count
                                        guard memberCount > 1 else { return }
                                        let distance: CGFloat = keyLocale.isLeading ? state.translation.width : -(state.translation.width)
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
                                } else if pulled == nil {
                                        let distance: CGFloat = state.translation.height
                                        if distance > 30 {
                                                // swipe from top to bottom
                                                pulled = keyModel.primary.header ?? keyModel.primary.footer
                                        } else if distance < -30 {
                                                // swipe from bottom to top
                                                pulled = keyModel.primary.footer ?? keyModel.primary.header
                                        }
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
                                        guard let selectedElement = keyModel.members.fetch(selectedIndex) else { return }
                                        AudioFeedback.inputed()
                                        context.triggerSelectionHapticFeedback()
                                        let text: String = context.keyboardCase.isLowercased ? selectedElement.text : selectedElement.text.uppercased()
                                        context.operate(.process(text))
                                } else if let pulledText = pulled {
                                        let text: String = context.keyboardCase.isLowercased ? pulledText : pulledText.uppercased()
                                        context.operate(.process(text))
                                } else if let event {
                                        context.handle(event)
                                } else {
                                        let text: String = context.keyboardCase.isLowercased ? keyModel.primary.text : keyModel.primary.text.uppercased()
                                        context.operate(.process(text))
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
