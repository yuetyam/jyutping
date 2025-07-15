import SwiftUI
import CommonExtensions

struct LargePadCapsLockKey: View {

        let widthUnitTimes: CGFloat

        @EnvironmentObject private var context: KeyboardViewController
        @Environment(\.colorScheme) private var colorScheme

        private var backColor: Color {
                if #available(iOSApplicationExtension 26.0, *) {
                        return isTouching ? colorScheme.activeActionKeyColor : colorScheme.actionKeyColor
                } else {
                        return context.keyboardCase.isCapsLocked ? colorScheme.activeActionKeyColor : colorScheme.actionKeyColor
                }
        }

        @GestureState private var isTouching: Bool = false

        var body: some View {
                let keyWidth: CGFloat = context.widthUnit * widthUnitTimes
                let keyHeight: CGFloat = context.heightUnit
                let isLandscape: Bool = context.keyboardInterface.isPadLandscape
                let verticalPadding: CGFloat = isLandscape ? 5 : 4
                let horizontalPadding: CGFloat = isLandscape ? 5 : 4
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
                                        .fill(context.keyboardCase.isCapsLocked ? Color.green : colorScheme.activeActionKeyColor.opacity(0.75))
                                        .frame(width: 5, height: 5)
                        }
                        .padding(.vertical, verticalPadding + 8)
                        .padding(.horizontal, horizontalPadding + 8)
                        ZStack(alignment: .bottomLeading) {
                                Color.clear
                                Text(verbatim: "caps lock")
                        }
                        .padding(.vertical, verticalPadding + 7)
                        .padding(.horizontal, horizontalPadding + 7)
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
