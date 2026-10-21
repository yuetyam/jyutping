import SwiftUI

@available(iOS 26.0, *)
@available(iOSApplicationExtension 26.0, *)
struct GlassTailoredGlobeKey: View {

        @EnvironmentObject private var context: KeyboardViewController
        @Environment(\.colorScheme) private var colorScheme

        var body: some View {
                ZStack {
                        Color.interactiveClear
                        Color.clear
                                .glassEffect(.clear, in: .rect(cornerRadius: PresetConstant.largeKeyCornerRadius))
                                .padding(3)
                        Image.globe.font(.symbol)
                        UIGlobeButton()
                }
                .frame(width: context.nineKeyWidthUnit * PresetConstant.tailoredActionKeyWidthCoefficient, height: context.heightUnit)
        }
}

struct TailoredGlobeKey: View {

        @EnvironmentObject private var context: KeyboardViewController
        @Environment(\.colorScheme) private var colorScheme

        var body: some View {
                ZStack {
                        Color.interactiveClear
                        RoundedRectangle(cornerRadius: PresetConstant.largeKeyCornerRadius)
                                .fill(colorScheme.actionKeyBackground(style: context.appearanceStyle, isInteracting: false))
                                .shadow(color: .shadowGray, radius: 0.5, y: 0.5)
                                .padding(3)
                        Image.globe.font(.symbol)
                        UIGlobeButton()
                }
                .frame(width: context.nineKeyWidthUnit * PresetConstant.tailoredActionKeyWidthCoefficient, height: context.heightUnit)
        }
}
