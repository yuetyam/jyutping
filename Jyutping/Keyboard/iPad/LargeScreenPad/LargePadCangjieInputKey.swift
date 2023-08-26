import SwiftUI
import CoreIME

struct LargePadCangjieInputKey: View {

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
                                .padding(4)
                        ZStack(alignment: .topTrailing) {
                                Color.clear
                                Text(verbatim: letter)
                                        .font(.footnote)
                                        .foregroundColor(.secondary)
                                        .padding(.top, 8)
                                        .padding(.trailing, 8)
                        }
                        Text(verbatim: radical)
                }
                .frame(width: context.widthUnit, height: context.heightUnit)
                .contentShape(Rectangle())
                .gesture(DragGesture(minimumDistance: 0)
                        .updating($isTouching) { _, tapped, _ in
                                if !tapped {
                                        AudioFeedback.inputed()
                                        tapped = true
                                }
                        }
                        .onEnded { _ in
                                context.operate(.process(letter))
                         }
                )
        }
}
