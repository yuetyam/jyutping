import SwiftUI

struct CommaKey: View {

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
                ZStack {
                        Color.interactiveClear
                        if isTouching {
                                KeyPreview()
                                        .fill(keyPreviewColor)
                                        .shadow(color: .black.opacity(0.4), radius: 0.5)
                                        .overlay {
                                                CommaKeyText(isABCMode: context.inputMethodMode.isABC, needsInputModeSwitchKey: context.needsInputModeSwitchKey, isBuffering: context.inputStage.isBuffering, width: context.widthUnit, height: context.heightUnit)
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
                                CommaKeyText(isABCMode: context.inputMethodMode.isABC, needsInputModeSwitchKey: context.needsInputModeSwitchKey, isBuffering: context.inputStage.isBuffering, width: context.widthUnit, height: context.heightUnit)
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
                                if context.inputMethodMode.isABC {
                                        if context.needsInputModeSwitchKey {
                                                context.operate(.input("."))
                                        } else {
                                                context.operate(.input(","))
                                        }
                                } else {
                                        if context.inputStage.isBuffering {
                                                context.operate(.process("'"))
                                        } else {
                                                context.operate(.input("，"))
                                        }
                                }
                         }
                )
        }
}

private struct CommaKeyText: View {

        let isABCMode: Bool
        let needsInputModeSwitchKey: Bool
        let isBuffering: Bool
        let width: CGFloat
        let height: CGFloat

        var body: some View {
                if isABCMode {
                        if needsInputModeSwitchKey {
                                Text(verbatim: ".")
                        } else {
                                Text(verbatim: ",")
                        }
                } else {
                        if isBuffering {
                                Text(verbatim: "'")
                                VStack(spacing: 0) {
                                        Text(verbatim: " ").padding(.top, 12)
                                        Spacer()
                                        Text(verbatim: "分隔").font(.keyFooter).foregroundColor(.secondary).padding(.bottom, 12)
                                }
                                .frame(width: width, height:height)
                        } else {
                                Text(verbatim: "，")
                        }
                }
        }
}
