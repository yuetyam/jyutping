import SwiftUI

struct PeriodKey: View {

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
                ZStack {
                        Color.interactiveClear
                        RoundedRectangle(cornerRadius: 5, style: .continuous)
                                .fill(keyColor)
                                .shadow(color: .black.opacity(0.4), radius: 0.5, y: 1)
                                .padding(.vertical, 6)
                                .padding(.horizontal, 3)
                        if context.keyboardType.isABCMode {
                                Text(verbatim: ".")
                        } else {
                                if context.inputStage.isBuffering {
                                        Text(verbatim: "'")
                                        VStack(spacing: 0) {
                                                Text(verbatim: " ").padding(.top, 12)
                                                Spacer()
                                                Text(verbatim: "分隔").font(.keyFooter).foregroundColor(.secondary).padding(.bottom, 12)
                                        }
                                        .frame(width: context.widthUnit, height: context.heightUnit)
                                } else {
                                        Text(verbatim: "。")
                                }
                        }
                }
                .frame(width: context.widthUnit, height: context.heightUnit)
                .contentShape(Rectangle())
                .onTapGesture {
                        if context.keyboardType.isABCMode {
                                context.operate(.punctuation("."))
                        } else {
                                if context.inputStage.isBuffering {
                                        context.operate(.input("'"))
                                } else {
                                        context.operate(.punctuation("。"))
                                }
                        }
                }
        }
}
