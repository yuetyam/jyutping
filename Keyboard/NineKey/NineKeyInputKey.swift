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
        @State private var isTouching: Bool = false

        var body: some View {
                Button(action: {}) {
                        ZStack {
                                Color.interactiveClear
                                ZStack {
                                        Color.clear
                                        Text(verbatim: combo.text)
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
                        context.nineKeyProcess(combo)
                })
        }
}

struct NineKeyInputKey: View {

        init(_ combo: Combo) {
                self.combo = combo
        }
        private let combo: Combo

        @EnvironmentObject private var context: KeyboardViewController
        @Environment(\.colorScheme) private var colorScheme
        @State private var isTouching: Bool = false

        var body: some View {
                Button(action: {}) {
                        ZStack {
                                Color.interactiveClear
                                RoundedRectangle(cornerRadius: PresetConstant.largeKeyCornerRadius)
                                        .fill(isTouching ? colorScheme.activeInputKeyColor : colorScheme.inputKeyColor)
                                        .shadow(color: .shadowGray, radius: 0.5, y: 0.5)
                                        .padding(isTouching ? 1 : 3)
                                Text(verbatim: combo.text)
                        }
                        .frame(width: context.nineKeyWidthUnit * 1.06, height: context.heightUnit)
                }
                .buttonStyle(PressButtonStyle($isTouching) {
                        AudioFeedback.inputed()
                        context.triggerHapticFeedback()
                        context.nineKeyProcess(combo)
                })
        }
}
