import SwiftUI
import CommonExtensions
import CoreIME

// For the letter V key representing the ü
struct PinyinSpecialInputKey: View {

        private let virtual: VirtualInputKey = .letterV
        private let unit: KeyUnit = KeyUnit(primary: KeyElement("v", header: "…"), members: [KeyElement("v"), KeyElement("…")])

        @EnvironmentObject private var context: KeyboardViewController
        @Environment(\.colorScheme) private var colorScheme

        @GestureState private var isTouching: Bool = false
        @State private var buffer: Int = 0
        @State private var isLongPressing: Bool = false
        @State private var selectedIndex: Int = 0
        @State private var pulled: String? = nil

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
                let activeColor: Color = shouldPreviewKey ? colorScheme.inputKeyColor : colorScheme.activeInputKeyColor
                let shouldShowLowercaseKeys: Bool = Options.showLowercaseKeys && context.keyboardCase.isLowercased
                let textCase: Text.Case = shouldShowLowercaseKeys ? .lowercase : .uppercase
                let keyTextBottomInset: CGFloat = shouldShowLowercaseKeys ? 3 : 0
                ZStack {
                        Color.interactiveClear
                        if isLongPressing {
                                let memberCount: Int = unit.members.count
                                let expansionCount: Int = memberCount - 1
                                let leadingOffset: CGFloat = baseWidth * CGFloat(expansionCount)
                                ExpansiveBubbleShape(keyLocale: .leading, expansionCount: expansionCount)
                                        .fill(colorScheme.previewBubbleColor)
                                        .shadow(color: .shadowGray, radius: 1)
                                        .overlay {
                                                HStack(spacing: 0) {
                                                        ForEach(unit.members.indices, id: \.self) { elementIndex in
                                                                let element: KeyElement = unit.members[elementIndex]
                                                                ZStack {
                                                                        RoundedRectangle(cornerRadius: PresetConstant.keyCornerRadius, style: .continuous)
                                                                                .fill(selectedIndex == elementIndex ? Color.accentColor : Color.clear)
                                                                        Text(verbatim: element.text)
                                                                                .textCase(textCase)
                                                                                .font(.title2)
                                                                                .foregroundStyle(selectedIndex == elementIndex ? Color.white : Color.primary)
                                                                }
                                                                .frame(maxWidth: .infinity)
                                                        }
                                                }
                                                .frame(width: baseWidth * CGFloat(memberCount), height: baseHeight)
                                                .padding(.bottom, previewBottomOffset)
                                                .padding(.leading, leadingOffset)
                                        }
                                        .padding(.vertical, verticalPadding)
                                        .padding(.horizontal, horizontalPadding)
                        } else if (isTouching && shouldPreviewKey) {
                                BubbleShape()
                                        .fill(colorScheme.previewBubbleColor)
                                        .shadow(color: .shadowGray, radius: 1)
                                        .overlay {
                                                Text(verbatim: pulled ?? unit.primary.text)
                                                        .textCase(textCase)
                                                        .font(.title)
                                                        .padding(.bottom, previewBottomOffset)
                                        }
                                        .padding(.vertical, verticalPadding)
                                        .padding(.horizontal, horizontalPadding)
                        } else {
                                RoundedRectangle(cornerRadius: PresetConstant.keyCornerRadius, style: .continuous)
                                        .fill(isTouching ? activeColor : colorScheme.inputKeyColor)
                                        .shadow(color: .shadowGray, radius: 0.5, y: 0.5)
                                        .padding(.vertical, verticalPadding)
                                        .padding(.horizontal, horizontalPadding)
                                ZStack(alignment: .topTrailing) {
                                        Color.clear
                                        Text(verbatim: "…")
                                                .textCase(textCase)
                                                .font(.keyFootnote)
                                                .shallow()
                                }
                                .padding(.vertical, verticalPadding)
                                .padding(.horizontal, horizontalPadding + 2)
                                ZStack(alignment: .bottomTrailing) {
                                        Color.clear
                                        Text(verbatim: "ü")
                                                .textCase(textCase)
                                                .font(.keyFootnote)
                                                .shallow()
                                }
                                .padding(.vertical, verticalPadding)
                                .padding(.horizontal, horizontalPadding + 2)
                                Text(verbatim: unit.primary.text)
                                        .textCase(textCase)
                                        .font(.letterCompact)
                                        .padding(.bottom, keyTextBottomInset)
                        }
                }
                .frame(width: keyWidth, height: keyHeight)
                .contentShape(.rect)
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
                                } else if (pulled == nil) {
                                        let distance: CGFloat = state.translation.height
                                        let isSatisfied: Bool = abs(distance) > 36 || (buffer > 1 && abs(distance) > 24)
                                        guard isSatisfied else { return }
                                        pulled = unit.primary.header
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
                                } else {
                                        context.handle(virtual)
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
