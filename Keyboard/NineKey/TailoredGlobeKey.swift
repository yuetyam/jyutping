import SwiftUI

@available(iOS 26.0, *)
@available(iOSApplicationExtension 26.0, *)
struct GlassTailoredGlobeKey: View {

        @EnvironmentObject private var context: KeyboardViewController
        @Environment(\.colorScheme) private var colorScheme

        var body: some View {
                ZStack {
                        Color.interactiveClear
                        Image.globe.font(.symbol)
                        UIGlobeButton()
                }
                .glassEffect(.clear, in: RoundedRectangle(cornerRadius: PresetConstant.largeKeyCornerRadius, style: .continuous))
                .padding(3)
                .frame(width: context.nineKeyWidthUnit * 0.94, height: context.heightUnit)
        }
}

struct TailoredGlobeKey: View {

        @EnvironmentObject private var context: KeyboardViewController
        @Environment(\.colorScheme) private var colorScheme

        var body: some View {
                ZStack {
                        Color.interactiveClear
                        RoundedRectangle(cornerRadius: PresetConstant.largeKeyCornerRadius, style: .continuous)
                                .fill(colorScheme.actionKeyColor)
                                .shadow(color: .shadowGray, radius: 0.5, y: 0.5)
                                .padding(3)
                        Image.globe.font(.symbol)
                        UIGlobeButton()
                }
                .frame(width: context.nineKeyWidthUnit * 0.94, height: context.heightUnit)
        }
}
