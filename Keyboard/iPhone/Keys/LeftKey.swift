import SwiftUI
import CommonExtensions
import CoreIME

/// A Cantonese comma key supporting vertical pulls and long-press punctuation selection.
///
/// Holding the key expands its alternatives; sliding selects an element and releasing commits it.
/// Drag tracking keeps the selector active when the finger moves outside the original button.
/// While composing, ordinary input inserts an apostrophe; pulls and alternative expansion are disabled.
struct LeftKey: View {

        /// Keyboard properties and handlers.
        @EnvironmentObject private var context: KeyboardViewController

        /// Retrieves the current system color scheme (light or dark mode) from the environment.
        @Environment(\.colorScheme) private var colorScheme

        /// Button press state reported by PressButtonStyle; may end when sliding outside the key.
        @State private var isTouching: Bool = false

        /// Number of elapsed 100 ms checkpoints used for pull and long-press thresholds.
        @State private var buffer: Int = 0

        /// Indicates that the expanded alternative selector has been activated.
        @State private var isLongPressing: Bool = false

        /// Selected index in elements, independent of the visual expansion direction.
        @State private var selectedIndex: Int = 0

        /// Extra text selected by a vertical pull before long-press expansion.
        @State private var pulled: String? = nil

        /// Punctuation alternatives and their labels shown in the expanded selector.
        private let elements: [KeyElement] = [
                KeyElement("，"),
                KeyElement("！"),
                KeyElement("？"),
                KeyElement("、"),
                KeyElement(",", extras: [.init("英文", alignment: .top)])
        ]

        /// Extra punctuation selected by a vertical pull when symbol input is enabled.
        private let headerText: String = "！"

        var body: some View {
                let keyWidth: CGFloat = context.widthUnit
                let keyHeight: CGFloat = context.heightUnit
                let keyboardInterface = context.keyboardInterface
                let insets = keyboardInterface.keyShapeInsets
                let baseWidth: CGFloat = keyWidth - insets.horizontalTotal
                let baseHeight: CGFloat = keyHeight - insets.verticalTotal
                let previewBottomOffset: CGFloat = keyboardInterface.previewBottomOffset(keyWidth: keyWidth, keyHeight: keyHeight, insets: insets)
                let shouldPreviewKey: Bool = Options.keyTextPreview
                let activeColor: Color = shouldPreviewKey ? colorScheme.inputKeyColor : colorScheme.activeInputKeyColor
                let displayForm = KeyDisplayForm.responsive(isInteracting: isTouching, isLongPressing: isLongPressing, shouldPreview: shouldPreviewKey)
                let shouldShowExtraSymbols: Bool = Options.inputKeyStyle.isSymbolApplied
                Button(action: {}) {
                        ZStack {
                                Color.interactiveClear
                                switch displayForm {
                                case .expanding:
                                        let symbolCount: Int = elements.count
                                        let expansionCount: Int = symbolCount - 1
                                        let leadingOffset: CGFloat = baseWidth * CGFloat(expansionCount)
                                        ExpansiveBubbleShape(side: .leading, expansionCount: expansionCount)
                                                .fill(colorScheme.previewBubbleColor)
                                                .shadow(color: .shadowGray, radius: 1)
                                                .overlay {
                                                        HStack(spacing: 0) {
                                                                ForEach(elements.indices, id: \.self) { index in
                                                                        let element = elements[index]
                                                                        let isSelected: Bool = selectedIndex == index
                                                                        ZStack {
                                                                                RoundedRectangle(cornerRadius: PresetConstant.keyCornerRadius)
                                                                                        .fill(isSelected ? Color.accentColor : Color.clear)
                                                                                ZStack(alignment: .top) {
                                                                                        Color.interactiveClear
                                                                                        Text(verbatim: element.extras.first(where: \.alignment.isTopEdge)?.text ?? String.space)
                                                                                                .font(.labelCaption)
                                                                                                .shallow()
                                                                                }
                                                                                Text(verbatim: element.text)
                                                                                        .font(.title2)
                                                                                        .foregroundStyle(isSelected ? Color.white : Color.primary)
                                                                        }
                                                                        .frame(maxWidth: .infinity)
                                                                }
                                                        }
                                                        .frame(width: baseWidth * CGFloat(symbolCount), height: baseHeight)
                                                        .padding(.bottom, previewBottomOffset)
                                                        .padding(.leading, leadingOffset)
                                                }
                                                .padding(insets)
                                case .previewing:
                                        BubbleShape()
                                                .fill(colorScheme.previewBubbleColor)
                                                .shadow(color: .shadowGray, radius: 1)
                                                .overlay {
                                                        Text(verbatim: pulled ?? (context.inputStage.isBuffering ? String.apostrophe : String.cantoneseComma))
                                                                .font(.largeTitle)
                                                                .padding(.bottom, previewBottomOffset)
                                                }
                                                .padding(insets)
                                case .normal, .reflecting:
                                        RoundedRectangle(cornerRadius: PresetConstant.keyCornerRadius)
                                                .fill(isTouching ? activeColor : colorScheme.inputKeyColor)
                                                .shadow(color: .shadowGray, radius: 0.5, y: 0.5)
                                                .padding(insets)
                                        ZStack(alignment: .topTrailing) {
                                                Color.clear
                                                Text(verbatim: headerText).font(.labelCaption)
                                        }
                                        .padding(insets.plused(horizontal: 2))
                                        .opacity((shouldShowExtraSymbols && context.inputStage.isBuffering.negative) ? 0.5 : 0)
                                        ZStack(alignment: .bottom) {
                                                Color.clear
                                                Text(verbatim: PresetConstant.separate).font(.labelCaption)
                                        }
                                        .padding(insets.plused(vertical: 2))
                                        .opacity(context.inputStage.isBuffering ? 0.5 : 0)
                                        Text(verbatim: context.inputStage.isBuffering ? String.apostrophe : String.cantoneseComma).font(.letterCompact)
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
                                        context.operate(.input(String.cantoneseComma))
                                }
                        }
                )
                .task(id: isTouching) {
                        guard isTouching else { return }
                        while isLongPressing.negative {
                                try? await Task.sleep(for: .milliseconds(100))
                                guard Task.isCancelled.negative else { break }
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
