import SwiftUI
import CommonExtensions
import CoreIME

@available(iOS 26.0, *)
@available(iOSApplicationExtension 26.0, *)
struct GlassTailoredNumberKey: View {

        init(_ virtual: VirtualInputKey) {
                self.virtual = virtual
        }
        private let virtual: VirtualInputKey

        @EnvironmentObject private var context: KeyboardViewController
        @Environment(\.colorScheme) private var colorScheme
        @GestureState private var isTouching: Bool = false

        var body: some View {
                ZStack {
                        Color.interactiveClear
                        ZStack {
                                Color.clear
                                Text(verbatim: virtual.text).font(.letterCompact)
                        }
                        .glassEffect(isTouching ? .regular : .clear, in: .rect(cornerRadius: PresetConstant.largeKeyCornerRadius))
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
                                }
                        }
                        .onEnded { _ in
                                context.handle(virtual)
                        }
                )
        }
}

struct TailoredNumberKey: View {

        init(_ virtual: VirtualInputKey) {
                self.virtual = virtual
        }
        private let virtual: VirtualInputKey

        @EnvironmentObject private var context: KeyboardViewController
        @Environment(\.colorScheme) private var colorScheme
        @GestureState private var isTouching: Bool = false

        var body: some View {
                ZStack {
                        Color.interactiveClear
                        RoundedRectangle(cornerRadius: PresetConstant.largeKeyCornerRadius)
                                .fill(isTouching ? colorScheme.activeInputKeyColor : colorScheme.inputKeyColor)
                                .shadow(color: .shadowGray, radius: 0.5, y: 0.5)
                                .padding(isTouching ? 1 : 3)
                        Text(verbatim: virtual.text).font(.letterCompact)
                }
                .frame(width: context.nineKeyWidthUnit * 1.06, height: context.heightUnit)
                .contentShape(.rect)
                .gesture(DragGesture(minimumDistance: 0)
                        .updating($isTouching) { _, isTouchBegan, _ in
                                if isTouchBegan.negative {
                                        isTouchBegan = true
                                        AudioFeedback.inputed()
                                        context.triggerHapticFeedback()
                                }
                        }
                        .onEnded { _ in
                                context.handle(virtual)
                        }
                )
        }
}
