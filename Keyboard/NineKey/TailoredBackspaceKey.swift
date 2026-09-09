import SwiftUI
import CommonExtensions

@available(iOS 26.0, *)
@available(iOSApplicationExtension 26.0, *)
struct GlassTailoredBackspaceKey: View {

        @EnvironmentObject private var context: KeyboardViewController
        @Environment(\.colorScheme) private var colorScheme

        @State private var isTouching: Bool = false
        @State private var buffer: Int = 0

        var body: some View {
                Button(action: {}) {
                        ZStack {
                                Color.interactiveClear
                                ZStack {
                                        Color.clear
                                        Image.backspace.symbolVariant(isTouching ? .fill : .none).font(.symbol)
                                }
                                .glassEffect(isTouching ? .regular : .clear, in: .rect(cornerRadius: PresetConstant.largeKeyCornerRadius))
                                .shadow(color: isTouching ? colorScheme.glassShadow : Color.clear, radius: 0.5)
                                .padding(isTouching ? 1 : 3)
                        }
                        .frame(width: context.nineKeyWidthUnit * 0.91, height: context.heightUnit)
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

struct TailoredBackspaceKey: View {

        @EnvironmentObject private var context: KeyboardViewController
        @Environment(\.colorScheme) private var colorScheme

        @State private var isTouching: Bool = false
        @State private var buffer: Int = 0

        var body: some View {
                Button(action: {}) {
                        ZStack {
                                Color.interactiveClear
                                RoundedRectangle(cornerRadius: PresetConstant.largeKeyCornerRadius)
                                        .fill(isTouching ? colorScheme.activeActionKeyColor : colorScheme.actionKeyColor)
                                        .shadow(color: .shadowGray, radius: 0.5, y: 0.5)
                                        .padding(isTouching ? 1 : 3)
                                Image.backspace.symbolVariant(isTouching ? .fill : .none).font(.symbol)
                        }
                        .frame(width: context.nineKeyWidthUnit * 0.91, height: context.heightUnit)
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
