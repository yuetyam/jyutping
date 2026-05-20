import SwiftUI
import CommonExtensions

@available(iOS 26.0, *)
@available(iOSApplicationExtension 26.0, *)
struct GlassNumberPad: View {

        let isDecimalPad: Bool

        @EnvironmentObject private var context: KeyboardViewController

        var body: some View {
                let keyWidth: CGFloat = context.keyboardWidth / 3.0
                let keyHeight: CGFloat = (context.keyboardHeight - 8) / 4.0
                VStack(spacing: 0) {
                        HStack(spacing: 0) {
                                GlassNumberPadKey(digit: "1", letters: nil, width: keyWidth, height: keyHeight)
                                GlassNumberPadKey(digit: "2", letters: "ABC", width: keyWidth, height: keyHeight)
                                GlassNumberPadKey(digit: "3", letters: "DEF", width: keyWidth, height: keyHeight)
                        }
                        HStack(spacing: 0) {
                                GlassNumberPadKey(digit: "4", letters: "GHI", width: keyWidth, height: keyHeight)
                                GlassNumberPadKey(digit: "5", letters: "JKL", width: keyWidth, height: keyHeight)
                                GlassNumberPadKey(digit: "6", letters: "MNO", width: keyWidth, height: keyHeight)
                        }
                        HStack(spacing: 0) {
                                GlassNumberPadKey(digit: "7", letters: "PQRS", width: keyWidth, height: keyHeight)
                                GlassNumberPadKey(digit: "8", letters: "TUV", width: keyWidth, height: keyHeight)
                                GlassNumberPadKey(digit: "9", letters: "WXYZ", width: keyWidth, height: keyHeight)
                        }
                        HStack(spacing: 0) {
                                DecimalPadPointKey(width: keyWidth, height: keyHeight).opacity(isDecimalPad ? 1 : 0)
                                GlassNumberPadKey(digit: "0", letters: nil, width: keyWidth, height: keyHeight)
                                NumberPadBackspaceKey(width: keyWidth, height: keyHeight)
                        }
                }
                .padding(.vertical, 4)
        }
}

@available(iOS 26.0, *)
@available(iOSApplicationExtension 26.0, *)
private struct GlassNumberPadKey: View {

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
                        VStack {
                                Text(verbatim: digit)
                                        .font(.title)
                                Text(verbatim: letters ?? String.space)
                                        .font(.caption2.weight(.semibold))
                                        .tracking(1.5)
                        }
                }
                .glassEffect(isTouching ? .regular : .clear, in: RoundedRectangle(cornerRadius: PresetConstant.ultraKeyCornerRadius, style: .continuous))
                .shadow(color: isTouching ? colorScheme.glassShadow : Color.clear, radius: 0.5)
                .padding(4)
                .frame(width: width, height: height)
                .contentShape(.rect)
                .gesture(DragGesture(minimumDistance: 0)
                        .updating($isTouching) { _, tapped, _ in
                                if tapped.negative {
                                        tapped = true
                                        AudioFeedback.inputed()
                                        context.triggerHapticFeedback()
                                        context.operate(.input(digit))
                                }
                        }
                )
        }
}

struct NumberPad: View {

        let isDecimalPad: Bool

        @EnvironmentObject private var context: KeyboardViewController

        var body: some View {
                let keyWidth: CGFloat = context.keyboardWidth / 3.0
                let keyHeight: CGFloat = (context.keyboardHeight - 8) / 4.0
                VStack(spacing: 0) {
                        HStack(spacing: 0) {
                                LegacyNumberPadKey(digit: "1", letters: nil, width: keyWidth, height: keyHeight)
                                LegacyNumberPadKey(digit: "2", letters: "ABC", width: keyWidth, height: keyHeight)
                                LegacyNumberPadKey(digit: "3", letters: "DEF", width: keyWidth, height: keyHeight)
                        }
                        HStack(spacing: 0) {
                                LegacyNumberPadKey(digit: "4", letters: "GHI", width: keyWidth, height: keyHeight)
                                LegacyNumberPadKey(digit: "5", letters: "JKL", width: keyWidth, height: keyHeight)
                                LegacyNumberPadKey(digit: "6", letters: "MNO", width: keyWidth, height: keyHeight)
                        }
                        HStack(spacing: 0) {
                                LegacyNumberPadKey(digit: "7", letters: "PQRS", width: keyWidth, height: keyHeight)
                                LegacyNumberPadKey(digit: "8", letters: "TUV", width: keyWidth, height: keyHeight)
                                LegacyNumberPadKey(digit: "9", letters: "WXYZ", width: keyWidth, height: keyHeight)
                        }
                        HStack(spacing: 0) {
                                DecimalPadPointKey(width: keyWidth, height: keyHeight).opacity(isDecimalPad ? 1 : 0)
                                LegacyNumberPadKey(digit: "0", letters: nil, width: keyWidth, height: keyHeight)
                                NumberPadBackspaceKey(width: keyWidth, height: keyHeight)
                        }
                }
                .padding(.vertical, 4)
        }
}

private struct LegacyNumberPadKey: View {

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
                        RoundedRectangle(cornerRadius: PresetConstant.ultraKeyCornerRadius, style: .continuous)
                                .fill(isTouching ? colorScheme.activeInputKeyColor : colorScheme.inputKeyColor)
                                .shadow(color: .shadowGray, radius: 0.5, y: 0.5)
                                .padding(4)
                        VStack {
                                Text(verbatim: digit)
                                        .font(.title)
                                Text(verbatim: letters ?? String.space)
                                        .font(.caption2.weight(.semibold))
                                        .tracking(1.5)
                        }
                }
                .frame(width: width, height: height)
                .contentShape(.rect)
                .gesture(DragGesture(minimumDistance: 0)
                        .updating($isTouching) { _, tapped, _ in
                                if tapped.negative {
                                        tapped = true
                                        AudioFeedback.inputed()
                                        context.triggerHapticFeedback()
                                        context.operate(.input(digit))
                                }
                        }
                )
        }
}

private struct DecimalPadPointKey: View {

        let width: CGFloat
        let height: CGFloat

        @EnvironmentObject private var context: KeyboardViewController
        @GestureState private var isTouching: Bool = false
        private let keyText: String = String.period

        var body: some View {
                Button {
                        AudioFeedback.inputed()
                        context.triggerHapticFeedback()
                        context.operate(.input(keyText))
                } label: {
                        ZStack {
                                Color.interactiveClear
                                VStack {
                                        Text(verbatim: keyText)
                                                .font(.title)
                                        Text(verbatim: keyText)
                                                .font(.caption2.weight(.semibold))
                                                .hidden()
                                }
                        }
                        .frame(width: width, height: height)
                }
                .buttonStyle(.plain)
        }
}

private struct NumberPadBackspaceKey: View {

        let width: CGFloat
        let height: CGFloat

        @EnvironmentObject private var context: KeyboardViewController
        @GestureState private var isTouching: Bool = false
        @State private var buffer: Int = 0

        var body: some View {
                ZStack {
                        Color.interactiveClear
                        Image.backspace
                                .symbolVariant(isTouching ? .fill : .none)
                                .font(.title2)
                }
                .frame(width: width, height: height)
                .contentShape(.rect)
                .gesture(DragGesture(minimumDistance: 0)
                        .updating($isTouching) { _, tapped, _ in
                                if tapped.negative {
                                        tapped = true
                                        AudioFeedback.deleted()
                                        context.triggerHapticFeedback()
                                        context.operate(.backspace)
                                }
                        }
                        .onEnded { _ in
                                buffer = 0
                        }
                )
                .task {
                        while Task.isCancelled.negative {
                                try? await Task.sleep(for: .milliseconds(100)) // 0.1s
                                if isTouching {
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
        }
}
