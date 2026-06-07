import SwiftUI
import CommonExtensions

@available(iOS 26.0, *)
@available(iOSApplicationExtension 26.0, *)
struct GlassTailoredNavigateKey: View {

        let destination: KeyboardForm

        @EnvironmentObject private var context: KeyboardViewController
        @Environment(\.colorScheme) private var colorScheme
        @GestureState private var isTouching: Bool = false

        private var keyText: String {
                switch destination {
                case .primary:
                        return "ABC"
                case .numeric:
                        return context.preferredNumericForm.isTailoredNumbers ? "#@$" : "123"
                case .symbolic:
                        return "#+="
                case .tailoredNumbers:
                        return "123"
                default:
                        return "???"
                }
        }

        var body: some View {
                ZStack {
                        Color.interactiveClear
                        ZStack {
                                Color.clear
                                Text(verbatim: keyText).font(.staticBody)
                        }
                        .glassEffect(isTouching ? .regular : .clear, in: RoundedRectangle(cornerRadius: PresetConstant.largeKeyCornerRadius, style: .continuous))
                        .shadow(color: isTouching ? colorScheme.glassShadow : Color.clear, radius: 0.5)
                        .padding(isTouching ? 1 : 3)
                }
                .frame(width: context.nineKeyWidthUnit * 0.91, height: context.heightUnit)
                .contentShape(.rect)
                .gesture(DragGesture(minimumDistance: 0)
                        .updating($isTouching) { _, isTouchBegan, _ in
                                if isTouchBegan.negative {
                                        isTouchBegan = true
                                        AudioFeedback.modified()
                                        context.triggerHapticFeedback()
                                }
                        }
                        .onEnded { _ in
                                context.updateKeyboardForm(to: destination)
                        }
                )
        }
}

struct TailoredNavigateKey: View {

        let destination: KeyboardForm

        @EnvironmentObject private var context: KeyboardViewController
        @Environment(\.colorScheme) private var colorScheme
        @GestureState private var isTouching: Bool = false

        private var keyText: String {
                switch destination {
                case .primary:
                        return "ABC"
                case .numeric:
                        return context.preferredNumericForm.isTailoredNumbers ? "#@$" : "123"
                case .symbolic:
                        return "#+="
                case .tailoredNumbers:
                        return "123"
                default:
                        return "???"
                }
        }

        var body: some View {
                ZStack {
                        Color.interactiveClear
                        RoundedRectangle(cornerRadius: PresetConstant.largeKeyCornerRadius, style: .continuous)
                                .fill(isTouching ? colorScheme.activeActionKeyColor : colorScheme.actionKeyColor)
                                .shadow(color: .shadowGray, radius: 0.5, y: 0.5)
                                .padding(isTouching ? 1 : 3)
                        Text(verbatim: keyText).font(.staticBody)
                }
                .frame(width: context.nineKeyWidthUnit * 0.91, height: context.heightUnit)
                .contentShape(.rect)
                .gesture(DragGesture(minimumDistance: 0)
                        .updating($isTouching) { _, isTouchBegan, _ in
                                if isTouchBegan.negative {
                                        isTouchBegan = true
                                        AudioFeedback.modified()
                                        context.triggerHapticFeedback()
                                }
                        }
                        .onEnded { _ in
                                context.updateKeyboardForm(to: destination)
                        }
                )
        }
}
