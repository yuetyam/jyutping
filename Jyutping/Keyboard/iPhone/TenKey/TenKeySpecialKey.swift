import SwiftUI

struct TenKeySpecialKey: View {

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

        @GestureState private var isTouching: Bool = false

        var body: some View {
                ZStack {
                        Color.interactiveClear
                        RoundedRectangle(cornerRadius: 5, style: .continuous)
                                .fill(isTouching ? activeKeyColor : keyColor)
                                .shadow(color: .black.opacity(0.4), radius: 0.5, y: 1)
                                .padding(3)
                        if context.inputStage.isBuffering {
                                VStack {
                                        Text(verbatim: "'")
                                        Text(verbatim: "分隔").font(.keyFooter).foregroundStyle(Color.secondary)
                                }
                                .padding(.top, 8)
                        } else {
                                VStack(spacing: 0) {
                                        Text(verbatim: "rvxq")
                                        Text(verbatim: "反查").font(.keyFooter).foregroundStyle(Color.secondary)
                                }
                                .padding(.top, 8)
                        }
                }
                .frame(width: context.widthUnit * 2, height: context.heightUnit)
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
                                let text: String = context.inputStage.isBuffering ? "'" : "r"
                                context.operate(.process(text))
                         }
                )
        }
}
