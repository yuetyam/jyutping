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
                                                GlassStrokePlaceholderKey(heightCoefficient: 3).disabled(true)
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
                                                GlassStrokePlaceholderKey().disabled(true)
                                                NineKeySpaceKey()
                                        }
                                }
                                VStack(spacing: 0) {
                                        GlassNineKeyBackspaceKey()
                                        GlassStrokePlaceholderKey().disabled(true)
                                        NineKeyReturnKey()
                                }
                        }
                }
        }
}

@available(iOS, introduced: 16.0, deprecated: 26.0, message: "Use GlassNineKeyStrokeKeyboard instead")
@available(iOSApplicationExtension, introduced: 16.0, deprecated: 26.0, message: "Use GlassNineKeyStrokeKeyboard instead")
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
                                                LegacyStrokePlaceholderKey(heightCoefficient: 3).disabled(true)
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
                                                LegacyStrokePlaceholderKey().disabled(true)
                                                NineKeySpaceKey()
                                        }
                                }
                                VStack(spacing: 0) {
                                        NineKeyBackspaceKey()
                                        LegacyStrokePlaceholderKey().disabled(true)
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
                .frame(width: context.nineKeyWidthUnit, height: context.heightUnit)
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

@available(iOS, introduced: 16.0, deprecated: 26.0, message: "Use GlassStrokeKey instead")
@available(iOSApplicationExtension, introduced: 16.0, deprecated: 26.0, message: "Use GlassStrokeKey instead")
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
                .frame(width: context.nineKeyWidthUnit, height: context.heightUnit)
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
        init(heightCoefficient: CGFloat = 1) {
                self.heightCoefficient = heightCoefficient
        }
        private let heightCoefficient: CGFloat
        var body: some View {
                Color.interactiveClear
                        .glassEffect(.clear, in: RoundedRectangle(cornerRadius: PresetConstant.largeKeyCornerRadius, style: .continuous))
                        .padding(3)
                        .frame(width: context.nineKeyWidthUnit, height: context.heightUnit * heightCoefficient)
        }
}

@available(iOS, introduced: 16.0, deprecated: 26.0, message: "Use GlassStrokePlaceholderKey instead")
@available(iOSApplicationExtension, introduced: 16.0, deprecated: 26.0, message: "Use GlassStrokePlaceholderKey instead")
private struct LegacyStrokePlaceholderKey: View {
        @EnvironmentObject private var context: KeyboardViewController
        init(heightCoefficient: CGFloat = 1) {
                self.heightCoefficient = heightCoefficient
        }
        private let heightCoefficient: CGFloat
        var body: some View {
                RoundedRectangle(cornerRadius: PresetConstant.largeKeyCornerRadius, style: .continuous)
                        .fill(Material.regular)
                        .shadow(color: .shadowGray, radius: 0.5, y: 0.5)
                        .padding(3)
                        .frame(width: context.nineKeyWidthUnit, height: context.heightUnit * heightCoefficient)
        }
}
