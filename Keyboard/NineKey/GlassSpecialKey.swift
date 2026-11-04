import SwiftUI
import CommonExtensions
import CoreIME

/// A nine-key reverse-lookup key with a long-press method selector and glass styling.
///
/// An ordinary release dispatches the default reverse-lookup trigger. Holding expands the method
/// selector; sliding horizontally changes the selection and releasing dispatches its virtual key.
/// While composing, expansion is disabled and release routes through the apostrophe handler.
@available(iOS 26.0, *)
@available(iOSApplicationExtension 26.0, *)
struct GlassSpecialKey: View {

        /// Advertised reverse-lookup triggers in display order, dispatched through the controller on release.
        private let triggers: [VirtualInputKey] = [.letterR, .letterV, .letterX, .letterQ]

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

        /// Keeps the expanded selector active through sliding until the gesture ends.
        @State private var isLongPressing: Bool = false

        /// Selected index in triggers; zero selects R when expansion begins and after release resets it.
        @State private var selectedIndex: Int = 0

        /// Expansion occurs after 300 ms of held time, excluding time spent outside the button.
        ///
        /// Returns nil while composing, outside the button, or after expansion has already engaged.
        /// The deadline task rechecks this value before activating the selector to reject stale work.
        private var longPressDeadline: ContinuousClock.Instant? {
                guard isTouching, isLongPressing.negative, context.inputStage.isBuffering.negative, let pressStartedAt else { return nil }
                return pressStartedAt.advanced(by: .milliseconds(300) - heldDuration)
        }

        /// Renders the glass key face and expanded selector using the nine-key dimensions.
        ///
        /// Press-down records the start time and provides feedback; input dispatch waits for release.
        /// Touch-state changes accumulate held time across exit and reentry, while the simultaneous drag
        /// tracks selection beyond the button bounds and resets timing and selection when it ends.
        /// A cancellable deadline task activates expansion only if its deadline is still current.
        var body: some View {
                let keyWidth: CGFloat = context.nineKeyWidthUnit * PresetConstant.tailoredInputKeyWidthCoefficient
                let keyHeight: CGFloat = context.heightUnit
                let shapeInset: CGFloat = 3
                let baseWidth: CGFloat = keyWidth - (shapeInset * 2)
                let baseHeight: CGFloat = keyHeight - (shapeInset * 2)
                let extraHeight: CGFloat = 4
                let previewBottomOffset: CGFloat = (baseHeight + extraHeight) * 2
                let displayForm = KeyDisplayForm.responsive(isInteracting: isTouching, isLongPressEngaged: isLongPressing, isPreviewEnabled: false)
                let isBuffering: Bool = context.inputStage.isBuffering
                let interactionDeadline = longPressDeadline
                Button(action: {}) {
                        ZStack {
                                Color.interactiveClear
                                switch displayForm {
                                case .previewing, .expanding:
                                        let memberCount: Int = triggers.count
                                        let expansionCount: Int = memberCount - 1
                                        let offsetX: CGFloat = baseWidth * CGFloat(expansionCount)
                                        let gap: CGFloat = 3
                                        Color.clear
                                                .glassEffect(.regular, in: ExpansiveLargeBubbleShape(side: .leading, expansionCount: expansionCount))
                                                .overlay {
                                                        HStack(spacing: 0) {
                                                                ForEach(triggers.enumerated(), id: \.element.code) { index, trigger in
                                                                        ZStack {
                                                                                RoundedRectangle(cornerRadius: PresetConstant.largeKeyCornerRadius - gap)
                                                                                        .fill((selectedIndex == index) ? Color.accentColor : Color.clear)
                                                                                VStack(spacing: 0) {
                                                                                        Text(verbatim: trigger.text).textCase(.uppercase).font(.title2)
                                                                                        Text(verbatim: trigger.lookupFootnote(Options.cangjieVariant)).font(.labelCaption).shallow()
                                                                                }
                                                                        }
                                                                        .foregroundStyle((selectedIndex == index) ? Color.white : Color.primary)
                                                                        .padding(gap)
                                                                        .frame(maxWidth: .infinity)
                                                                }
                                                        }
                                                        .frame(width: baseWidth * CGFloat(memberCount), height: baseHeight)
                                                        .padding(.bottom, previewBottomOffset)
                                                        .padding(.leading, offsetX)
                                                }
                                                .padding(shapeInset)
                                case .normal, .reflecting:
                                        ZStack {
                                                Color.clear
                                                ZStack(alignment: .bottom) {
                                                        Color.clear
                                                        Text(verbatim: isBuffering ? PresetConstant.separate : PresetConstant.reverseLookup)
                                                                .font(.labelCaption)
                                                                .opacity(isBuffering ? 0 : 0.35)
                                                }
                                                .padding(2)
                                                if isBuffering {
                                                        Text(verbatim: String.apostrophe).hidden()
                                                } else {
                                                        HStack(alignment: .lastTextBaseline, spacing: 1) {
                                                                Text(verbatim: "R")
                                                                Text(verbatim: "VXQ").font(.labelCaption)
                                                        }
                                                }
                                        }
                                        .glassEffect(isTouching ? .regular : .clear, in: .rect(cornerRadius: PresetConstant.largeKeyCornerRadius))
                                        .shadow(color: isTouching ? colorScheme.glassShadow : Color.clear, radius: 0.5)
                                        .padding(isTouching ? (shapeInset - 2) : shapeInset)
                                }
                        }
                        .frame(width: keyWidth, height: keyHeight)
                }
                .buttonStyle(PressButtonStyle($isTouching) {
                        pressStartedAt = clock.now
                        context.performAudioFeedback(.input)
                        context.triggerHapticFeedback()
                })
                .onChange(of: isTouching) { _, touching in
                        guard touching.negative, let pressStartedAt else { return }
                        heldDuration += pressStartedAt.duration(to: clock.now)
                        self.pressStartedAt = nil
                }
                .simultaneousGesture(DragGesture(minimumDistance: 0)
                        .onChanged { state in
                                guard isLongPressing else { return }
                                let memberCount: Int = triggers.count
                                guard memberCount > 1 else { return }
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
                        }
                        .onEnded { _ in
                                pressStartedAt = nil
                                heldDuration = .zero
                                defer {
                                        selectedIndex = 0
                                        isLongPressing = false
                                }
                                if isLongPressing {
                                        context.performAudioFeedback(.input)
                                        context.triggerSelectionHapticFeedback()
                                        let selected = triggers.fetch(selectedIndex)
                                        context.nineKeyProcess(selected)
                                } else if isBuffering {
                                        context.nineKeyProcess(.apostrophe)
                                } else {
                                        context.nineKeyProcess()
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
