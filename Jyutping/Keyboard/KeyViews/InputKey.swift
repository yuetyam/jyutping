import SwiftUI

struct InputKey: View {

        init(key: KeyUnit, widthUnitTimes: CGFloat = 1) {
                self.key = key
                self.widthUnitTimes = widthUnitTimes
        }

        private let key: KeyUnit
        private let widthUnitTimes: CGFloat

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

        @GestureState private var isTouching: Bool = false

        var body: some View {
                ZStack {
                        Color.interactiveClear
                        if isTouching {
                                KeyPreview()
                                        .fill(keyColor)
                                        .shadow(color: .black.opacity(0.5), radius: 1)
                                        .overlay {
                                                Text(verbatim: key.primary.center)
                                                        .textCase(context.keyboardCase.isLowercased ? .lowercase : .uppercase)
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
                                Text(verbatim: key.primary.center)
                                        .textCase(context.keyboardCase.isLowercased ? .lowercase : .uppercase)
                                        .font(.system(size: 24))
                                        .padding(.bottom, (context.keyboardForm == .alphabet && context.keyboardCase.isLowercased) ? 3 : 0)
                                // KeyElementView(element: key.primary).font(.title2)
                        }
                }
                .frame(width: context.widthUnit * widthUnitTimes, height: context.heightUnit)
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
                                let text: String = context.keyboardCase.isLowercased ? key.primary.center : key.primary.center.uppercased()
                                context.operate(.input(text))
                         }
                )
        }
}
