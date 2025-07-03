import SwiftUI

struct LargePadGlobeKey: View {

        let widthUnitTimes: CGFloat

        @EnvironmentObject private var context: KeyboardViewController
        @Environment(\.colorScheme) private var colorScheme

        var body: some View {
                let keyWidth: CGFloat = context.widthUnit * widthUnitTimes
                let keyHeight: CGFloat = context.heightUnit
                let isLandscape: Bool = context.keyboardInterface.isPadLandscape
                let verticalPadding: CGFloat = isLandscape ? 5 : 4
                let horizontalPadding: CGFloat = isLandscape ? 5 : 4
                ZStack {
                        Color.interactiveClear
                        RoundedRectangle(cornerRadius: PresetConstant.largeKeyCornerRadius, style: .continuous)
                                .fill(colorScheme.isDark ? Color.darkAction : Color.lightAction)
                                .shadow(color: .shadowGray, radius: 0.5, y: 0.5)
                                .padding(.vertical, verticalPadding)
                                .padding(.horizontal, horizontalPadding)
                        ZStack(alignment: .bottomLeading) {
                                Color.clear
                                Image.globe
                        }
                        .padding(.vertical, verticalPadding + 7)
                        .padding(.horizontal, horizontalPadding + 7)
                        UIGlobeButton()
                }
                .frame(width: keyWidth, height: keyHeight)
        }
}
