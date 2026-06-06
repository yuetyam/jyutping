import SwiftUI
import CommonExtensions
import CoreIME

@available(iOS 26.0, *)
@available(iOSApplicationExtension 26.0, *)
struct GlassTailoredNumberDotKey: View {
        @EnvironmentObject private var context: KeyboardViewController
        @Environment(\.colorScheme) private var colorScheme
        @GestureState private var isTouching: Bool = false
        private let keyText: String = String.period
        var body: some View {
                ZStack {
                        Color.interactiveClear
                        ZStack {
                                Color.clear
                                Text(verbatim: keyText).font(.letterCompact)
                        }
                        .glassEffect(isTouching ? .regular : .clear, in: RoundedRectangle(cornerRadius: PresetConstant.largeKeyCornerRadius, style: .continuous))
                        .shadow(color: isTouching ? colorScheme.glassShadow : Color.clear, radius: 0.5)
                        .padding(isTouching ? 1 : 3)
                }
                .frame(width: context.nineKeyWidthUnit * 1.06, height: context.heightUnit)
                .contentShape(.rect)
                .gesture(DragGesture(minimumDistance: 0)
                        .updating($isTouching) { _, isTouchBegan, _ in
                                if isTouchBegan.negative {
                                        isTouchBegan = true
                                        AudioFeedback.inputed()
                                        context.triggerHapticFeedback()
                                        context.operate(.input(keyText))
                                }
                        }
                )
        }
}

struct TailoredNumberDotKey: View {
        @EnvironmentObject private var context: KeyboardViewController
        @Environment(\.colorScheme) private var colorScheme
        @GestureState private var isTouching: Bool = false
        private let keyText: String = String.period
        var body: some View {
                ZStack {
                        Color.interactiveClear
                        RoundedRectangle(cornerRadius: PresetConstant.largeKeyCornerRadius, style: .continuous)
                                .fill(isTouching ? colorScheme.activeInputKeyColor : colorScheme.inputKeyColor)
                                .shadow(color: .shadowGray, radius: 0.5, y: 0.5)
                                .padding(isTouching ? 1 : 3)
                        Text(verbatim: keyText).font(.letterCompact)
                }
                .frame(width: context.nineKeyWidthUnit * 1.06, height: context.heightUnit)
                .contentShape(.rect)
                .gesture(DragGesture(minimumDistance: 0)
                        .updating($isTouching) { _, isTouchBegan, _ in
                                if isTouchBegan.negative {
                                        isTouchBegan = true
                                        AudioFeedback.inputed()
                                        context.triggerHapticFeedback()
                                        context.operate(.input(keyText))
                                }
                        }
                )
        }
}
