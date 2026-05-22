import SwiftUI
import CoreIME
import CommonExtensions

@available(iOS 26.0, *)
@available(iOSApplicationExtension 26.0, *)
struct GlassNineKeyInputKey: View {

        init(_ combo: Combo) {
                self.combo = combo
        }
        private let combo: Combo

        @EnvironmentObject private var context: KeyboardViewController
        @Environment(\.colorScheme) private var colorScheme
        @GestureState private var isTouching: Bool = false

        var body: some View {
                ZStack {
                        Color.interactiveClear
                        Text(verbatim: combo.text)
                }
                .glassEffect(isTouching ? .regular : .clear, in: RoundedRectangle(cornerRadius: PresetConstant.largeKeyCornerRadius, style: .continuous))
                .shadow(color: isTouching ? colorScheme.glassShadow : Color.clear, radius: 0.5)
                .padding(3)
                .frame(width: context.nineKeyWidthUnit * 1.04, height: context.heightUnit)
                .contentShape(.rect)
                .gesture(DragGesture(minimumDistance: 0)
                        .updating($isTouching) { _, isTouched, _ in
                                if isTouched.negative {
                                        isTouched = true
                                        AudioFeedback.inputed()
                                        context.triggerHapticFeedback()
                                        context.nineKeyProcess(combo)
                                }
                        }
                )
        }
}

struct NineKeyInputKey: View {

        init(_ combo: Combo) {
                self.combo = combo
        }
        private let combo: Combo

        @EnvironmentObject private var context: KeyboardViewController
        @Environment(\.colorScheme) private var colorScheme

        @GestureState private var isTouching: Bool = false

        var body: some View {
                ZStack {
                        Color.interactiveClear
                        RoundedRectangle(cornerRadius: PresetConstant.largeKeyCornerRadius, style: .continuous)
                                .fill(isTouching ? colorScheme.activeInputKeyColor : colorScheme.inputKeyColor)
                                .shadow(color: .shadowGray, radius: 0.5, y: 0.5)
                                .padding(3)
                        Text(verbatim: combo.text)
                }
                .frame(width: context.nineKeyWidthUnit * 1.04, height: context.heightUnit)
                .contentShape(.rect)
                .gesture(DragGesture(minimumDistance: 0)
                        .updating($isTouching) { _, isTouched, _ in
                                if isTouched.negative {
                                        isTouched = true
                                        AudioFeedback.inputed()
                                        context.triggerHapticFeedback()
                                        context.nineKeyProcess(combo)
                                }
                        }
                )
        }
}
