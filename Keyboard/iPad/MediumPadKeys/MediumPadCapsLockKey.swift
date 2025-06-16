import SwiftUI
import CommonExtensions

struct MediumPadCapsLockKey: View {

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
        private var backColor: Color {
                if #available(iOSApplicationExtension 26.0, *) {
                        return isTouching ? keyActiveColor : keyColor
                } else {
                        return context.keyboardCase.isCapsLocked ? keyActiveColor : keyColor
                }
        }

        @GestureState private var isTouching: Bool = false

        var body: some View {
                let keyWidth: CGFloat = context.widthUnit * widthUnitTimes
                let keyHeight: CGFloat = context.heightUnit
                let isLandscape: Bool = context.keyboardInterface.isPadLandscape
                let verticalPadding: CGFloat = isLandscape ? 7 : 5
                let horizontalPadding: CGFloat = isLandscape ? 7 : 5
                ZStack {
                        Color.interactiveClear
                        RoundedRectangle(cornerRadius: PresetConstant.largeKeyCornerRadius, style: .continuous)
                                .fill(backColor)
                                .shadow(color: .shadowGray, radius: 0.5, y: 0.5)
                                .padding(.vertical, verticalPadding)
                                .padding(.horizontal, horizontalPadding)
                        ZStack(alignment: .topLeading) {
                                Color.clear
                                Circle()
                                        .fill(context.keyboardCase.isCapsLocked ? Color.green : keyActiveColor.opacity(0.66))
                                        .frame(width: 5, height: 5)
                        }
                        .padding(.vertical, verticalPadding + 6)
                        .padding(.horizontal, horizontalPadding + 6)
                        ZStack(alignment: .bottomLeading) {
                                Color.clear
                                Text(verbatim: "caps lock").font(.footnote)
                        }
                        .padding(.vertical, verticalPadding + 5)
                        .padding(.horizontal, horizontalPadding + 5)
                }
                .frame(width: keyWidth, height: keyHeight)
                .contentShape(Rectangle())
                .gesture(DragGesture(minimumDistance: 0)
                        .updating($isTouching) { _, tapped, _ in
                                if tapped.negative {
                                        AudioFeedback.modified()
                                        tapped = true
                                }
                        }
                        .onEnded { _ in
                                context.operate(.doubleShift)
                         }
                )
        }
}
