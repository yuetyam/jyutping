import SwiftUI
import CommonExtensions
import CoreIME

/// An iPad input key supporting a downward pull to its upper text.
///
/// Releasing commits the pulled upper text or the ordinary lower input.
/// Drag tracking keeps the pull active when the finger moves outside the original button.
struct PadPullableInputKey: View {

        /// Creates a PadPullableInputKey with upper pull text and ordinary lower input.
        ///
        /// - Parameters:
        ///   - virtual: Optional event handled on an ordinary release. When nil, the lower text is processed instead.
        ///   - upper: Text shown above the primary content and committed by a downward pull.
        ///   - lower: Text committed on an ordinary release when no virtual event is supplied.
        init(virtual: VirtualInputKey? = nil, upper: String, lower: String) {
                self.virtual = virtual
                self.upper = upper
                self.lower = lower
        }

        /// Event handled on release when no upper text is selected by a downward pull.
        private let virtual: VirtualInputKey?

        /// Text selected by a downward pull.
        private let upper: String

        /// Text committed on an ordinary release when no pull or virtual event is selected.
        private let lower: String

        /// Keyboard properties and handlers.
        @EnvironmentObject private var context: KeyboardViewController

        /// Retrieves the current system color scheme (light or dark mode) from the environment.
        @Environment(\.colorScheme) private var colorScheme

        /// Button press state reported by PressButtonStyle; may end when sliding outside the key.
        @State private var isTouching: Bool = false

        /// Number of elapsed 100 ms checkpoints used for pull thresholds.
        @State private var buffer: Int = 0

        /// Indicates that a downward pull has selected the upper text.
        @State private var isPullingDown: Bool = false

        var body: some View {
                let keyWidth: CGFloat = context.widthUnit
                let keyHeight: CGFloat = context.heightUnit
                let insets = context.keyboardInterface.keyShapeInsets
                let shouldShowLowercaseKeys: Bool = Options.showLowercaseKeys && context.keyboardCase.isLowercased
                let textCase: Text.Case = shouldShowLowercaseKeys ? .lowercase : .uppercase
                Button(action: {}) {
                        ZStack {
                                Color.interactiveClear
                                RoundedRectangle(cornerRadius: PresetConstant.largeKeyCornerRadius)
                                        .fill(isTouching ? colorScheme.activeInputKeyColor : colorScheme.inputKeyColor)
                                        .shadow(color: .shadowGray, radius: 0.5, y: 0.5)
                                        .padding(insets)
                                if isPullingDown {
                                        Text(verbatim: upper)
                                                .textCase(textCase)
                                                .font(.title2)
                                } else {
                                        ZStack(alignment: .top) {
                                                Color.clear
                                                Text(verbatim: upper)
                                                        .textCase(textCase)
                                                        .font(.footnote)
                                                        .opacity(0.3)
                                        }
                                        .padding(insets.plused(horizontal: 5, vertical: 5))
                                        ZStack(alignment: .bottom) {
                                                Color.clear
                                                Text(verbatim: lower)
                                                        .textCase(textCase)
                                                        .font(.title2)
                                        }
                                        .padding(insets.plused(horizontal: 7, vertical: 7))
                                }
                        }
                        .frame(width: keyWidth, height: keyHeight)
                }
                .buttonStyle(PressButtonStyle($isTouching) {
                        AudioFeedback.inputed()
                })
                .simultaneousGesture(DragGesture(minimumDistance: 0)
                        .onChanged { state in
                                guard isPullingDown.negative else { return }
                                let distance: CGFloat = state.translation.height
                                let isSatisfied: Bool = distance > 36 || (buffer > 1 && distance > 24)
                                guard isSatisfied else { return }
                                isPullingDown = true
                        }
                        .onEnded { _ in
                                buffer = 0
                                defer {
                                        isPullingDown = false
                                }
                                if isPullingDown {
                                        let text: String = context.keyboardCase.isLowercased ? upper : upper.uppercased()
                                        context.operate(.process(text))
                                } else if let virtual {
                                        context.handle(virtual)
                                } else {
                                        let text: String = context.keyboardCase.isLowercased ? lower : lower.uppercased()
                                        context.operate(.process(text))
                                }
                        }
                )
                .task(id: isTouching) {
                        guard isTouching else { return }
                        while isPullingDown.negative {
                                try? await Task.sleep(for: .milliseconds(100))
                                guard Task.isCancelled.negative else { break }
                                guard isPullingDown.negative else { break }
                                buffer += 1
                        }
                }
        }
}
