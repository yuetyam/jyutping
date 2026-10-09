import SwiftUI
import CommonExtensions
import CoreIME

/// A glass-styled Cantonese period key supporting vertical pulls and long-press punctuation selection.
///
/// Holding the key expands its alternatives; sliding selects an element and releasing commits it.
/// Drag tracking keeps the selector active when the finger moves outside the original button.
/// While composing, ordinary input inserts an apostrophe; pulls and alternative expansion are disabled.
@available(iOS 26.0, *)
@available(iOSApplicationExtension 26.0, *)
struct GlassRightKey: View {

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

        /// Selected index in elements, independent of the visual expansion direction.
        @State private var selectedIndex: Int = 0

        /// Extra text selected by a vertical pull before long-press expansion.
        @State private var pulled: String? = nil

        /// Punctuation alternatives and their labels shown in the expanded selector.
        private let elements: [KeyElement] = [
                KeyElement("。"),
                KeyElement("？"),
                KeyElement("！"),
                KeyElement("…", extras: [.init("省略號", alignment: .top)]),
                KeyElement(".", extras: [.init("英文", alignment: .top)])
        ]

        /// Extra punctuation selected by a vertical pull when symbol input is enabled.
        private let headerText: String = "？"

        /// Expansion occurs after 300 ms of held time, or 600 ms when a vertical pull selected text.
        private var longPressDeadline: ContinuousClock.Instant? {
                guard isTouching, isLongPressing.negative, context.inputStage.isBuffering.negative, let pressStartedAt else { return nil }
                let threshold: Duration = pulled.isNil ? .milliseconds(300) : .milliseconds(600)
                return pressStartedAt.advanced(by: threshold - heldDuration)
        }

        /// Includes the active press interval without counting time spent outside the button.
        private func elapsedPressDuration(at instant: ContinuousClock.Instant) -> Duration {
                heldDuration + (pressStartedAt?.duration(to: instant) ?? .zero)
        }

        var body: some View {
                let keyWidth: CGFloat = context.widthUnit
                let keyHeight: CGFloat = context.heightUnit
                let keyboardInterface = context.keyboardInterface
                let insets = keyboardInterface.keyShapeInsets
                let baseWidth: CGFloat = keyWidth - insets.horizontalTotal
                let baseHeight: CGFloat = keyHeight - insets.verticalTotal
                let previewBottomOffset: CGFloat = keyboardInterface.previewBottomOffset(keyWidth: keyWidth, keyHeight: keyHeight, insets: insets)
                let shouldPreviewKey: Bool = Options.keyTextPreview
                let displayForm = KeyDisplayForm.responsive(isInteracting: isTouching, isLongPressing: isLongPressing, shouldPreview: shouldPreviewKey)
                let shouldShowExtraSymbols: Bool = Options.inputKeyStyle.isSymbolApplied
                let interactionDeadline = longPressDeadline
                Button(action: {}) {
                        ZStack {
                                Color.interactiveClear
                                switch displayForm {
                                case .expanding:
                                        let symbolCount: Int = elements.count
                                        let expansionCount: Int = symbolCount - 1
                                        let trailingOffset: CGFloat = baseWidth * CGFloat(expansionCount)
                                        Color.clear
                                                .glassEffect(.regular, in: ExpansiveBubbleShape(side: .trailing, expansionCount: expansionCount))
                                                .overlay {
                                                        HStack(spacing: 0) {
                                                                ForEach(elements.reversed().enumerated(), id: \.element.text) { index, element in
                                                                        let reversedIndex = (symbolCount - 1) - index
                                                                        let isSelected: Bool = selectedIndex == reversedIndex
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
                                                                                        .font(.title2)
                                                                                        .foregroundStyle(isSelected ? Color.white : Color.primary)
                                                                        }
                                                                        .frame(maxWidth: .infinity)
                                                                }
                                                        }
                                                        .frame(width: baseWidth * CGFloat(symbolCount), height: baseHeight)
                                                        .padding(.bottom, previewBottomOffset)
                                                        .padding(.trailing, trailingOffset)
                                                }
                                                .padding(insets)
                                case .previewing:
                                        Color.clear
                                                .glassEffect(.regular, in: BubbleShape())
                                                .overlay {
                                                        Text(verbatim: pulled ?? (context.inputStage.isBuffering ? String.apostrophe : String.cantonesePeriod))
                                                                .font(.largeTitle)
                                                                .padding(.bottom, previewBottomOffset)
                                                }
                                                .padding(insets)
                                case .normal, .reflecting:
                                        ZStack {
                                                Color.clear
                                                ZStack(alignment: .topTrailing) {
                                                        Color.clear
                                                        Text(verbatim: headerText).font(.labelCaption).padding(.horizontal, 2)
                                                }
                                                .opacity((shouldShowExtraSymbols && context.inputStage.isBuffering.negative) ? 0.5 : 0)
                                                ZStack(alignment: .bottom) {
                                                        Color.clear
                                                        Text(verbatim: PresetConstant.separate).font(.labelCaption).padding(2)
                                                }
                                                .opacity(context.inputStage.isBuffering ? 0.5 : 0)
                                                Text(verbatim: context.inputStage.isBuffering ? String.apostrophe : String.cantonesePeriod).font(.letterCompact)
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
                                        let memberCount: Int = elements.count
                                        let distance: CGFloat = -(state.translation.width)
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
                                        let isSatisfied: Bool = abs(distance) > 36 || (elapsedPressDuration(at: clock.now) >= .milliseconds(200) && abs(distance) > 24)
                                        guard isSatisfied else { return }
                                        pulled = headerText
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
                                        guard let selectedSymbol: String = elements.fetch(selectedIndex)?.text else { return }
                                        AudioFeedback.inputed()
                                        context.triggerSelectionHapticFeedback()
                                        context.operate(.input(selectedSymbol))
                                } else if let pulledText = pulled {
                                        context.operate(.input(pulledText))
                                } else if context.inputStage.isBuffering {
                                        context.handle(.apostrophe)
                                } else {
                                        context.operate(.input(String.cantonesePeriod))
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
