import SwiftUI

/// For Large screen iPad Pro only
struct CapsLockKey: View {

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
                ZStack {
                        Color.interactiveClear
                        RoundedRectangle(cornerRadius: 5, style: .continuous)
                                .fill((context.keyboardCase == .capsLocked) ? activeKeyColor : keyColor)
                                .shadow(color: .shadowGray, radius: 0.5, y: 0.5)
                                .padding(4)
                        ZStack(alignment: .topLeading) {
                                Color.clear
                                Circle()
                                        .fill((context.keyboardCase == .capsLocked) ? Color.green : activeKeyColor.opacity(0.8))
                                        .frame(width: 4, height: 4)
                                        .padding(12)
                        }
                        ZStack(alignment: .bottomLeading) {
                                Color.clear
                                Text(verbatim: "caps lock")
                                        .padding(12)
                        }
                }
                .frame(width: context.widthUnit * widthUnitTimes, height: context.heightUnit)
                .contentShape(Rectangle())
                .onTapGesture {
                        AudioFeedback.modified()
                        context.operate(.doubleShift)
                }
        }
}
