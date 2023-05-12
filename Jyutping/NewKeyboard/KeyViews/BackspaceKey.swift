import SwiftUI

struct BackspaceKey: View {

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
                        Image(systemName: "delete.backward")
                }
                .frame(width: context.widthUnit * 1.25, height: context.heightUnit)
                .contentShape(Rectangle())
                .gesture(DragGesture(minimumDistance: 44, coordinateSpace: .local)
                        .onEnded { value in
                                let horizontalTranslation = value.translation.width
                                guard horizontalTranslation < -44 else { return }
                                context.operate(.clear)
                         }
                )
                .simultaneousGesture(TapGesture().onEnded {
                        context.operate(.backspace)
                })
        }
}
