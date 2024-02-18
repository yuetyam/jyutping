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
        private var keyActiveColor: Color {
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
                let shouldPreviewKey: Bool = Options.keyTextPreview
                let activeColor: Color = shouldPreviewKey ? keyColor : keyActiveColor
                let shouldShowLowercaseKeys: Bool = Options.showLowercaseKeys && context.keyboardCase.isLowercased
                let textCase: Text.Case = shouldShowLowercaseKeys ? .lowercase : .uppercase
                let shouldAdjustKeyTextPosition: Bool = shouldShowLowercaseKeys && (context.keyboardForm == .alphabetic)
                if let stroke {
                        ZStack {
                                Color.interactiveClear
                                if (isTouching && shouldPreviewKey) {
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
                                                .fill(isTouching ? activeColor : keyColor)
                                                .shadow(color: .black.opacity(0.4), radius: 0.5, y: 1)
                                                .padding(.vertical, 6)
                                                .padding(.horizontal, 3)
                                        ZStack(alignment: .topTrailing) {
                                                Color.clear
                                                Text(verbatim: letter)
                                                        .textCase(textCase)
                                                        .font(.footnote)
                                                        .foregroundStyle(Color.secondary)
                                                        .padding(5)
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
                                        let text: String = context.keyboardCase.isLowercased ? letter : letter.uppercased()
                                        context.operate(.process(text))
                                }
                        )
                } else {
                        ZStack {
                                RoundedRectangle(cornerRadius: 5, style: .continuous)
                                        .fill(keyColor)
                                        .shadow(color: .black.opacity(0.4), radius: 0.5, y: 1)
                                        .padding(.vertical, 6)
                                        .padding(.horizontal, 3)
                                Text(verbatim: letter)
                                        .textCase(textCase)
                                        .foregroundStyle(Color.secondary)
                                        .padding(.bottom, shouldAdjustKeyTextPosition ? 3 : 0)
                        }
                        .frame(width: context.widthUnit, height: context.heightUnit)
                        .contentShape(Rectangle())
                        .onTapGesture {
                                AudioFeedback.inputed()
                                context.triggerHapticFeedback()
                                let text: String = context.keyboardCase.isLowercased ? letter : letter.uppercased()
                                context.operate(.process(text))
                        }
                }
        }
}
