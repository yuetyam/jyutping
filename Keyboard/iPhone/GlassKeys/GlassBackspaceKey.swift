import SwiftUI
import CommonExtensions

/// A glass-styled backspace key with hold-to-repeat and swipe-to-clear behavior.
@available(iOS 26.0, *)
@available(iOSApplicationExtension 26.0, *)
struct GlassBackspaceKey: View {

        /// Creates a glass-styled backspace key.
        ///
        /// - Parameter coefficient: Multiplier applied to the keyboard's width unit.
        init(coefficient: CGFloat = 1.3) {
                self.coefficient = coefficient
        }

        /// Multiplier applied to the keyboard's width unit.
        private let coefficient: CGFloat


        /// Keyboard properties and handlers.
        @EnvironmentObject private var context: KeyboardViewController

        /// Retrieves the current system color scheme for the pressed-key shadow.
        @Environment(\.colorScheme) private var colorScheme

        /// Button press state reported by `PressButtonStyle`.
        @State private var isTouching: Bool = false

        /// Number of elapsed 100 ms checkpoints used before repeat deletion begins.
        @State private var buffer: Int = 0

        /// Renders the backspace symbol using the current keyboard interface's key insets; pressing highlights and enlarges the glass key.
        ///
        /// PressButtonStyle performs the first deletion with audio and haptic feedback on press-down. The task repeats deletion at 100 ms intervals after the initial hold delay.
        /// Releasing a drag more than 44 points left or up sends the clear-buffer operation with audio and haptic feedback.
        var body: some View {
                let keyWidth: CGFloat = context.widthUnit * coefficient
                let keyHeight: CGFloat = context.heightUnit
                let insets = context.keyboardInterface.keyShapeInsets
                Button(action: {}) {
                        ZStack {
                                Color.interactiveClear
                                ZStack {
                                        Color.clear
                                        Image.backspace.symbolVariant(isTouching ? .fill : .none).font(.symbol)
                                }
                                .glassEffect(isTouching ? .regular : .clear, in: .rect(cornerRadius: PresetConstant.keyCornerRadius))
                                .shadow(color: isTouching ? colorScheme.glassShadow : Color.clear, radius: 0.5)
                                .padding(isTouching ? insets.plused(-2): insets)
                        }
                        .frame(width: keyWidth, height: keyHeight)
                }
                .buttonStyle(PressButtonStyle($isTouching) {
                        buffer = 0
                        AudioFeedback.deleted()
                        context.triggerHapticFeedback()
                        context.operate(.backspace)
                })
                .simultaneousGesture(DragGesture(minimumDistance: 0)
                        .onEnded { value in
                                buffer = 0
                                guard (value.translation.width < -44) || (value.translation.height < -44) else { return }
                                AudioFeedback.deleted()
                                context.triggerHapticFeedback()
                                context.operate(.clearBuffer)
                        }
                )
                .task(id: isTouching) {
                        guard isTouching else { return }
                        while Task.isCancelled.negative {
                                try? await Task.sleep(for: .milliseconds(100)) // 0.1s
                                if isTouching {
                                        if buffer > 3 {
                                                AudioFeedback.deleted()
                                                context.triggerHapticFeedback()
                                                context.operate(.backspace)
                                        } else {
                                                buffer += 1
                                        }
                                }
                        }
                }
        }
}
