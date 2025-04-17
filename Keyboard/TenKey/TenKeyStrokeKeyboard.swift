import SwiftUI
import CoreIME
import CommonExtensions

struct TenKeyStrokeKeyboard: View {
        var body: some View {
                VStack(spacing: 0) {
                        CandidateBar()
                        HStack(spacing: 0) {
                                VStack(spacing: 0) {
                                        HStack(spacing: 0) {
                                                StrokePlaceholderActionKey(heightUnitTimes: 3).disabled(true)
                                                VStack(spacing: 0) {
                                                        HStack(spacing: 0) {
                                                                TenKeyStrokeKey(1)
                                                                TenKeyStrokeKey(2)
                                                                TenKeyStrokeKey(3)
                                                        }
                                                        HStack(spacing: 0) {
                                                                TenKeyStrokeKey(4)
                                                                TenKeyStrokeKey(5)
                                                                TenKeyStrokeKey(6)
                                                        }
                                                        HStack(spacing: 0) {
                                                                StrokePlaceholderInputKey().disabled(true)
                                                                StrokePlaceholderInputKey().disabled(true)
                                                                StrokePlaceholderInputKey().disabled(true)
                                                        }
                                                }
                                        }
                                        HStack(spacing: 0) {
                                                StrokePlaceholderActionKey(heightUnitTimes: 1).disabled(true)
                                                TenKeySpaceKey()
                                        }
                                }
                                VStack(spacing: 0) {
                                        TenKeyBackspaceKey()
                                        StrokePlaceholderActionKey(heightUnitTimes: 1).disabled(true)
                                        TenKeyReturnKey()
                                }
                        }
                }
        }
}

private struct TenKeyStrokeKey: View {

        init(_ digit: Int) {
                let number: String = "\(digit)"
                self.mappedKey = CharacterStandard.strokeTransform(number)
                self.keyText = PresetConstant.strokeKeyMap[number] ?? number
        }

        private let mappedKey: String
        private let keyText: String

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
                                .shadow(color: .shadowGray, radius: 0.5, y: 0.5)
                                .padding(3)
                        Text(verbatim: keyText).font(.letterInputKeyCompact)
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
                                context.operate(.process(mappedKey))
                         }
                )
        }
}

private struct StrokePlaceholderInputKey: View {
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
        var body: some View {
                RoundedRectangle(cornerRadius: 5, style: .continuous)
                        .fill(keyColor)
                        .shadow(color: .shadowGray, radius: 0.5, y: 0.5)
                        .padding(3)
                        .frame(width: context.tenKeyWidthUnit, height: context.heightUnit)
        }
}
private struct StrokePlaceholderActionKey: View {
        let heightUnitTimes: CGFloat
        @EnvironmentObject private var context: KeyboardViewController
        @Environment(\.colorScheme) private var colorScheme
        private var keyColor: Color {
                switch colorScheme {
                case .light:
                        return .lightEmphatic
                case .dark:
                        return .darkEmphatic
                @unknown default:
                        return .lightEmphatic
                }
        }
        var body: some View {
                RoundedRectangle(cornerRadius: 5, style: .continuous)
                        .fill(keyColor)
                        .shadow(color: .shadowGray, radius: 0.5, y: 0.5)
                        .padding(3)
                        .frame(width: context.tenKeyWidthUnit, height: context.heightUnit * heightUnitTimes)
        }
}
