import SwiftUI

struct PadGlobeKey: View {

        let widthUnitTimes: CGFloat

        @EnvironmentObject private var context: KeyboardViewController
        @Environment(\.colorScheme) private var colorScheme

        var body: some View {
                let keyWidth: CGFloat = context.widthUnit * widthUnitTimes
                let keyHeight: CGFloat = context.heightUnit
                let keyColor = colorScheme.actionKeyBackground(style: context.appearanceStyle, isInteracting: false)
                let insets = context.keyboardInterface.keyShapeInsets
                ZStack {
                        Color.interactiveClear
                        RoundedRectangle(cornerRadius: PresetConstant.largeKeyCornerRadius)
                                .fill(keyColor)
                                .shadow(color: .shadowGray, radius: 0.5, y: 0.5)
                                .padding(insets)
                        Image.globe.font(.title3)
                        UIGlobeButton()
                }
                .frame(width: keyWidth, height: keyHeight)
        }
}
