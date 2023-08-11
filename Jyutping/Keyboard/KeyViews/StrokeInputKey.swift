import SwiftUI
import CoreIME

struct StrokeInputKey: View {

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
                if let stroke {
                        ZStack {
                                Color.interactiveClear
                                if isTouching {
                                        KeyPreviewPath()
                                                .fill(keyPreviewColor)
                                                .shadow(color: .black.opacity(0.5), radius: 1)
                                                .overlay {
                                                        Text(verbatim: stroke)
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
                                        Text(verbatim: stroke)
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
                } else {
                        ZStack {
                                RoundedRectangle(cornerRadius: 5, style: .continuous)
                                        .fill(keyColor)
                                        .shadow(color: .black.opacity(0.4), radius: 0.5, y: 1)
                                        .padding(.vertical, 6)
                                        .padding(.horizontal, 3)
                                Text(verbatim: letter).foregroundColor(.secondary)
                        }
                        .frame(width: context.widthUnit, height: context.heightUnit)
                        .contentShape(Rectangle())
                        .onTapGesture {
                                context.operate(.process(letter))
                        }
                }
        }
}
