import SwiftUI
import CommonExtensions
import CoreIME

@available(iOS 26.0, *)
@available(iOSApplicationExtension 26.0, *)
struct GlassEnhancedInputKey: View {

        /// Create a GlassEnhancedInputKey
        /// - Parameters:
        ///   - side: Key location, left half screen (leading) or right half screen (trailing).
        ///   - widthCoefficient: Times of widthUnit
        ///   - virtual: VirtualInputKey
        ///   - unit: KeyUnit
        init(side: HorizontalEdge, widthCoefficient: CGFloat = 1, virtual: VirtualInputKey? = nil, unit: KeyUnit) {
                self.side = side
                self.widthCoefficient = widthCoefficient
                self.virtual = virtual
                self.unit = unit
        }
        private let side: HorizontalEdge
        private let widthCoefficient: CGFloat
        private let virtual: VirtualInputKey?
        private let unit: KeyModel

        @EnvironmentObject private var context: KeyboardViewController
        @Environment(\.colorScheme) private var colorScheme

        @GestureState private var isTouching: Bool = false
        @State private var buffer: Int = 0
        @State private var isLongPressing: Bool = false
        @State private var selectedIndex: Int = 0
        @State private var pulled: String? = nil

        var body: some View {
                let keyWidth: CGFloat = context.widthUnit * widthCoefficient
                let keyHeight: CGFloat = context.heightUnit
                let keyboardInterface = context.keyboardInterface
                let insets = keyboardInterface.keyShapeInsets
                let baseWidth: CGFloat = keyWidth - (insets.leading + insets.trailing)
                let baseHeight: CGFloat = keyHeight - (insets.top + insets.bottom)
                let previewBottomOffset = keyboardInterface.previewBottomOffset(keyWidth: keyWidth, keyHeight: keyHeight, insets: insets)
                let displayForm = KeyDisplayForm.responsive(isInteracting: isTouching, isLongPressing: isLongPressing, shouldPreview: Options.keyTextPreview)
                let shouldShowLowercaseKeys: Bool = Options.showLowercaseKeys && context.keyboardCase.isLowercased
                let textCase: Text.Case = shouldShowLowercaseKeys ? .lowercase : .uppercase
                let shouldAdjustKeyTextPosition: Bool = shouldShowLowercaseKeys && context.keyboardForm.isPrimary && (virtual?.isNumber.negative ?? true)
                let keyTextBottomInset: CGFloat = shouldAdjustKeyTextPosition ? 3 : 0
                ZStack {
                        Color.interactiveClear
                        if displayForm.isExpanding {
                                let memberCount: Int = unit.members.count
                                let expansionCount: Int = memberCount - 1
                                let offsetX: CGFloat = baseWidth * CGFloat(expansionCount)
                                let leadingOffset: CGFloat = side.isLeading ? offsetX : 0
                                let trailingOffset: CGFloat = side.isTrailing ? offsetX : 0
                                Color.clear
                                        .glassEffect(.regular, in: ExpansiveBubbleShape(keyLocale: side, expansionCount: expansionCount))
                                        .overlay {
                                                HStack(spacing: 0) {
                                                        ForEach(unit.members.indices, id: \.self) { index in
                                                                let elementIndex: Int = side.isLeading ? index : ((memberCount - 1) - index)
                                                                let element: KeyElement = unit.members[elementIndex]
                                                                ZStack {
                                                                        RoundedRectangle(cornerRadius: PresetConstant.keyCornerRadius)
                                                                                .fill(selectedIndex == elementIndex ? Color.accentColor : Color.clear)
                                                                        ForEach(element.extras.indices, id: \.self) { extraIndex in
                                                                                let extra = element.extras[extraIndex]
                                                                                ZStack(alignment: extra.alignment) {
                                                                                        Color.clear
                                                                                        Text(verbatim: extra.text)
                                                                                                .font(.labelCaption)
                                                                                                .shallow()
                                                                                }
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
                                        .padding(insets)
                        } else if displayForm.isPreviewing {
                                Color.clear
                                        .glassEffect(.regular, in: BubbleShape())
                                        .overlay {
                                                Text(verbatim: pulled ?? unit.primary.text)
                                                        .textCase(textCase)
                                                        .font(unit.primary.isTextSingular ? .title : .title3)
                                                        .padding(.bottom, previewBottomOffset)
                                        }
                                        .padding(insets)
                        } else {
                                ZStack {
                                        Color.clear
                                        ForEach(unit.primary.extras.indices, id: \.self) { index in
                                                let extra = unit.primary.extras[index]
                                                ZStack(alignment: extra.alignment) {
                                                        Color.clear
                                                        Text(verbatim: extra.text)
                                                                .textCase(textCase)
                                                                .font(.labelCaption)
                                                                .shallow()
                                                }
                                                .padding(insets.adjusted(horizontal: 2))
                                        }
                                        Text(verbatim: unit.primary.text)
                                                .textCase(textCase)
                                                .font(unit.primary.isTextSingular ? .letterCompact : .dualLettersCompact)
                                                .padding(.bottom, keyTextBottomInset)
                                }
                                .glassEffect(displayForm.isReflecting ? .regular : .clear, in: .rect(cornerRadius: PresetConstant.keyCornerRadius))
                                .shadow(color: displayForm.isReflecting ? colorScheme.glassShadow : Color.clear, radius: 0.5)
                                .padding(displayForm.isReflecting ? insets.plused(-2) : insets)
                        }
                }
                .frame(width: keyWidth, height: keyHeight)
                .contentShape(.rect)
                .gesture(DragGesture(minimumDistance: 0)
                        .updating($isTouching) { _, isTouchBegan, _ in
                                if isTouchBegan.negative {
                                        isTouchBegan = true
                                        AudioFeedback.inputed()
                                        context.triggerHapticFeedback()
                                }
                        }
                        .onChanged { state in
                                if isLongPressing {
                                        let memberCount: Int = unit.members.count
                                        guard memberCount > 1 else { return }
                                        let distance: CGFloat = side.isLeading ? state.translation.width : -(state.translation.width)
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
                                } else if (pulled == nil) {
                                        let distance: CGFloat = state.translation.height
                                        let isSatisfied: Bool = abs(distance) > 36 || (buffer > 1 && abs(distance) > 24)
                                        guard isSatisfied else { return }
                                        if distance > 0 {
                                                // swipe from top to bottom
                                                let extra = unit.primary.extras.first(where: \.alignment.isTopEdge) ?? unit.primary.extras.first(where: \.alignment.isBottomEdge)
                                                pulled = extra?.text
                                        } else {
                                                // swipe from bottom to top
                                                let extra = unit.primary.extras.first(where: \.alignment.isBottomEdge) ?? unit.primary.extras.first(where: \.alignment.isTopEdge)
                                                pulled = extra?.text
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
                                        guard let selectedElement = unit.members.fetch(selectedIndex) else { return }
                                        AudioFeedback.inputed()
                                        context.triggerSelectionHapticFeedback()
                                        let text: String = context.keyboardCase.isLowercased ? selectedElement.text : selectedElement.text.uppercased()
                                        context.operate(.process(text))
                                } else if let pulledText = pulled {
                                        let text: String = context.keyboardCase.isLowercased ? pulledText : pulledText.uppercased()
                                        context.operate(.process(text))
                                } else if let virtual {
                                        context.handle(virtual)
                                } else {
                                        let text: String = context.keyboardCase.isLowercased ? unit.primary.text : unit.primary.text.uppercased()
                                        context.operate(.process(text))
                                }
                        }
                )
                .task {
                        while Task.isCancelled.negative {
                                try? await Task.sleep(for: .milliseconds(100)) // 0.1s
                                if isTouching {
                                        if isLongPressing.negative {
                                                let shouldTriggerLongPress: Bool = buffer > 6 || (buffer > 3 && pulled == nil)
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
