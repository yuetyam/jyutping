import SwiftUI
import CommonExtensions
import CoreIME

/// iPhone number row key view (ABC keyboards)
@available(iOS 26.0, *)
@available(iOSApplicationExtension 26.0, *)
struct GlassNumberInputKey: View {

        init(_ virtual: VirtualInputKey) {
                self.virtual = virtual
        }
        private let virtual: VirtualInputKey

        @EnvironmentObject private var context: KeyboardViewController
        @Environment(\.colorScheme) private var colorScheme
        @State private var isTouching: Bool = false

        var body: some View {
                let keyWidth = context.widthUnit
                let keyHeight = context.heightUnit
                let keyboardInterface = context.keyboardInterface
                let insets = keyboardInterface.keyShapeInsets
                let previewBottomOffset = keyboardInterface.previewBottomOffset(keyWidth: keyWidth, keyHeight: keyHeight, insets: insets)
                let displayForm = KeyDisplayForm.responsive(isInteracting: isTouching, shouldPreview: Options.keyTextPreview)
                Button(action: {}) {
                        ZStack {
                                Color.interactiveClear
                                switch displayForm {
                                case .previewing, .expanding:
                                        Color.clear
                                                .glassEffect(.regular, in: BubbleShape())
                                                .overlay {
                                                        Text(verbatim: virtual.text)
                                                                .font(.largeTitle)
                                                                .padding(.bottom, previewBottomOffset)
                                                }
                                                .padding(insets)
                                case .normal, .reflecting:
                                        ZStack {
                                                Color.clear
                                                Text(verbatim: virtual.text).font(.letterCompact)
                                        }
                                        .glassEffect(displayForm.isReflecting ? .regular : .clear, in: .rect(cornerRadius: PresetConstant.keyCornerRadius))
                                        .shadow(color: displayForm.isReflecting ? colorScheme.glassShadow : Color.clear, radius: 0.5)
                                        .padding(displayForm.isReflecting ? insets.plused(-2) : insets)
                                }
                        }
                        .frame(width: keyWidth, height: keyHeight)
                }
                .buttonStyle(PressButtonStyle($isTouching) {
                        AudioFeedback.inputed()
                        context.triggerHapticFeedback()
                        context.handle(virtual, isCapitalized: false)
                })
        }
}
