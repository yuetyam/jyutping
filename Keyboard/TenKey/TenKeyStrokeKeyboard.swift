import SwiftUI
import CoreIME
import CommonExtensions

struct TenKeyStrokeKeyboard: View {
        var body: some View {
                VStack(spacing: 0) {
                        CandidateBar()
                        if Options.needsNumberRow {
                                CantoneseNumberRow()
                        }
                        HStack(spacing: 0) {
                                VStack(spacing: 0) {
                                        HStack(spacing: 0) {
                                                StrokePlaceholderKey(heightUnitTimes: 3).disabled(true)
                                                VStack(spacing: 0) {
                                                        HStack(spacing: 0) {
                                                                TenKeyStrokeKey(.horizontal)
                                                                TenKeyStrokeKey(.vertical)
                                                                TenKeyStrokeKey(.leftFalling)
                                                        }
                                                        HStack(spacing: 0) {
                                                                TenKeyStrokeKey(.rightFalling)
                                                                TenKeyStrokeKey(.turning)
                                                                TenKeyStrokeKey(.wildcard)
                                                        }
                                                        HStack(spacing: 0) {
                                                                StrokePlaceholderKey().disabled(true)
                                                                StrokePlaceholderKey().disabled(true)
                                                                StrokePlaceholderKey().disabled(true)
                                                        }
                                                }
                                        }
                                        HStack(spacing: 0) {
                                                StrokePlaceholderKey().disabled(true)
                                                TenKeySpaceKey()
                                        }
                                }
                                VStack(spacing: 0) {
                                        TenKeyBackspaceKey()
                                        StrokePlaceholderKey().disabled(true)
                                        TenKeyReturnKey()
                                }
                        }
                }
        }
}

private struct TenKeyStrokeKey: View {

        init(_ event: StrokeEvent) {
                self.event = event
                self.keyText = event.strokeText ?? "?"
        }

        private let event: StrokeEvent
        private let keyText: String

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
                        Text(verbatim: keyText).font(.letterCompact)
                }
                .frame(width: context.tenKeyWidthUnit, height: context.heightUnit)
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
                                context.handle(event.inputEvent)
                         }
                )
        }
}

private struct StrokePlaceholderKey: View {
        @EnvironmentObject private var context: KeyboardViewController
        init(heightUnitTimes: CGFloat = 1) {
                self.heightUnitTimes = heightUnitTimes
        }
        private let heightUnitTimes: CGFloat
        var body: some View {
                RoundedRectangle(cornerRadius: PresetConstant.largeKeyCornerRadius, style: .continuous)
                        .fill(Material.regular)
                        .shadow(color: .shadowGray, radius: 0.5, y: 0.5)
                        .padding(3)
                        .frame(width: context.tenKeyWidthUnit, height: context.heightUnit * heightUnitTimes)
        }
}
