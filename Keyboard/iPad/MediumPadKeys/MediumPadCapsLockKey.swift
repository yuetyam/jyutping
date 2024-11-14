import SwiftUI
import CommonExtensions

struct MediumPadCapsLockKey: View {

        let widthUnitTimes: CGFloat

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

        var body: some View {
                let keyWidth: CGFloat = context.widthUnit * widthUnitTimes
                let keyHeight: CGFloat = context.heightUnit
                let isLandscape: Bool = context.keyboardInterface.isPadLandscape
                let verticalPadding: CGFloat = isLandscape ? 7 : 5
                let horizontalPadding: CGFloat = isLandscape ? 7 : 5
                ZStack {
                        Color.interactiveClear
                        RoundedRectangle(cornerRadius: 5, style: .continuous)
                                .fill(context.keyboardCase.isCapsLocked ? activeKeyColor : keyColor)
                                .shadow(color: .shadowGray, radius: 0.5, y: 0.5)
                                .padding(.vertical, verticalPadding)
                                .padding(.horizontal, horizontalPadding)
                        ZStack(alignment: .topLeading) {
                                Color.clear
                                Circle()
                                        .fill(context.keyboardCase.isCapsLocked ? Color.green : activeKeyColor.opacity(0.8))
                                        .frame(width: 4, height: 4)
                        }
                        .padding(.vertical, verticalPadding + 5)
                        .padding(.horizontal, horizontalPadding + 5)
                        ZStack(alignment: .bottomLeading) {
                                Color.clear
                                Text(verbatim: "caps lock")
                                        .font(.footnote)
                        }
                        .padding(.vertical, verticalPadding + 5)
                        .padding(.horizontal, horizontalPadding + 5)
                }
                .frame(width: keyWidth, height: keyHeight)
                .contentShape(Rectangle())
                .onTapGesture {
                        AudioFeedback.modified()
                        context.operate(.doubleShift)
                }
        }
}
