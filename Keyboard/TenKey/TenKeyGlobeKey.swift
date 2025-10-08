import SwiftUI

struct TenKeyGlobeKey: View {

        @EnvironmentObject private var context: KeyboardViewController
        @Environment(\.colorScheme) private var colorScheme

        var body: some View {
                let width: CGFloat = context.tenKeyWidthUnit
                let height: CGFloat = context.heightUnit
                ZStack {
                        Color.interactiveClear
                        RoundedRectangle(cornerRadius: PresetConstant.largeKeyCornerRadius, style: .continuous)
                                .fill(colorScheme.actionKeyColor)
                                .shadow(color: .shadowGray, radius: 0.5, y: 0.5)
                                .padding(3)
                        Image.globe.font(.symbol)
                        UIGlobeButton()
                }
                .frame(width: width, height: height)
        }
}
