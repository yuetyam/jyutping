import SwiftUI
import CoreIME

struct PadStrokeInputKey: View {

        private let strokeMap: [String: String] = ["w": "⼀", "s": "⼁", "a": "⼃", "d": "⼂", "z": "⼄"]

        init(_ letter: String) {
                self.letter = letter
                self.stroke = strokeMap[letter]
        }

        private let letter: String
        private let stroke: String?

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
                if let stroke {
                        ZStack {
                                Color.interactiveClear
                                RoundedRectangle(cornerRadius: 5, style: .continuous)
                                        .fill(isTouching ? activeKeyColor : keyColor)
                                        .shadow(color: .black.opacity(0.4), radius: 0.5, y: 1)
                                        .padding(5)
                                ZStack(alignment: .topTrailing) {
                                        Color.clear
                                        Text(verbatim: letter)
                                                .font(.footnote)
                                                .foregroundColor(.secondary)
                                                .padding(8)
                                }
                                Text(verbatim: stroke)
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
                } else {
                        ZStack {
                                RoundedRectangle(cornerRadius: 5, style: .continuous)
                                        .fill(keyColor)
                                        .shadow(color: .black.opacity(0.4), radius: 0.5, y: 1)
                                        .padding(5)
                                Text(verbatim: letter).foregroundColor(.secondary)
                        }
                        .frame(width: context.widthUnit, height: context.heightUnit)
                        .contentShape(Rectangle())
                        .onTapGesture {
                                AudioFeedback.inputed()
                                context.operate(.process(letter))
                        }
                }
        }
}
