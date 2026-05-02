import SwiftUI

@available(iOS 26.0, *)
@available(iOSApplicationExtension 26.0, *)
struct GlassSidebarPanel: View {

        @EnvironmentObject private var context: KeyboardViewController
        @Environment(\.colorScheme) private var colorScheme

        private let punctuation: [String] = ["，", "。", "？", "！", "、", "：", "；", "／", "…", "~", "～"]

        private let symbols: [String] = ["+", "-", "*", "/", "=", "%", ":", "@", "#", ",", "$", "~", "≈"]

        var body: some View {
                let texts: [String] = context.keyboardForm.isNineKeyNumeric ? symbols : punctuation
                ZStack {
                        Color.clear
                        if context.inputStage.isBuffering {
                                SidebarScrollView()
                        } else {
                                SymbolSidebarScrollView(texts: texts)
                        }
                }
                .clipShape(RoundedRectangle(cornerRadius: PresetConstant.largeKeyCornerRadius, style: .continuous))
                .glassEffect(.clear, in: RoundedRectangle(cornerRadius: PresetConstant.largeKeyCornerRadius, style: .continuous))
                .padding(3)
                .frame(width: context.nineKeyWidthUnit, height: context.heightUnit * 3)
        }
}

struct SidebarPanel: View {

        @EnvironmentObject private var context: KeyboardViewController
        @Environment(\.colorScheme) private var colorScheme

        private let punctuation: [String] = ["，", "。", "？", "！", "、", "：", "；", "／", "…", "~", "～"]

        private let symbols: [String] = ["+", "-", "*", "/", "=", "%", ":", "@", "#", ",", "$", "~", "≈"]

        var body: some View {
                let texts: [String] = context.keyboardForm.isNineKeyNumeric ? symbols : punctuation
                ZStack {
                        RoundedRectangle(cornerRadius: PresetConstant.largeKeyCornerRadius, style: .continuous)
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
                .clipShape(RoundedRectangle(cornerRadius: PresetConstant.largeKeyCornerRadius, style: .continuous))
                .padding(3)
                .frame(width: context.nineKeyWidthUnit, height: context.heightUnit * 3)
        }
}
