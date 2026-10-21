import SwiftUI
import CommonExtensions
import CoreIME

/// A stroke key for the tailored reverse-lookup keyboard that handles input on press-down.
///
/// Displays the stroke symbol with its mapped digit above and Cantonese name at the bottom trailing corner.
struct TailoredStrokeInputKey: View {

        /// Creates a key displaying the given stroke and sending its mapped digit on press-down.
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

        /// Current color scheme used to choose the normal and pressed key colors.
        @Environment(\.colorScheme) private var colorScheme

        /// Button press state reported by PressButtonStyle.
        @State private var isTouching: Bool = false

        /// Renders the stroke and captions in a key measuring 1.06 nine-key width units by one height unit.
        ///
        /// Pressing enlarges the key shape and stroke text, plays input audio, triggers haptic feedback, and sends the mapped input event.
        var body: some View {
                Button(action: {}) {
                        ZStack {
                                Color.interactiveClear
                                ZStack {
                                        Color.clear
                                        RoundedRectangle(cornerRadius: PresetConstant.largeKeyCornerRadius)
                                                .fill(colorScheme.inputKeyBackground(style: context.appearanceStyle, isPreviewEnabled: false, isInteracting: isTouching))
                                                .shadow(color: .shadowGray, radius: 0.5, y: 0.5)
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
                                }
                                .padding(isTouching ? 1 : 3)
                                Text(verbatim: keyText)
                                        .font(isTouching ? .compactKeyLabel : .adjustedKeyLabel)
                                        .padding(.top, 4)
                        }
                        .frame(width: context.nineKeyWidthUnit * PresetConstant.tailoredInputKeyWidthCoefficient, height: context.heightUnit)
                }
                .buttonStyle(PressButtonStyle($isTouching) {
                        AudioFeedback.inputed()
                        context.triggerHapticFeedback()
                        context.handle(stroke.virtualInputKey)
                })
        }
}
