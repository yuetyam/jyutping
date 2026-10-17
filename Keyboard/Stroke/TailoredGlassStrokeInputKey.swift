import SwiftUI
import CommonExtensions
import CoreIME

/// A glass-styled stroke key for the tailored reverse-lookup keyboard that handles input on press-down.
///
/// Displays the stroke symbol with its mapped digit above and Cantonese name at the bottom trailing corner.
@available(iOS 26.0, *)
@available(iOSApplicationExtension 26.0, *)
struct TailoredGlassStrokeInputKey: View {

        /// Creates a glass-styled key displaying the given stroke and sending its mapped digit on press-down.
        ///
        /// - Parameter stroke: The stroke or wildcard represented by the key.
        init(_ stroke: StrokeVirtualKey) {
                self.stroke = stroke
                self.keyText = stroke.strokeText
                self.keyDigit = stroke.virtualInputKey.text
                self.keyName = stroke.strokeName
        }

        /// Stroke whose mapped input event is handled on press-down.
        private let stroke: StrokeVirtualKey

        /// Stroke symbol displayed in the center of the key.
        private let keyText: String

        /// Mapped digit displayed above the stroke symbol.
        private let keyDigit: String

        /// Cantonese stroke name displayed at the bottom trailing corner.
        private let keyName: String

        /// Keyboard dimensions, input handling, and haptic feedback.
        @EnvironmentObject private var context: KeyboardViewController

        /// Current color scheme used to choose the pressed glass key's shadow color.
        @Environment(\.colorScheme) private var colorScheme

        /// Button press state reported by PressButtonStyle.
        @State private var isTouching: Bool = false

        /// Renders the stroke and captions in a glass key measuring 1.06 nine-key width units by one height unit.
        ///
        /// Pressing switches to regular glass, enlarges the key and stroke text, plays input audio, triggers haptic feedback, and sends the mapped input event.
        var body: some View {
                Button(action: {}) {
                        ZStack {
                                Color.interactiveClear
                                ZStack {
                                        Color.clear
                                        ZStack(alignment: .top) {
                                                Color.clear
                                                Text(verbatim: keyDigit)
                                                        .font(.labelCaption)
                                                        .shallow()
                                        }
                                        .padding(1)
                                        ZStack(alignment: .bottomTrailing) {
                                                Color.clear
                                                Text(verbatim: keyName)
                                                        .font(.labelCaption)
                                                        .shallow()
                                                        .padding(.horizontal, 2)
                                        }
                                        .padding(1)
                                        Text(verbatim: keyText)
                                                .font(isTouching ? .letterCompact : .adjustedLetterCompact)
                                                .padding(.top, 4)
                                }
                                .glassEffect(isTouching ? .regular : .clear, in: .rect(cornerRadius: PresetConstant.largeKeyCornerRadius))
                                .shadow(color: isTouching ? colorScheme.glassShadow : Color.clear, radius: 0.5)
                                .padding(isTouching ? 1 : 3)
                        }
                        .frame(width: context.nineKeyWidthUnit * 1.06, height: context.heightUnit)
                }
                .buttonStyle(PressButtonStyle($isTouching) {
                        AudioFeedback.inputed()
                        context.triggerHapticFeedback()
                        context.handle(stroke.virtualInputKey)
                })
        }
}
