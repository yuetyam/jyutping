import SwiftUI
import Combine
import CommonExtensions

struct NumberPad: View {

        let isDecimalPad: Bool

        @EnvironmentObject private var context: KeyboardViewController

        var body: some View {
                let keyWidth: CGFloat = context.keyboardWidth / 3.0
                let keyHeight: CGFloat = (context.keyboardHeight - 16) / 4.0
                VStack(spacing: 0) {
                        HStack(spacing: 0) {
                                NumberPadKey(digit: "1", letters: nil, width: keyWidth, height: keyHeight)
                                NumberPadKey(digit: "2", letters: "ABC", width: keyWidth, height: keyHeight)
                                NumberPadKey(digit: "3", letters: "DEF", width: keyWidth, height: keyHeight)
                        }
                        HStack(spacing: 0) {
                                NumberPadKey(digit: "4", letters: "GHI", width: keyWidth, height: keyHeight)
                                NumberPadKey(digit: "5", letters: "JKL", width: keyWidth, height: keyHeight)
                                NumberPadKey(digit: "6", letters: "MNO", width: keyWidth, height: keyHeight)
                        }
                        HStack(spacing: 0) {
                                NumberPadKey(digit: "7", letters: "PQRS", width: keyWidth, height: keyHeight)
                                NumberPadKey(digit: "8", letters: "TUV", width: keyWidth, height: keyHeight)
                                NumberPadKey(digit: "9", letters: "WXYZ", width: keyWidth, height: keyHeight)
                        }
                        HStack(spacing: 0) {
                                DecimalPadPointKey(width: keyWidth, height: keyHeight).opacity(isDecimalPad ? 1 : 0)
                                NumberPadKey(digit: "0", letters: nil, width: keyWidth, height: keyHeight)
                                NumberPadBackspaceKey(width: keyWidth, height: keyHeight)
                        }
                }
                .padding(.vertical, 8)
        }
}

private struct NumberPadKey: View {

        let digit: String
        let letters: String?
        let width: CGFloat
        let height: CGFloat

        @EnvironmentObject private var context: KeyboardViewController
        @Environment(\.colorScheme) private var colorScheme

        @GestureState private var isTouching: Bool = false

        var body: some View {
                ZStack {
                        Color.interactiveClear
                        RoundedRectangle(cornerRadius: PresetConstant.largeKeyCornerRadius, style: .continuous)
                                .fill(isTouching ? colorScheme.activeInputKeyColor : colorScheme.inputKeyColor)
                                .shadow(color: .shadowGray, radius: 0.5, y: 0.5)
                                .padding(4)
                        VStack {
                                Text(verbatim: digit).font(.title2)
                                Text(verbatim: letters ?? String.space).font(.system(size: 10, weight: .semibold)).tracking(1.5)
                        }
                }
                .frame(width: width, height: height)
                .contentShape(Rectangle())
                .gesture(DragGesture(minimumDistance: 0)
                        .updating($isTouching) { _, tapped, _ in
                                guard tapped.negative else { return }
                                AudioFeedback.inputed()
                                context.triggerHapticFeedback()
                                tapped = true
                        }
                        .onEnded { _ in
                                context.operate(.input(digit))
                         }
                )
        }
}

private struct DecimalPadPointKey: View {

        let width: CGFloat
        let height: CGFloat

        @EnvironmentObject private var context: KeyboardViewController

        @GestureState private var isTouching: Bool = false

        var body: some View {
                ZStack {
                        Color.interactiveClear
                        VStack {
                                Text(verbatim: ".").font(.title)
                                Text(verbatim: String.space).font(.system(size: 10, weight: .semibold))
                        }
                }
                .frame(width: width, height: height)
                .contentShape(Rectangle())
                .onTapGesture {
                        AudioFeedback.inputed()
                        context.triggerHapticFeedback()
                        context.operate(.input("."))
                }
        }
}

private struct NumberPadBackspaceKey: View {

        let width: CGFloat
        let height: CGFloat

        @EnvironmentObject private var context: KeyboardViewController

        @GestureState private var isTouching: Bool = false
        @State private var buffer: Int = 0
        private let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

        var body: some View {
                ZStack {
                        Color.interactiveClear
                        Image.backspace.symbolVariant(isTouching ? .fill : .none)
                }
                .frame(width: width, height: height)
                .contentShape(Rectangle())
                .gesture(DragGesture(minimumDistance: 0)
                        .updating($isTouching) { _, tapped, _ in
                                guard tapped.negative else { return }
                                AudioFeedback.deleted()
                                context.triggerHapticFeedback()
                                context.operate(.backspace)
                                tapped = true
                        }
                        .onEnded { _ in
                                buffer = 0
                         }
                )
                .onReceive(timer) { _ in
                        guard isTouching else { return }
                        if buffer > 3 {
                                AudioFeedback.deleted()
                                context.triggerHapticFeedback()
                                context.operate(.backspace)
                        } else {
                                buffer += 1
                        }
                }
        }
}
