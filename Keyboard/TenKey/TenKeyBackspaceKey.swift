import SwiftUI
import CommonExtensions

struct TenKeyBackspaceKey: View {

        @EnvironmentObject private var context: KeyboardViewController
        @Environment(\.colorScheme) private var colorScheme

        @GestureState private var isTouching: Bool = false
        @State private var buffer: Int = 0
        private let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

        var body: some View {
                ZStack {
                        Color.interactiveClear
                        RoundedRectangle(cornerRadius: PresetConstant.largeKeyCornerRadius, style: .continuous)
                                .fill(isTouching ? colorScheme.activeActionKeyColor : colorScheme.actionKeyColor)
                                .shadow(color: .shadowGray, radius: 0.5, y: 0.5)
                                .padding(3)
                        Image.backspace.symbolVariant(isTouching ? .fill : .none).font(.symbol)
                }
                .frame(width: context.tenKeyWidthUnit, height: context.heightUnit)
                .contentShape(Rectangle())
                .gesture(DragGesture(minimumDistance: 0)
                        .updating($isTouching) { _, tapped, _ in
                                guard tapped.negative else { return }
                                AudioFeedback.deleted()
                                context.triggerHapticFeedback()
                                context.operate(.backspace)
                                tapped = true
                        }
                        .onEnded { value in
                                buffer = 0
                                let horizontalTranslation = value.translation.width
                                guard horizontalTranslation < -44 else { return }
                                AudioFeedback.deleted()
                                context.triggerHapticFeedback()
                                context.operate(.clearBuffer)
                         }
                )
                .onReceive(timer) { _ in
                        guard isTouching else { return }
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
