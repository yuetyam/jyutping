import SwiftUI
import CommonExtensions

struct MediumPadBackspaceKey: View {

        let widthUnitTimes: CGFloat

        @EnvironmentObject private var context: KeyboardViewController

        @Environment(\.colorScheme) private var colorScheme

        private var keyColor: Color {
                switch colorScheme {
                case .light:
                        return .lightAction
                case .dark:
                        return .darkAction
                @unknown default:
                        return .lightAction
                }
        }
        private var keyActiveColor: Color {
                switch colorScheme {
                case .light:
                        return .activeLightAction
                case .dark:
                        return .activeDarkAction
                @unknown default:
                        return .activeLightAction
                }
        }

        @GestureState private var isTouching: Bool = false
        @State private var buffer: Int = 0
        private let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

        var body: some View {
                let keyWidth: CGFloat = context.widthUnit * widthUnitTimes
                let keyHeight: CGFloat = context.heightUnit
                let isLandscape: Bool = context.keyboardInterface.isPadLandscape
                let verticalPadding: CGFloat = isLandscape ? 7 : 5
                let horizontalPadding: CGFloat = isLandscape ? 7 : 5
                ZStack {
                        Color.interactiveClear
                        RoundedRectangle(cornerRadius: PresetConstant.largeKeyCornerRadius, style: .continuous)
                                .fill(isTouching ? keyActiveColor : keyColor)
                                .shadow(color: .shadowGray, radius: 0.5, y: 0.5)
                                .padding(.vertical, verticalPadding)
                                .padding(.horizontal, horizontalPadding)
                        ZStack(alignment: .topTrailing) {
                                Color.clear
                                Image.backspace.symbolVariant(isTouching ? .fill : .none)
                        }
                        .padding(.vertical, verticalPadding + 5)
                        .padding(.horizontal, horizontalPadding + 5)
                        ZStack(alignment: .bottomTrailing) {
                                Color.clear
                                Text(verbatim: "delete").font(.footnote)
                        }
                        .padding(.vertical, verticalPadding + 5)
                        .padding(.horizontal, horizontalPadding + 5)
                }
                .frame(width: keyWidth, height: keyHeight)
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
