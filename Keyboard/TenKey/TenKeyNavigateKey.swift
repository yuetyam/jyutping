import SwiftUI
import CommonExtensions

struct TenKeyNavigateKey: View {

        let destination: KeyboardForm

        @EnvironmentObject private var context: KeyboardViewController
        @Environment(\.colorScheme) private var colorScheme

        private var keyText: String {
                switch destination {
                case .alphabetic:
                        return "ABC"
                case .numeric:
                        return context.numericLayout.isNumberKeyPad ? "#@$" : "123"
                case .symbolic:
                        return "#+="
                case .tenKeyNumeric:
                        return "123"
                default:
                        return "???"
                }
        }

        @GestureState private var isTouching: Bool = false

        var body: some View {
                ZStack {
                        Color.interactiveClear
                        RoundedRectangle(cornerRadius: PresetConstant.largeKeyCornerRadius, style: .continuous)
                                .fill(isTouching ? colorScheme.activeActionKeyColor : colorScheme.actionKeyColor)
                                .shadow(color: .shadowGray, radius: 0.5, y: 0.5)
                                .padding(3)
                        Text(verbatim: keyText).font(.staticBody)
                }
                .frame(width: context.tenKeyWidthUnit, height: context.heightUnit)
                .contentShape(Rectangle())
                .gesture(DragGesture(minimumDistance: 0)
                        .updating($isTouching) { _, tapped, _ in
                                if tapped.negative {
                                        AudioFeedback.modified()
                                        context.triggerHapticFeedback()
                                        tapped = true
                                }
                        }
                        .onEnded { _ in
                                context.updateKeyboardForm(to: destination)
                         }
                )
        }
}
