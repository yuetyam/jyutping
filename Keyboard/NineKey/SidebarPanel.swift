import SwiftUI

@available(iOS 26.0, *)
@available(iOSApplicationExtension 26.0, *)
struct GlassSidebarPanel: View {

        @EnvironmentObject private var context: KeyboardViewController
        @Environment(\.colorScheme) private var colorScheme

        private let punctuation: [String] = ["，", "。", "？", "！", "、", "：", "；", "／", "…", "~", "～"]

        private let symbols: [String] = ["+", "-", "*", "/", "=", "%", ":", "@", "#", ",", "$", "~", "≈", "×", "÷"]

        var body: some View {
                let texts: [String] = context.keyboardForm.isDedicatedNumbers ? symbols : punctuation
                ZStack {
                        Color.clear
                        if context.inputStage.isBuffering {
                                SidebarScrollView()
                        } else {
                                SymbolSidebarScrollView(texts: texts)
                        }
                }
                .clipShape(.rect(cornerRadius: PresetConstant.largeKeyCornerRadius))
                .glassEffect(.clear, in: .rect(cornerRadius: PresetConstant.largeKeyCornerRadius))
                .padding(3)
                .frame(width: context.nineKeyWidthUnit * 0.91, height: context.heightUnit * 3)
        }
}

struct SidebarPanel: View {

        @EnvironmentObject private var context: KeyboardViewController
        @Environment(\.colorScheme) private var colorScheme

        private let punctuation: [String] = ["，", "。", "？", "！", "、", "：", "；", "／", "…", "~", "～"]

        private let symbols: [String] = ["+", "-", "*", "/", "=", "%", ":", "@", "#", ",", "$", "~", "≈", "×", "÷"]

        var body: some View {
                let texts: [String] = context.keyboardForm.isDedicatedNumbers ? symbols : punctuation
                ZStack {
                        RoundedRectangle(cornerRadius: PresetConstant.largeKeyCornerRadius)
                                .fill(colorScheme.actionKeyColor)
                                .shadow(color: .shadowGray, radius: 0.5, y: 0.5)
                        if #available(iOSApplicationExtension 18.0, *) {
                                if context.inputStage.isBuffering {
                                        SidebarScrollView()
                                } else {
                                        SymbolSidebarScrollView(texts: texts)
                                }
                        } else if #available(iOSApplicationExtension 17.0, *) {
                                if context.inputStage.isBuffering {
                                        SidebarScrollViewIOS17()
                                } else {
                                        SymbolSidebarScrollViewIOS17(texts: texts)
                                }
                        } else {
                                if context.inputStage.isBuffering {
                                        SidebarScrollViewIOS16()
                                } else {
                                        SymbolSidebarScrollViewIOS16(texts: texts)
                                }
                        }
                }
                .clipShape(.rect(cornerRadius: PresetConstant.largeKeyCornerRadius))
                .padding(3)
                .frame(width: context.nineKeyWidthUnit * 0.91, height: context.heightUnit * 3)
        }
}
