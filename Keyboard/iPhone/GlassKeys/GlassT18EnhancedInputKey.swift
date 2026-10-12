import SwiftUI
import CommonExtensions
import CoreIME

/// A glass-styled input key for eighteen- and nineteen-key layouts supporting vertical pulls and long-press alternative selection.
///
/// A primary element can represent a single character or combined letters, such as `io` or `sd`.
/// Combined letters are spaced for display without changing the text sent to the controller.
/// Pressing provides audio and haptic feedback; releasing commits the ordinary input, pulled text, or selected alternative.
/// Drag tracking keeps the expanded selector active when the finger moves outside the original button.
@available(iOS 26.0, *)
@available(iOSApplicationExtension 26.0, *)
struct GlassT18EnhancedInputKey: View {

        /// Creates a glass-styled key with primary content and selectable alternatives.
        ///
        /// The primary element supplies the label. Its top- and bottom-aligned extras also supply vertical-pull input.
        /// Expanded choices follow the order in `unit.members`, with the first member initially selected.
        ///
        /// - Parameters:
        ///   - side: Key location in the leading or trailing half of the keyboard. Alternatives expand toward the opposite side.
        ///   - coefficient: Key width as a multiple of the keyboard's width unit. Defaults to 1.42 for eighteen- and nineteen-key layouts.
        ///   - virtual: Optional event handled on an ordinary release. When nil, the primary text is processed instead.
        ///   - unit: Primary content, vertical-pull extras, and alternatives for long-press selection.
        init(side: HorizontalEdge, coefficient: CGFloat = 1.42, virtual: VirtualInputKey? = nil, unit: KeyUnit) {
                self.side = side
                self.coefficient = coefficient
                self.virtual = virtual
                self.unit = unit
                self.isPrimaryTextSingular = unit.primary.isTextSingular
        }

        /// Determines the direction of expansion and slide selection; trailing-side keys reverse the visual member order.
        private let side: HorizontalEdge

        /// Key width as a multiple of the keyboard's width unit.
        private let coefficient: CGFloat

        /// Event handled on release when no alternative or pulled text is selected.
        private let virtual: VirtualInputKey?

        /// Primary label, vertical-pull extras, and ordered alternatives shown in the expanded selector.
        private let unit: KeyUnit

        /// Whether the primary text is one character, determining its font and whether to insert display-only spacing.
        private let isPrimaryTextSingular: Bool

        /// Supplies keyboard geometry, case, form, feedback, and input handlers.
        @EnvironmentObject private var context: KeyboardViewController

        /// Retrieves the current system color scheme (light or dark mode) from the environment.
        @Environment(\.colorScheme) private var colorScheme

        /// Monotonic clock used to measure held time independently of task scheduling.
        private let clock = ContinuousClock()

        /// Button press state reported by PressButtonStyle; may end when sliding outside the key.
        @State private var isTouching: Bool = false

        /// Start of the current uninterrupted button press; cleared when the button stops reporting a press.
        @State private var pressStartedAt: ContinuousClock.Instant?

        /// Held time accumulated across press intervals, excluding time outside the button and resetting when the drag ends.
        @State private var heldDuration: Duration = .zero

        /// Indicates that the expanded alternative selector has been activated.
        @State private var isLongPressing: Bool = false

        /// Selected index in `unit.members`, independent of the visual expansion direction; starts at the first member.
        @State private var selectedIndex: Int = 0

        /// Extra text captured by the first qualifying vertical pull before expansion; retained until the drag ends.
        @State private var pulled: String? = nil

        /// Expansion occurs after 300 ms of held time, or 600 ms when a vertical pull selected text.
        ///
        /// Returns nil while the button is not pressed or the selector is already expanded.
        /// Subtracting accumulated held time lets the countdown resume when the finger reenters the button.
        private var longPressDeadline: ContinuousClock.Instant? {
                guard isTouching, isLongPressing.negative, let pressStartedAt else { return nil }
                let threshold: Duration = pulled.isNil ? .milliseconds(300) : .milliseconds(600)
                return pressStartedAt.advanced(by: threshold - heldDuration)
        }

        /// Includes the active press interval without counting time spent outside the button.
        ///
        /// - Parameter instant: Monotonic time at which to measure the accumulated press duration.
        /// - Returns: Completed press intervals plus the duration of the current interval, if any.
        private func elapsedPressDuration(at instant: ContinuousClock.Instant) -> Duration {
                heldDuration + (pressStartedAt?.duration(to: instant) ?? .zero)
        }

        /// Renders the primary glass key or its expanded alternative selector using the current keyboard geometry.
        ///
        /// Ordinary pressing reflects and enlarges the key without a separate preview bubble.
        /// Labels follow the lowercase-key preference and keyboard case; lowercase primary-layout text receives a bottom inset unless the virtual key is numeric.
        ///
        /// A vertical pull selects an extra after moving more than 36 points, or more than 24 points after 200 ms of held time.
        /// Downward pulls prefer top-aligned extras; upward pulls prefer bottom-aligned extras, falling back to the opposite edge when needed.
        /// Once expanded, horizontal dragging selects a member in the expansion direction.
        ///
        /// On release, an expanded member takes precedence over pulled text, followed by the optional virtual event and then the primary text.
        /// Text processed directly follows the keyboard case; display-only spacing is never committed.
        /// Expanded selection adds audio and selection haptic feedback, and every drag end resets the interaction state.
        /// A cancellable deadline task checks that its deadline is still current before activating expansion.
        var body: some View {
                let keyWidth: CGFloat = context.widthUnit * coefficient
                let keyHeight: CGFloat = context.heightUnit
                let keyboardInterface = context.keyboardInterface
                let insets = keyboardInterface.keyShapeInsets
                let baseWidth: CGFloat = keyWidth - insets.horizontalTotal  // The visual width of the key shape in `KeyDisplayForm.normal` form
                let baseHeight: CGFloat = keyHeight - insets.verticalTotal  // The visual height of the key shape in `KeyDisplayForm.normal` form
                let previewBottomOffset = keyboardInterface.previewBottomOffset(keyWidth: keyWidth, keyHeight: keyHeight, insets: insets)
                let displayForm = KeyDisplayForm.responsive(isInteracting: isTouching, isLongPressing: isLongPressing, shouldPreview: false)
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
                                                                ForEach(unit.members.enumerated(), id: \.element.text) { index, member in
                                                                        let elementIndex: Int = side.isLeading ? index : ((memberCount - 1) - index)
                                                                        let element = side.isLeading ? member : unit.members[elementIndex]
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
                                case .normal, .reflecting, .previewing:
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
                                                Text(verbatim: isPrimaryTextSingular ? unit.primary.text : unit.primary.text.spaceSeparated())
                                                        .textCase(textCase)
                                                        .font(isPrimaryTextSingular ? .letterCompact : .adjustedLetterCompact)
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
