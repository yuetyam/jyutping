import SwiftUI

struct NumericSymbolicSwitchKey: View {

        @EnvironmentObject private var context: KeyboardViewController

        @Environment(\.colorScheme) private var colorScheme
        private var keyColor: Color {
                switch colorScheme {
                case .light:
                        return .lightEmphatic
                case .dark:
                        return .darkEmphatic
                @unknown default:
                        return .lightEmphatic
                }
        }
        private var activeKeyColor: Color {
                switch colorScheme {
                case .light:
                        return .light
                case .dark:
                        return .dark
                @unknown default:
                        return .light
                }
        }

        private var keyText: String {
                switch context.keyboardForm {
                case .numeric:
                        return "#+="
                case .symbolic:
                        return "123"
                default:
                        return "#+="
                }
        }

        @GestureState private var isTouching: Bool = false

        var body: some View {
                ZStack {
                        Color.interactiveClear
                        RoundedRectangle(cornerRadius: 5, style: .continuous)
                                .fill(isTouching ? activeKeyColor : keyColor)
                                .shadow(color: .black.opacity(0.4), radius: 0.5, y: 1)
                                .padding(.vertical, 6)
                                .padding(.horizontal, 3)
                        Text(verbatim: keyText)
                }
                .frame(width: context.widthUnit * 1.3, height: context.heightUnit)
                .contentShape(Rectangle())
                .gesture(DragGesture(minimumDistance: 0)
                        .updating($isTouching) { _, tapped, _ in
                                if !tapped {
                                        AudioFeedback.modified()
                                        context.triggerHapticFeedback()
                                        tapped = true
                                }
                        }
                        .onEnded { _ in
                                let newForm: KeyboardForm = {
                                        switch context.keyboardForm {
                                        case .symbolic:
                                                return .numeric
                                        case .numeric:
                                                return .symbolic
                                        default:
                                                return .alphabetic
                                        }
                                }()
                                context.updateKeyboardForm(to: newForm)
                         }
                )
        }
}
