import SwiftUI

struct GlobeKey: View {

        @EnvironmentObject private var context: KeyboardViewController
        @Environment(\.colorScheme) private var colorScheme

        var body: some View {
                let width: CGFloat = context.widthUnit
                let height: CGFloat = context.heightUnit
                let insets = context.keyboardInterface.keyShapeInsets
                ZStack {
                        Color.interactiveClear
                        RoundedRectangle(cornerRadius: PresetConstant.keyCornerRadius)
                                .fill(colorScheme.isDark ? Color.darkAction : Color.lightAction)
                                .shadow(color: .shadowGray, radius: 0.5, y: 0.5)
                                .padding(insets)
                        Image.globe.font(.symbol)
                        UIGlobeButton()
                }
                .frame(width: width, height: height)
        }
}
