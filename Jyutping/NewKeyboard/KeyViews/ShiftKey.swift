import SwiftUI

struct ShiftKey: View {

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

        var body: some View {
                ZStack {
                        Color.interactiveClear
                        RoundedRectangle(cornerRadius: 5, style: .continuous)
                                .fill(keyColor)
                                .shadow(color: .black.opacity(0.4), radius: 0.5, y: 1)
                                .padding(.vertical, 6)
                                .padding(.horizontal, 3)
                        switch context.keyboardType {
                        case .abc(.capsLocked), .cantonese(.capsLocked), .saamPing(.capsLocked):
                                Image(systemName: "capslock.fill")
                        case .abc(.uppercased), .cantonese(.uppercased), .saamPing(.uppercased):
                                Image(systemName: "shift.fill")
                        default:
                                Image(systemName: "shift")
                        }
                }
                .frame(width: context.widthUnit * 1.25, height: context.heightUnit)
                .contentShape(Rectangle())
                .gesture(TapGesture(count: 2).onEnded {
                        context.operate(.doubleShift)
                })
                .simultaneousGesture(TapGesture().onEnded {
                        context.operate(.shift)
                })
        }
}
