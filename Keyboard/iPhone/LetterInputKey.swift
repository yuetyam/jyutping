import SwiftUI

struct LetterInputKey: View {

        private let keyText: String
        init(_ keyText: String) {
                self.keyText = keyText
        }

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

        var body: some View {
                let shouldShowLowercaseKeys: Bool = Options.showLowercaseKeys && context.keyboardCase.isLowercased
                let shouldAdjustKeyTextPosition: Bool = shouldShowLowercaseKeys && (context.keyboardForm == .alphabetic)
                ZStack {
                        Color.interactiveClear
                        if isTouching {
                                KeyPreviewPath()
                                        .fill(keyPreviewColor)
                                        .shadow(color: .black.opacity(0.5), radius: 1)
                                        .overlay {
                                                Text(verbatim: keyText)
                                                        .textCase(shouldShowLowercaseKeys ? .lowercase : .uppercase)
                                                        .font(.largeTitle)
                                                        .padding(.bottom, context.heightUnit * 2.0)
                                        }
                                        .padding(.vertical, 6)
                                        .padding(.horizontal, 3)
                        } else {
                                RoundedRectangle(cornerRadius: 5, style: .continuous)
                                        .fill(keyColor)
                                        .shadow(color: .black.opacity(0.4), radius: 0.5, y: 1)
                                        .padding(.vertical, 6)
                                        .padding(.horizontal, 3)
                                Text(verbatim: keyText)
                                        .textCase(shouldShowLowercaseKeys ? .lowercase : .uppercase)
                                        .font(.letterInputKeyCompact)
                                        .padding(.bottom, shouldAdjustKeyTextPosition ? 3 : 0)
                        }
                }
                .frame(width: context.widthUnit, height: context.heightUnit)
                .contentShape(Rectangle())
                .gesture(DragGesture(minimumDistance: 0)
                        .updating($isTouching) { _, tapped, _ in
                                if !tapped {
                                        AudioFeedback.inputed()
                                        context.triggerHapticFeedback()
                                        tapped = true
                                }
                        }
                        .onEnded { _ in
                                let text: String = context.keyboardCase.isLowercased ? keyText : keyText.uppercased()
                                context.operate(.process(text))
                         }
                )
        }
}
