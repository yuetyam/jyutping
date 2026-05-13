import SwiftUI
import CommonExtensions

@available(iOS 26.0, *)
@available(iOSApplicationExtension 26.0, *)
struct GlassTailoredNavigateKey: View {

        let destination: KeyboardForm

        @EnvironmentObject private var context: KeyboardViewController
        @Environment(\.colorScheme) private var colorScheme

        private var keyText: String {
                switch destination {
                case .alphabetic:
                        return "ABC"
                case .numeric:
                        return context.preferredNumericForm.isNineKeyNumeric ? "#@$" : "123"
                case .symbolic:
                        return "#+="
                case .nineKeyNumeric:
                        return "123"
                default:
                        return "???"
                }
        }

        @GestureState private var isTouching: Bool = false

        var body: some View {
                ZStack {
                        Color.interactiveClear
                        Text(verbatim: keyText).font(.staticBody)
                }
                .glassEffect(isTouching ? .regular : .clear, in: RoundedRectangle(cornerRadius: PresetConstant.largeKeyCornerRadius, style: .continuous))
                .shadow(color: isTouching ? colorScheme.glassShadow : Color.clear, radius: 0.5)
                .padding(3)
                .frame(width: context.nineKeyWidthUnit * 0.94, height: context.heightUnit)
                .contentShape(.rect)
                .gesture(DragGesture(minimumDistance: 0)
                        .updating($isTouching) { _, tapped, _ in
                                if tapped.negative {
                                        AudioFeedback.inputed()
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

struct TailoredNavigateKey: View {

        let destination: KeyboardForm

        @EnvironmentObject private var context: KeyboardViewController
        @Environment(\.colorScheme) private var colorScheme

        private var keyText: String {
                switch destination {
                case .alphabetic:
                        return "ABC"
                case .numeric:
                        return context.preferredNumericForm.isNineKeyNumeric ? "#@$" : "123"
                case .symbolic:
                        return "#+="
                case .nineKeyNumeric:
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
                .frame(width: context.nineKeyWidthUnit * 0.94, height: context.heightUnit)
                .contentShape(.rect)
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
