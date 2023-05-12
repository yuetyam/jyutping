import SwiftUI

struct SpaceKey: View {

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

        var body: some View {
                ZStack {
                        Color.interactiveClear
                        RoundedRectangle(cornerRadius: 5, style: .continuous)
                                .fill(keyColor)
                                .shadow(color: .black.opacity(0.4), radius: 0.5, y: 1)
                                .padding(.vertical, 6)
                                .padding(.horizontal, 3)
                        Text(verbatim: context.spaceText)
                }
                .frame(width: context.widthUnit * 4.5, height: context.heightUnit)
                .contentShape(Rectangle())
                .gesture(TapGesture(count: 2).onEnded {
                        context.operate(.doubleSpace)
                })
                .simultaneousGesture(TapGesture().onEnded {
                        context.operate(.space)
                })
        }
}
