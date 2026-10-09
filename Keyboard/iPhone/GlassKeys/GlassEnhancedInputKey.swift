import SwiftUI
import CommonExtensions
import CoreIME

/// A glass-styled input key supporting vertical pulls and long-press alternative selection.
///
/// Holding the key expands its alternatives; sliding selects an element and releasing commits it.
/// Drag tracking keeps the selector active when the finger moves outside the original button.
@available(iOS 26.0, *)
@available(iOSApplicationExtension 26.0, *)
struct GlassEnhancedInputKey: View {

        /// Creates a glass-styled key with primary content and selectable alternatives.
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

        /// Monotonic clock used to measure held time independently of task scheduling.
        private let clock = ContinuousClock()

        /// Button press state reported by PressButtonStyle; may end when sliding outside the key.
        @State private var isTouching: Bool = false

        /// Start of the current uninterrupted button press.
        @State private var pressStartedAt: ContinuousClock.Instant?

        /// Held time accumulated before sliding outside the button; resumes on reentry.
        @State private var heldDuration: Duration = .zero

        /// Indicates that the expanded alternative selector has been activated.
        @State private var isLongPressing: Bool = false

        /// Selected index in unit.members, independent of the visual expansion direction.
        @State private var selectedIndex: Int = 0

        /// Extra text selected by a vertical pull before long-press expansion.
        @State private var pulled: String? = nil

        /// Expansion occurs after 300 ms of held time, or 600 ms when a vertical pull selected text.
        private var longPressDeadline: ContinuousClock.Instant? {
                guard isTouching, isLongPressing.negative, let pressStartedAt else { return nil }
                let threshold: Duration = pulled.isNil ? .milliseconds(300) : .milliseconds(600)
                return pressStartedAt.advanced(by: threshold - heldDuration)
        }

        /// Includes the active press interval without counting time spent outside the button.
        private func elapsedPressDuration(at instant: ContinuousClock.Instant) -> Duration {
                heldDuration + (pressStartedAt?.duration(to: instant) ?? .zero)
        }

        var body: some View {
                let keyWidth: CGFloat = context.widthUnit * widthCoefficient
                let keyHeight: CGFloat = context.heightUnit
                let keyboardInterface = context.keyboardInterface
                let insets = keyboardInterface.keyShapeInsets
                let baseWidth: CGFloat = keyWidth - insets.horizontalTotal  // The visual width of the key shape in `KeyDisplayForm.normal` form
                let baseHeight: CGFloat = keyHeight - insets.verticalTotal  // The visual height of the key shape in `KeyDisplayForm.normal` form
                let previewBottomOffset = keyboardInterface.previewBottomOffset(keyWidth: keyWidth, keyHeight: keyHeight, insets: insets)
                let displayForm = KeyDisplayForm.responsive(isInteracting: isTouching, isLongPressing: isLongPressing, shouldPreview: Options.keyTextPreview)
                let shouldShowLowercaseKeys: Bool = Options.showLowercaseKeys && context.keyboardCase.isLowercased
                let textCase: Text.Case = shouldShowLowercaseKeys ? .lowercase : .uppercase
                let shouldAdjustKeyTextPosition: Bool = shouldShowLowercaseKeys && context.keyboardForm.isPrimary && (virtual?.isNumber.negative ?? true)
                let keyTextBottomInset: CGFloat = shouldAdjustKeyTextPosition ? 3 : 0
                let interactionDeadline = longPressDeadline
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
                                        Color.clear
                                                .glassEffect(.regular, in: ExpansiveBubbleShape(side: side, expansionCount: expansionCount))
                                                .overlay {
                                                        HStack(spacing: 0) {
                                                                ForEach(unit.members.enumerated(), id: \.element.text) { index, element in
                                                                        let elementIndex: Int = side.isLeading ? index : ((memberCount - 1) - index)
                                                                        let isSelected: Bool = selectedIndex == elementIndex
                                                                        ZStack {
                                                                                RoundedRectangle(cornerRadius: PresetConstant.keyCornerRadius)
                                                                                        .fill(isSelected ? Color.accentColor : Color.clear)
                                                                                ForEach(element.extras.enumerated(), id: \.element.text) { _, extra in
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
                                        Color.clear
                                                .glassEffect(.regular, in: BubbleShape())
                                                .overlay {
                                                        Text(verbatim: pulled ?? unit.primary.text)
                                                                .textCase(textCase)
                                                                .font(unit.primary.isTextSingular ? .title : .title3)
                                                                .padding(.bottom, previewBottomOffset)
                                                }
                                                .padding(insets)
                                case .normal, .reflecting:
                                        ZStack {
                                                Color.clear
                                                ForEach(unit.primary.extras.enumerated(), id: \.element.text) { _, extra in
                                                        ZStack(alignment: extra.alignment) {
                                                                Color.clear
                                                                Text(verbatim: extra.text)
                                                                        .textCase(textCase)
                                                                        .font(.labelCaption)
                                                                        .shallow()
                                                                        .padding(.horizontal, 2)
                                                        }
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
                }
                .buttonStyle(PressButtonStyle($isTouching) {
                        pressStartedAt = clock.now
                        AudioFeedback.inputed()
                        context.triggerHapticFeedback()
                })
                .onChange(of: isTouching) { _, touching in
                        guard touching.negative, let pressStartedAt else { return }
                        heldDuration += pressStartedAt.duration(to: clock.now)
                        self.pressStartedAt = nil
                }
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
                                        let isSatisfied: Bool = abs(distance) > 36 || (elapsedPressDuration(at: clock.now) >= .milliseconds(200) && abs(distance) > 24)
                                        guard isSatisfied else { return }
                                        if distance > 0 {
                                                // swipe from top to bottom
                                                let extra = unit.primary.extras.first(where: \.alignment.isTopEdge) ?? unit.primary.extras.first(where: \.alignment.isBottomEdge)
                                                if let text = extra?.text {
                                                        pulled = text
                                                }
                                        } else {
                                                // swipe from bottom to top
                                                let extra = unit.primary.extras.first(where: \.alignment.isBottomEdge) ?? unit.primary.extras.first(where: \.alignment.isTopEdge)
                                                if let text = extra?.text {
                                                        pulled = text
                                                }
                                        }
                                }
                        }
                        .onEnded { _ in
                                pressStartedAt = nil
                                heldDuration = .zero
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
                .task(id: interactionDeadline) {
                        guard let deadline = interactionDeadline else { return }
                        do {
                                try await clock.sleep(until: deadline)
                        } catch {
                                return
                        }
                        guard Task.isCancelled.negative else { return }
                        guard longPressDeadline == deadline else { return }
                        isLongPressing = true
                }
        }
}
