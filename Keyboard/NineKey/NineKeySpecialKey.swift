import SwiftUI
import CommonExtensions
import CoreIME

@available(iOS 26.0, *)
@available(iOSApplicationExtension 26.0, *)
struct GlassNineKeySpecialKey: View {

        @EnvironmentObject private var context: KeyboardViewController
        @Environment(\.colorScheme) private var colorScheme

        @GestureState private var isTouching: Bool = false

        var body: some View {
                let isBuffering: Bool = context.inputStage.isBuffering
                ZStack {
                        Color.interactiveClear
                        ZStack(alignment: .bottom) {
                                Color.clear
                                Text(verbatim: isBuffering ? PresetConstant.separate : PresetConstant.reverseLookup)
                                        .font(.keyFootnote)
                                        .opacity(isBuffering ? 0 : 0.35)
                        }
                        .padding(.bottom, 5)
                        Text(verbatim: isBuffering ? String.apostrophe : Combo.special.text)
                                .opacity(isBuffering ? 0 : 1)
                }
                .glassEffect(isTouching ? .regular : .clear, in: RoundedRectangle(cornerRadius: PresetConstant.largeKeyCornerRadius, style: .continuous))
                .shadow(color: isTouching ? colorScheme.glassShadow : Color.clear, radius: 0.5)
                .padding(3)
                .frame(width: context.nineKeyWidthUnit * 1.04, height: context.heightUnit)
                .contentShape(.rect)
                .gesture(DragGesture(minimumDistance: 0)
                        .updating($isTouching) { _, tapped, _ in
                                if tapped.negative {
                                        AudioFeedback.inputed()
                                        context.triggerHapticFeedback()
                                        tapped = true
                                }
                        }
                        .onEnded { _ in
                                if context.inputStage.isBuffering.negative {
                                        context.nineKeyProcess(.special)
                                }
                        }
                )
        }
}

struct NineKeySpecialKey: View {

        @EnvironmentObject private var context: KeyboardViewController
        @Environment(\.colorScheme) private var colorScheme

        @GestureState private var isTouching: Bool = false

        var body: some View {
                let isBuffering: Bool = context.inputStage.isBuffering
                ZStack {
                        Color.interactiveClear
                        RoundedRectangle(cornerRadius: PresetConstant.largeKeyCornerRadius, style: .continuous)
                                .fill(isTouching ? colorScheme.activeInputKeyColor : colorScheme.inputKeyColor)
                                .shadow(color: .shadowGray, radius: 0.5, y: 0.5)
                                .padding(3)
                        ZStack(alignment: .bottom) {
                                Color.clear
                                Text(verbatim: isBuffering ? PresetConstant.separate : PresetConstant.reverseLookup)
                                        .font(.keyFootnote)
                                        .opacity(isBuffering ? 0 : 0.35)
                        }
                        .padding(.bottom, 5)
                        Text(verbatim: isBuffering ? String.apostrophe : Combo.special.text)
                                .opacity(isBuffering ? 0 : 1)
                }
                .frame(width: context.nineKeyWidthUnit * 1.04, height: context.heightUnit)
                .contentShape(.rect)
                .gesture(DragGesture(minimumDistance: 0)
                        .updating($isTouching) { _, tapped, _ in
                                if tapped.negative {
                                        AudioFeedback.inputed()
                                        context.triggerHapticFeedback()
                                        tapped = true
                                }
                        }
                        .onEnded { _ in
                                if context.inputStage.isBuffering.negative {
                                        context.nineKeyProcess(.special)
                                }
                        }
                )
        }
}
