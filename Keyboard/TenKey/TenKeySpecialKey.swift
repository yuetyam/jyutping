import SwiftUI
import CommonExtensions

struct TenKeySpecialKey: View {

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

        var body: some View {
                ZStack {
                        Color.interactiveClear
                        RoundedRectangle(cornerRadius: PresetConstant.largeKeyCornerRadius, style: .continuous)
                                .fill(isTouching ? keyActiveColor : keyColor)
                                .shadow(color: .shadowGray, radius: 0.5, y: 0.5)
                                .padding(3)
                        #if DEBUG
                        if context.inputStage.isBuffering {
                                VStack {
                                        Text(verbatim: String.separator)
                                        Text(verbatim: PresetConstant.separate)
                                                .font(.keyFootnote)
                                                .shallow()
                                }
                                .padding(.top, 8)
                        } else {
                                VStack(spacing: 0) {
                                        Text(verbatim: "rvxq")
                                        Text(verbatim: "反查")
                                                .font(.keyFootnote)
                                                .shallow()
                                }
                                .padding(.top, 8)
                        }
                        #endif
                }
                .frame(width: context.tenKeyWidthUnit, height: context.heightUnit)
                .contentShape(Rectangle())
                .gesture(DragGesture(minimumDistance: 0)
                        .updating($isTouching) { _, tapped, _ in
                                if tapped.negative {
                                        AudioFeedback.inputed()
                                        context.triggerHapticFeedback()
                                        tapped = true
                                }
                        }
                        .onEnded { _ in
                                if context.inputStage.isBuffering {
                                        context.operate(.separate)
                                } else {
                                        let text: String = "r"
                                        context.operate(.process(text))
                                }
                         }
                )
                .disabled(true)
        }
}
