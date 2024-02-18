import SwiftUI

struct PadPullableInputKey: View {

        let upper: String
        let lower: String

        @EnvironmentObject private var context: KeyboardViewController

        @Environment(\.colorScheme) private var colorScheme
        private var keyColor: Color {
                switch colorScheme {
                case .light:
                        return .light
                case .dark:
                        return .dark
                @unknown default:
                        return .light
                }
        }
        private var activeKeyColor: Color {
                switch colorScheme {
                case .light:
                        return .lightEmphatic
                case .dark:
                        return .darkEmphatic
                @unknown default:
                        return .lightEmphatic
                }
        }
        private var keyPreviewColor: Color {
                switch colorScheme {
                case .light:
                        return .light
                case .dark:
                        return .darkOpacity
                @unknown default:
                        return .light
                }
        }

        @GestureState private var isTouching: Bool = false
        @State private var isPullingDown: Bool = false

        var body: some View {
                let shouldShowLowercaseKeys: Bool = Options.showLowercaseKeys && context.keyboardCase.isLowercased
                let textCase: Text.Case = shouldShowLowercaseKeys ? .lowercase : .uppercase
                ZStack {
                        Color.interactiveClear
                        RoundedRectangle(cornerRadius: 5, style: .continuous)
                                .fill(isTouching ? activeKeyColor : keyColor)
                                .shadow(color: .black.opacity(0.4), radius: 0.5, y: 1)
                                .padding(5)
                        if isPullingDown {
                                Text(verbatim: upper)
                                        .textCase(textCase)
                                        .font(.title2)
                        } else {
                                ZStack(alignment: .top) {
                                        Color.clear
                                        Text(verbatim: upper)
                                                .textCase(textCase)
                                                .font(.footnote)
                                                .padding(.top, 10)
                                                .opacity(0.3)
                                }
                                ZStack(alignment: .bottom) {
                                        Color.clear
                                        Text(verbatim: lower)
                                                .textCase(textCase)
                                                .font(.title2)
                                                .padding(.bottom, 12)
                                }
                        }
                }
                .frame(width: context.widthUnit, height: context.heightUnit)
                .contentShape(Rectangle())
                .gesture(DragGesture(minimumDistance: 0)
                        .updating($isTouching) { _, tapped, _ in
                                if !tapped {
                                        AudioFeedback.inputed()
                                        tapped = true
                                }
                        }
                        .onChanged { state in
                                guard !isPullingDown else { return }
                                let distance: CGFloat = state.translation.height
                                guard distance > 16 else { return }
                                isPullingDown = true
                        }
                        .onEnded { _ in
                                if isPullingDown {
                                        let text: String = upper
                                        context.operate(.process(text))
                                        isPullingDown = false
                                } else {
                                        let text: String = context.keyboardCase.isLowercased ? lower : lower.uppercased()
                                        context.operate(.process(text))
                                }
                         }
                )
        }
}
