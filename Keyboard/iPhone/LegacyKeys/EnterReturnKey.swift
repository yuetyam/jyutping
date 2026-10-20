import SwiftUI
import CommonExtensions

struct EnterReturnKey: View {

        init(coefficient: CGFloat = 2) {
                self.coefficient = coefficient
        }
        private let coefficient: CGFloat

        @EnvironmentObject private var context: KeyboardViewController
        @Environment(\.colorScheme) private var colorScheme
        @State private var isTouching: Bool = false

        var body: some View {
                let keyWidth: CGFloat = context.widthUnit * coefficient
                let keyHeight: CGFloat = context.heightUnit
                let insets = context.keyboardInterface.keyShapeInsets
                let isDefaultReturn: Bool = context.enterKeyType.isDefaultReturn
                let keyState: EnterKeyState = context.enterKeyState
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
                                RoundedRectangle(cornerRadius: PresetConstant.keyCornerRadius)
                                        .fill(backColor)
                                        .shadow(color: .shadowGray, radius: 0.5, y: 0.5)
                                        .padding(insets)
                                switch (keyState.isBuffering, isDefaultReturn) {
                                case (true, _):
                                        Text(context.enterKeyText).font(.staticBody)
                                case (false, true):
                                        Image.return
                                default:
                                        ZStack(alignment: .bottomTrailing) {
                                                Color.clear
                                                Text(context.enterKeyText).font(.labelCaption)
                                        }
                                        .padding(insets.plused(1))
                                        switch context.enterKeyType {
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
                                }
                        }
                        .font(.symbol)
                        .foregroundStyle(foreColor)
                        .frame(width: keyWidth, height: keyHeight)
                }
                .buttonStyle(PressButtonStyle($isTouching) {
                        AudioFeedback.modified()
                        context.triggerHapticFeedback()
                        context.operate(.return)
                })
        }
}
