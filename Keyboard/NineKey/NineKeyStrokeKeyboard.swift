import SwiftUI
import CoreIME
import CommonExtensions

@available(iOS 26.0, *)
@available(iOSApplicationExtension 26.0, *)
struct GlassNineKeyStrokeKeyboard: View {
        var body: some View {
                VStack(spacing: 0) {
                        CandidateBar()
                        if Options.needsNumberRow {
                                CantoneseNumberRow()
                        }
                        HStack(spacing: 0) {
                                VStack(spacing: 0) {
                                        HStack(spacing: 0) {
                                                GlassStrokePlaceholderKey(widthCoefficient: 0.94, heightCoefficient: 3).disabled(true)
                                                VStack(spacing: 0) {
                                                        HStack(spacing: 0) {
                                                                GlassStrokeKey(.horizontal)
                                                                GlassStrokeKey(.vertical)
                                                                GlassStrokeKey(.leftFalling)
                                                        }
                                                        HStack(spacing: 0) {
                                                                GlassStrokeKey(.rightFalling)
                                                                GlassStrokeKey(.turning)
                                                                GlassStrokeKey(.wildcard)
                                                        }
                                                        HStack(spacing: 0) {
                                                                GlassStrokePlaceholderKey().disabled(true)
                                                                GlassStrokePlaceholderKey().disabled(true)
                                                                GlassStrokePlaceholderKey().disabled(true)
                                                        }
                                                }
                                        }
                                        HStack(spacing: 0) {
                                                GlassStrokePlaceholderKey(widthCoefficient: 0.94).disabled(true)
                                                NineKeySpaceKey()
                                        }
                                }
                                VStack(spacing: 0) {
                                        GlassNineKeyBackspaceKey()
                                        GlassStrokePlaceholderKey(widthCoefficient: 0.94).disabled(true)
                                        NineKeyReturnKey()
                                }
                        }
                }
        }
}

struct NineKeyStrokeKeyboard: View {
        var body: some View {
                VStack(spacing: 0) {
                        CandidateBar()
                        if Options.needsNumberRow {
                                CantoneseNumberRow()
                        }
                        HStack(spacing: 0) {
                                VStack(spacing: 0) {
                                        HStack(spacing: 0) {
                                                LegacyStrokePlaceholderKey(widthCoefficient: 0.94, heightCoefficient: 3).disabled(true)
                                                VStack(spacing: 0) {
                                                        HStack(spacing: 0) {
                                                                LegacyStrokeKey(.horizontal)
                                                                LegacyStrokeKey(.vertical)
                                                                LegacyStrokeKey(.leftFalling)
                                                        }
                                                        HStack(spacing: 0) {
                                                                LegacyStrokeKey(.rightFalling)
                                                                LegacyStrokeKey(.turning)
                                                                LegacyStrokeKey(.wildcard)
                                                        }
                                                        HStack(spacing: 0) {
                                                                LegacyStrokePlaceholderKey().disabled(true)
                                                                LegacyStrokePlaceholderKey().disabled(true)
                                                                LegacyStrokePlaceholderKey().disabled(true)
                                                        }
                                                }
                                        }
                                        HStack(spacing: 0) {
                                                LegacyStrokePlaceholderKey(widthCoefficient: 0.94).disabled(true)
                                                NineKeySpaceKey()
                                        }
                                }
                                VStack(spacing: 0) {
                                        NineKeyBackspaceKey()
                                        LegacyStrokePlaceholderKey(widthCoefficient: 0.94).disabled(true)
                                        NineKeyReturnKey()
                                }
                        }
                }
        }
}

@available(iOS 26.0, *)
@available(iOSApplicationExtension 26.0, *)
private struct GlassStrokeKey: View {
        init(_ key: StrokeVirtualKey) {
                self.key = key
                self.text = key.strokeText ?? "?"
        }
        private let key: StrokeVirtualKey
        private let text: String

        @EnvironmentObject private var context: KeyboardViewController
        @Environment(\.colorScheme) private var colorScheme

        @GestureState private var isTouching: Bool = false

        var body: some View {
                ZStack {
                        Color.interactiveClear
                        Text(verbatim: text).font(.letterCompact)
                }
                .glassEffect(isTouching ? .regular : .clear, in: RoundedRectangle(cornerRadius: PresetConstant.largeKeyCornerRadius, style: .continuous))
                .shadow(color: isTouching ? colorScheme.glassShadow : Color.clear, radius: 0.5)
                .padding(3)
                .frame(width: context.nineKeyWidthUnit * 1.04, height: context.heightUnit)
                .contentShape(Rectangle())
                .gesture(DragGesture(minimumDistance: 0)
                        .updating($isTouching) { _, tapped, _ in
                                if tapped.negative {
                                        AudioFeedback.inputed()
                                        context.triggerHapticFeedback()
                                        tapped = true
                                }
                        }
                        .onEnded { _ in
                                context.handle(key.virtualInputKey)
                        }
                )
        }
}

private struct LegacyStrokeKey: View {

        init(_ key: StrokeVirtualKey) {
                self.key = key
                self.text = key.strokeText ?? "?"
        }

        private let key: StrokeVirtualKey
        private let text: String

        @EnvironmentObject private var context: KeyboardViewController
        @Environment(\.colorScheme) private var colorScheme

        @GestureState private var isTouching: Bool = false

        var body: some View {
                ZStack {
                        Color.interactiveClear
                        RoundedRectangle(cornerRadius: PresetConstant.largeKeyCornerRadius, style: .continuous)
                                .fill(isTouching ? colorScheme.activeInputKeyColor : colorScheme.inputKeyColor)
                                .shadow(color: .shadowGray, radius: 0.5, y: 0.5)
                                .padding(3)
                        Text(verbatim: text).font(.letterCompact)
                }
                .frame(width: context.nineKeyWidthUnit * 1.04, height: context.heightUnit)
                .contentShape(Rectangle())
                .gesture(DragGesture(minimumDistance: 0)
                        .updating($isTouching) { _, tapped, _ in
                                if tapped.negative {
                                        AudioFeedback.inputed()
                                        context.triggerHapticFeedback()
                                        tapped = true
                                }
                        }
                        .onEnded { _ in
                                context.handle(key.virtualInputKey)
                         }
                )
        }
}

@available(iOS 26.0, *)
@available(iOSApplicationExtension 26.0, *)
private struct GlassStrokePlaceholderKey: View {
        @EnvironmentObject private var context: KeyboardViewController
        init(widthCoefficient: CGFloat = 1.04, heightCoefficient: CGFloat = 1) {
                self.widthCoefficient = widthCoefficient
                self.heightCoefficient = heightCoefficient
        }
        private let widthCoefficient: CGFloat
        private let heightCoefficient: CGFloat
        var body: some View {
                Color.interactiveClear
                        .glassEffect(.clear, in: RoundedRectangle(cornerRadius: PresetConstant.largeKeyCornerRadius, style: .continuous))
                        .padding(3)
                        .frame(width: context.nineKeyWidthUnit * widthCoefficient, height: context.heightUnit * heightCoefficient)
        }
}

private struct LegacyStrokePlaceholderKey: View {
        @EnvironmentObject private var context: KeyboardViewController
        init(widthCoefficient: CGFloat = 1.04, heightCoefficient: CGFloat = 1) {
                self.widthCoefficient = widthCoefficient
                self.heightCoefficient = heightCoefficient
        }
        private let widthCoefficient: CGFloat
        private let heightCoefficient: CGFloat
        var body: some View {
                RoundedRectangle(cornerRadius: PresetConstant.largeKeyCornerRadius, style: .continuous)
                        .fill(Material.regular)
                        .shadow(color: .shadowGray, radius: 0.5, y: 0.5)
                        .padding(3)
                        .frame(width: context.nineKeyWidthUnit * widthCoefficient, height: context.heightUnit * heightCoefficient)
        }
}
