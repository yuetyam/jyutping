import SwiftUI
import CoreIME

struct CangjieInputKey: View {

        init(_ letter: Character) {
                let radical: Character = Logogram.cangjie(of: letter) ?? "?"
                self.letter = String(letter)
                self.radical = String(radical)
        }

        private let letter: String
        private let radical: String

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
                ZStack {
                        Color.interactiveClear
                        if isTouching {
                                KeyPreview()
                                        .fill(keyPreviewColor)
                                        .shadow(color: .black.opacity(0.5), radius: 1)
                                        .overlay {
                                                Text(verbatim: radical)
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
                                ZStack(alignment: .topTrailing) {
                                        Text(verbatim: letter)
                                                .font(.footnote)
                                                .foregroundColor(.secondary)
                                                .padding(5)
                                        Color.clear
                                }
                                Text(verbatim: radical)
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
                                context.operate(.process(letter))
                         }
                )
        }
}
