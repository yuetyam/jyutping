import SwiftUI
import CoreIME

struct LargePadStrokeInputKey: View {

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
                let shouldShowLowercaseKeys: Bool = Options.showLowercaseKeys && context.keyboardCase.isLowercased
                let textCase: Text.Case = shouldShowLowercaseKeys ? .lowercase : .uppercase
                if let stroke {
                        ZStack {
                                Color.interactiveClear
                                RoundedRectangle(cornerRadius: 5, style: .continuous)
                                        .fill(isTouching ? activeKeyColor : keyColor)
                                        .shadow(color: .shadowGray, radius: 0.5, y: 0.5)
                                        .padding(4)
                                ZStack(alignment: .topTrailing) {
                                        Color.clear
                                        Text(verbatim: letter)
                                                .textCase(textCase)
                                                .font(.footnote)
                                                .foregroundStyle(Color.secondary)
                                                .padding(.top, 8)
                                                .padding(.trailing, 8)
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
                                        let text: String = context.keyboardCase.isLowercased ? letter : letter.uppercased()
                                        context.operate(.process(text))
                                }
                        )
                } else {
                        ZStack {
                                RoundedRectangle(cornerRadius: 5, style: .continuous)
                                        .fill(keyColor)
                                        .shadow(color: .shadowGray, radius: 0.5, y: 0.5)
                                        .padding(4)
                                Text(verbatim: letter)
                                        .textCase(textCase)
                                        .foregroundStyle(Color.secondary)
                        }
                        .frame(width: context.widthUnit, height: context.heightUnit)
                        .contentShape(Rectangle())
                        .onTapGesture {
                                AudioFeedback.inputed()
                                let text: String = context.keyboardCase.isLowercased ? letter : letter.uppercased()
                                context.operate(.process(text))
                        }
                }
        }
}
