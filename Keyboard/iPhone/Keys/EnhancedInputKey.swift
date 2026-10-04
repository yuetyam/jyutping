import SwiftUI
import CommonExtensions
import CoreIME

/// An input key supporting vertical pulls and long-press alternative selection.
///
/// Holding the key expands its alternatives; sliding selects an element and releasing commits it.
/// Drag tracking keeps the selector active when the finger moves outside the original button.
struct EnhancedInputKey: View {

        // TODO: Mark this initializer as deprecated
        init(keyLocale: HorizontalEdge, widthUnitTimes: CGFloat = 1, event: VirtualInputKey? = nil, keyModel: KeyModel) {
                self.side = keyLocale
                self.widthCoefficient = widthUnitTimes
                self.virtual = event
                self.unit = keyModel
        }

        /// Creates an EnhancedInputKey with primary content and selectable alternatives.
        ///
        /// - Parameters:
        ///   - side: Key location in the leading or trailing half of the keyboard. Alternatives expand toward the opposite side.
        ///   - widthCoefficient: Key width as a multiple of the keyboard's width unit.
        ///   - virtual: Optional event handled on an ordinary release. When nil, the primary text is processed instead.
        ///   - unit: Primary content, vertical-pull extras, and alternatives for long-press selection.
        init(side: HorizontalEdge, widthCoefficient: CGFloat = 1, virtual: VirtualInputKey? = nil, unit: KeyUnit) {
                self.side = side
                self.widthCoefficient = widthCoefficient
                self.virtual = virtual
                self.unit = unit
        }

        /// Determines the direction of expansion and slide selection.
        private let side: HorizontalEdge

        /// Key width as a multiple of the keyboard's width unit.
        private let widthCoefficient: CGFloat

        /// Event handled on release when no alternative or pulled text is selected.
        private let virtual: VirtualInputKey?

        /// Primary key content and alternatives shown in the expanded selector.
        private let unit: KeyUnit


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

        /// Selected index in unit.members, independent of the visual expansion direction.
        @State private var selectedIndex: Int = 0

        /// Extra text selected by a vertical pull before long-press expansion.
        @State private var pulled: String? = nil

        var body: some View {
                let keyWidth: CGFloat = context.widthUnit * widthCoefficient
                let keyHeight: CGFloat = context.heightUnit
                let keyboardInterface = context.keyboardInterface
                let insets = keyboardInterface.keyShapeInsets
                let baseWidth: CGFloat = keyWidth - insets.horizontalTotal  // The visual width of the key shape in `KeyDisplayForm.normal` form
                let baseHeight: CGFloat = keyHeight - insets.verticalTotal  // The visual height of the key shape in `KeyDisplayForm.normal` form
                let previewBottomOffset = keyboardInterface.previewBottomOffset(keyWidth: keyWidth, keyHeight: keyHeight, insets: insets)
                let shouldPreviewKey: Bool = Options.keyTextPreview
                let activeColor: Color = shouldPreviewKey ? colorScheme.inputKeyColor : colorScheme.activeInputKeyColor
                let displayForm = KeyDisplayForm.responsive(isInteracting: isTouching, isLongPressing: isLongPressing, shouldPreview: shouldPreviewKey)
                let shouldShowLowercaseKeys: Bool = Options.showLowercaseKeys && context.keyboardCase.isLowercased
                let textCase: Text.Case = shouldShowLowercaseKeys ? .lowercase : .uppercase
                let shouldAdjustKeyTextPosition: Bool = shouldShowLowercaseKeys && context.keyboardForm.isPrimary && (virtual?.isNumber.negative ?? true)
                let keyTextBottomInset: CGFloat = shouldAdjustKeyTextPosition ? 3 : 0
                Button(action: {}) {
                        ZStack {
                                Color.interactiveClear
                                switch displayForm {
                                case .expanding:
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
                                                                        let isSelected: Bool = selectedIndex == elementIndex
                                                                        ZStack {
                                                                                RoundedRectangle(cornerRadius: PresetConstant.keyCornerRadius)
                                                                                        .fill(isSelected ? Color.accentColor : Color.clear)
                                                                                ZStack(alignment: .top) {
                                                                                        Color.interactiveClear
                                                                                        Text(verbatim: element.header ?? String.space)
                                                                                                .font(.labelCaption)
                                                                                                .shallow()
                                                                                }
                                                                                ZStack(alignment: .bottom) {
                                                                                        Color.interactiveClear
                                                                                        Text(verbatim: element.footer ?? String.space)
                                                                                                .font(.labelCaption)
                                                                                                .shallow()
                                                                                }
                                                                                Text(verbatim: element.text)
                                                                                        .textCase(textCase)
                                                                                        .font(element.isTextSingular ? .title2 : .title3)
                                                                                        .foregroundStyle(isSelected ? Color.white : Color.primary)
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
                                case .previewing:
                                        BubbleShape()
                                                .fill(colorScheme.previewBubbleColor)
                                                .shadow(color: .shadowGray, radius: 1)
                                                .overlay {
                                                        Text(verbatim: pulled ?? unit.primary.text)
                                                                .textCase(textCase)
                                                                .font(unit.primary.isTextSingular ? .title : .title3)
                                                                .padding(.bottom, previewBottomOffset)
                                                }
                                                .padding(insets)
                                case .normal, .reflecting:
                                        RoundedRectangle(cornerRadius: PresetConstant.keyCornerRadius)
                                                .fill(isTouching ? activeColor : colorScheme.inputKeyColor)
                                                .shadow(color: .shadowGray, radius: 0.5, y: 0.5)
                                                .padding(insets)
                                        if let header = unit.primary.header {
                                                ZStack(alignment: .topTrailing) {
                                                        Color.clear
                                                        Text(verbatim: header)
                                                                .textCase(textCase)
                                                                .font(.labelCaption)
                                                                .shallow()
                                                }
                                                .padding(insets.plused(horizontal: 2))
                                        }
                                        if let footer = unit.primary.footer {
                                                ZStack(alignment: .bottomTrailing) {
                                                        Color.clear
                                                        Text(verbatim: footer)
                                                                .textCase(textCase)
                                                                .font(.labelCaption)
                                                                .shallow()
                                                }
                                                .padding(insets.plused(horizontal: 2))
                                        }
                                        ForEach(unit.primary.extras.indices, id: \.self) { index in
                                                let extra = unit.primary.extras[index]
                                                ZStack(alignment: extra.alignment) {
                                                        Color.clear
                                                        Text(verbatim: extra.text)
                                                                .textCase(textCase)
                                                                .font(.labelCaption)
                                                                .shallow()
                                                }
                                                .padding(insets.plused(horizontal: 2))
                                        }
                                        Text(verbatim: unit.primary.text)
                                                .textCase(textCase)
                                                .font(unit.primary.isTextSingular ? .letterCompact : .dualLettersCompact)
                                                .padding(.bottom, keyTextBottomInset)
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
                                } else if pulled.isNil {
                                        let distance: CGFloat = state.translation.height
                                        let isSatisfied: Bool = abs(distance) > 36 || (buffer > 1 && abs(distance) > 24)
                                        guard isSatisfied else { return }
                                        if distance > 0 {
                                                // swipe from top to bottom
                                                pulled = unit.primary.header ?? unit.primary.footer ?? unit.primary.extras.first(where: \.alignment.isTopEdge)?.text ?? unit.primary.extras.first(where: \.alignment.isBottomEdge)?.text
                                        } else {
                                                // swipe from bottom to top
                                                pulled = unit.primary.footer ?? unit.primary.header ?? unit.primary.extras.first(where: \.alignment.isBottomEdge)?.text ?? unit.primary.extras.first(where: \.alignment.isTopEdge)?.text
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
                .task(id: isTouching) {
                        guard isTouching else { return }
                        while isLongPressing.negative {
                                try? await Task.sleep(for: .milliseconds(100))
                                guard Task.isCancelled.negative else { break }
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
