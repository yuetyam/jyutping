import SwiftUI
import CommonExtensions
import CoreIME

struct PadPullableInputKey: View {

        init(event: InputEvent? = nil, upper: String, lower: String) {
                self.event = event
                self.upper = upper
                self.lower = lower
        }

        private let event: InputEvent?
        private let upper: String
        private let lower: String

        @EnvironmentObject private var context: KeyboardViewController

        @Environment(\.colorScheme) private var colorScheme

        private var keyColor: Color {
                switch colorScheme {
                case .light:
                        return .lightInput
                case .dark:
                        return .darkInput
                @unknown default:
                        return .lightInput
                }
        }
        private var keyActiveColor: Color {
                switch colorScheme {
                case .light:
                        return .activeLightInput
                case .dark:
                        return .activeDarkInput
                @unknown default:
                        return .activeLightInput
                }
        }

        @GestureState private var isTouching: Bool = false
        @State private var isPullingDown: Bool = false

        var body: some View {
                let keyWidth: CGFloat = context.widthUnit
                let keyHeight: CGFloat = context.heightUnit
                let isLandscape: Bool = context.keyboardInterface.isPadLandscape
                let verticalPadding: CGFloat = isLandscape ? 7 : 5
                let horizontalPadding: CGFloat = isLandscape ? 7 : 5
                let shouldShowLowercaseKeys: Bool = Options.showLowercaseKeys && context.keyboardCase.isLowercased
                let textCase: Text.Case = shouldShowLowercaseKeys ? .lowercase : .uppercase
                ZStack {
                        Color.interactiveClear
                        RoundedRectangle(cornerRadius: PresetConstant.largeKeyCornerRadius, style: .continuous)
                                .fill(isTouching ? keyActiveColor : keyColor)
                                .shadow(color: .shadowGray, radius: 0.5, y: 0.5)
                                .padding(.vertical, verticalPadding)
                                .padding(.horizontal, horizontalPadding)
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
                                                .opacity(0.3)
                                }
                                .padding(.vertical, verticalPadding + 5)
                                .padding(.horizontal, horizontalPadding + 5)
                                ZStack(alignment: .bottom) {
                                        Color.clear
                                        Text(verbatim: lower)
                                                .textCase(textCase)
                                                .font(.title2)
                                }
                                .padding(.vertical, verticalPadding + 7)
                                .padding(.horizontal, horizontalPadding + 7)
                        }
                }
                .frame(width: keyWidth, height: keyHeight)
                .contentShape(Rectangle())
                .gesture(DragGesture(minimumDistance: 0)
                        .updating($isTouching) { _, tapped, _ in
                                if tapped.negative {
                                        AudioFeedback.inputed()
                                        tapped = true
                                }
                        }
                        .onChanged { state in
                                guard isPullingDown.negative else { return }
                                let distance: CGFloat = state.translation.height
                                guard distance > 16 else { return }
                                isPullingDown = true
                        }
                        .onEnded { _ in
                                if isPullingDown {
                                        let text: String = context.keyboardCase.isLowercased ? upper : upper.uppercased()
                                        context.operate(.process(text))
                                        isPullingDown = false
                                } else if let event {
                                        context.handle(event)
                                } else {
                                        let text: String = context.keyboardCase.isLowercased ? lower : lower.uppercased()
                                        context.operate(.process(text))
                                }
                         }
                )
        }
}
