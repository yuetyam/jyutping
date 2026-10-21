import SwiftUI
import CommonExtensions

struct PadReturnKey: View {

        let widthUnitTimes: CGFloat

        @EnvironmentObject private var context: KeyboardViewController
        @Environment(\.colorScheme) private var colorScheme

        @State private var isTouching: Bool = false

        var body: some View {
                let keyWidth: CGFloat = context.widthUnit * widthUnitTimes
                let keyHeight: CGFloat = context.heightUnit
                let isLandscape: Bool = context.keyboardInterface.isPadLandscape
                let verticalPadding: CGFloat = isLandscape ? 7 : 5
                let horizontalPadding: CGFloat = isLandscape ? 7 : 5
                let isDefaultReturn: Bool = context.enterKeyType.isDefaultReturn
                let keyState: EnterKeyState = context.enterKeyState
                let backColor: Color = switch (isDefaultReturn, keyState.isStandby) {
                case (false, true): Color.accentColor
                default: colorScheme.actionKeyBackground(style: context.appearanceStyle, isInteracting: isTouching)
                }
                let foreColor: Color = {
                        guard isTouching.negative else { return Color.primary }
                        switch keyState {
                        case .bufferingMutilated, .bufferingTraditional:
                                return Color.primary
                        case .standbyABC, .standbyMutilated, .standbyTraditional:
                                return isDefaultReturn ? Color.primary : Color.white
                        case .unavailableABC, .unavailableMutilated, .unavailableTraditional:
                                return Color.primary.opacity(0.5)
                        }
                }()
                Button(action: {}) {
                        ZStack {
                                Color.interactiveClear
                                RoundedRectangle(cornerRadius: PresetConstant.largeKeyCornerRadius)
                                        .fill(backColor)
                                        .shadow(color: .shadowGray, radius: 0.5, y: 0.5)
                                        .padding(.vertical, verticalPadding)
                                        .padding(.horizontal, horizontalPadding)
                                switch (keyState.isBuffering, isDefaultReturn) {
                                case (true, _):
                                        Text(context.enterKeyText).foregroundStyle(foreColor)
                                case (false, true):
                                        Image.return.foregroundStyle(foreColor)
                                default:
                                        ZStack(alignment: .bottomTrailing) {
                                                Color.clear
                                                Text(context.enterKeyText)
                                                        .font(.labelCaption)
                                                        .foregroundStyle(foreColor)
                                        }
                                        .padding(.vertical, verticalPadding + 2)
                                        .padding(.horizontal, horizontalPadding + 4)
                                        switch context.enterKeyType {
                                        case .continue, .next:
                                                Image.chevronForward.foregroundStyle(foreColor)
                                        case .done:
                                                Image.checkmark.font(.title3).foregroundStyle(foreColor)
                                        case .go, .route, .join:
                                                Image.arrowForward.font(.title3).foregroundStyle(foreColor)
                                        case .search, .google, .yahoo:
                                                Image.search.font(.title3).foregroundStyle(foreColor)
                                        case .send:
                                                Image.arrowUp.font(.title3).foregroundStyle(foreColor)
                                        default:
                                                Image.return.font(.title3).foregroundStyle(foreColor)
                                        }
                                }
                        }
                        .frame(width: keyWidth, height: keyHeight)
                }
                .buttonStyle(PressButtonStyle($isTouching) {
                        context.performAudioFeedback(.modify)
                        context.operate(.return)
                })
        }
}
