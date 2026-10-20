import SwiftUI
import CommonExtensions

struct TailoredReturnKey: View {

        @EnvironmentObject private var context: KeyboardViewController
        @Environment(\.colorScheme) private var colorScheme
        @State private var isTouching: Bool = false

        var body: some View {
                let keyWidth: CGFloat = context.nineKeyWidthUnit * PresetConstant.tailoredActionKeyWidthCoefficient
                let keyHeight: CGFloat = context.heightUnit * 2
                let isDefaultReturn: Bool = context.returnKeyType.isDefaultReturn
                let keyState: ReturnKeyState = context.returnKeyState
                let backColor: Color = {
                        guard isTouching.negative else { return colorScheme.activeActionKeyColor }
                        switch keyState {
                        case .bufferingMutilated, .bufferingTraditional:
                                return colorScheme.actionKeyColor
                        case .standbyABC, .standbyMutilated, .standbyTraditional:
                                return isDefaultReturn ? colorScheme.actionKeyColor : Color.accentColor
                        case .unavailableABC, .unavailableMutilated, .unavailableTraditional:
                                return colorScheme.actionKeyColor
                        }
                }()
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
                                        .padding(isTouching ? 1 : 3)
                                switch (keyState.isBuffering, isDefaultReturn) {
                                case (true, _):
                                        Text(context.returnKeyText)
                                                .font(.staticBody)
                                                .foregroundStyle(foreColor)
                                case (false, true):
                                        Image.return
                                                .font(.symbol)
                                                .foregroundStyle(foreColor)
                                default:
                                        VStack(spacing: 5) {
                                                switch context.returnKeyType {
                                                case .continue, .next:
                                                        Image.chevronForward
                                                case .done:
                                                        Image.checkmark
                                                case .go, .route, .join:
                                                        Image.arrowForward
                                                case .search, .google, .yahoo:
                                                        Image.search
                                                case .send:
                                                        Image.arrowUp
                                                default:
                                                        Image.return
                                                }
                                                Text(context.returnKeyText).font(.footnote)
                                        }
                                        .font(.symbol)
                                        .foregroundStyle(foreColor)
                                }
                        }
                        .frame(width: keyWidth, height: keyHeight)
                }
                .buttonStyle(PressButtonStyle($isTouching) {
                        AudioFeedback.modified()
                        context.triggerHapticFeedback()
                        context.operate(.return)
                })
        }
}
