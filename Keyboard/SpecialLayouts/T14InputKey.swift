import SwiftUI
import Combine
import CommonExtensions
import CoreIME

struct T14InputKey: View {

        /// Create a T14InputKey
        /// - Parameters:
        ///   - side: Key location, left half screen (leading) or right half screen (trailing).
        ///   - coefficient: Multiplier to the `widthUnit`
        ///   - virtual: VirtualInputKey
        ///   - unit: KeyUnit
        init(side: HorizontalEdge, coefficient: CGFloat = 2, virtual: VirtualInputKey? = nil, unit: KeyUnit) {
                self.side = side
                self.coefficient = coefficient
                self.virtual = virtual
                self.unit = unit
        }

        private let side: HorizontalEdge
        private let coefficient: CGFloat
        private let virtual: VirtualInputKey?
        private let unit: KeyModel

        @EnvironmentObject private var context: KeyboardViewController
        @Environment(\.colorScheme) private var colorScheme

        @GestureState private var isTouching: Bool = false
        private let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
        @State private var buffer: Int = 0
        @State private var isLongPressing: Bool = false
        @State private var selectedIndex: Int = 0
        @State private var pulled: String? = nil

        var body: some View {
                let keyWidth: CGFloat = context.widthUnit * coefficient
                let keyHeight: CGFloat = context.heightUnit
                let isPhoneLandscape: Bool = context.keyboardInterface.isPhoneLandscape
                let verticalPadding: CGFloat = isPhoneLandscape ? 3 : 6
                let horizontalPadding: CGFloat = isPhoneLandscape ? 6 : 3
                let baseWidth: CGFloat = keyWidth - (horizontalPadding * 2)
                let baseHeight: CGFloat = keyHeight - (verticalPadding * 2)
                let shapeHeight: CGFloat = isPhoneLandscape ? (baseHeight / (2 / 6.0)) : baseHeight / ((2.5 / 6.0))
                let curveHeight: CGFloat = isPhoneLandscape ? (shapeHeight / 3.0) : (shapeHeight / 6.0)
                let previewBottomOffset: CGFloat = (baseHeight * 2) + (curveHeight * 1.5)
                let shouldShowLowercaseKeys: Bool = Options.showLowercaseKeys && context.keyboardCase.isLowercased
                let textCase: Text.Case = shouldShowLowercaseKeys ? .lowercase : .uppercase
                let shouldAdjustKeyTextPosition: Bool = shouldShowLowercaseKeys && (context.keyboardForm == .alphabetic) && (virtual?.isNumber.negative ?? true)
                let keyTextBottomInset: CGFloat = shouldAdjustKeyTextPosition ? 3 : 0
                ZStack {
                        Color.interactiveClear
                        if isLongPressing {
                                let memberCount: Int = unit.members.count
                                let expansionCount: Int = memberCount - 1
                                let offsetX: CGFloat = baseWidth * CGFloat(expansionCount)
                                let leadingOffset: CGFloat = side.isLeading ? offsetX : 0
                                let trailingOffset: CGFloat = side.isTrailing ? offsetX : 0
                                ExpansiveBubbleShape(keyLocale: side, expansionCount: expansionCount)
                                        .fill(colorScheme.previewBubbleColor)
                                        .shadow(color: .shadowGray, radius: 1)
                                        .overlay {
                                                HStack(spacing: 0) {
                                                        ForEach(unit.members.indices, id: \.self) { index in
                                                                let elementIndex: Int = side.isLeading ? index : ((memberCount - 1) - index)
                                                                let element: KeyElement = unit.members[elementIndex]
                                                                ZStack {
                                                                        RoundedRectangle(cornerRadius: PresetConstant.keyCornerRadius, style: .continuous)
                                                                                .fill(selectedIndex == elementIndex ? Color.accentColor : Color.clear)
                                                                        ForEach(element.extras.indices, id: \.self) { extraIndex in
                                                                                let extra = element.extras[extraIndex]
                                                                                ZStack(alignment: extra.alignment) {
                                                                                        Color.clear
                                                                                        Text(verbatim: extra.text)
                                                                                                .font(.keyFootnote)
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
                                        .padding(.vertical, verticalPadding)
                                        .padding(.horizontal, horizontalPadding)
                        } else {
                                RoundedRectangle(cornerRadius: PresetConstant.keyCornerRadius, style: .continuous)
                                        .fill(isTouching ? colorScheme.activeInputKeyColor : colorScheme.inputKeyColor)
                                        .shadow(color: .shadowGray, radius: 0.5, y: 0.5)
                                        .padding(.vertical, verticalPadding)
                                        .padding(.horizontal, horizontalPadding)
                                ForEach(unit.primary.extras.indices, id: \.self) { index in
                                        let extra = unit.primary.extras[index]
                                        ZStack(alignment: extra.alignment) {
                                                Color.clear
                                                Text(verbatim: extra.text)
                                                        .textCase(textCase)
                                                        .font(.largerKeyFootnote)
                                                        .shallow()
                                        }
                                        .padding(.vertical, verticalPadding + 1)
                                        .padding(.horizontal, horizontalPadding + 3)
                                }
                                if unit.primary.isTextSingular {
                                        Text(verbatim: unit.primary.text)
                                                .textCase(textCase)
                                                .font(.letterCompact)
                                                .padding(.bottom, keyTextBottomInset)
                                } else {
                                        Text(verbatim: unit.primary.text.spaceSeparated())
                                                .textCase(textCase)
                                                .font(.adjustedLetterCompact)
                                                .padding(.bottom, keyTextBottomInset)
                                }
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
                                                pulled = unit.primary.header ?? unit.primary.footer
                                        } else {
                                                // swipe from bottom to top
                                                pulled = unit.primary.footer ?? unit.primary.header
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
