import SwiftUI
import CommonExtensions

struct EditingPanelReturnKey: View {

        @EnvironmentObject private var context: KeyboardViewController
        @Environment(\.colorScheme) private var colorScheme
        @GestureState private var isTouching: Bool = false

        var body: some View {
                let inset = context.keyboardInterface.editingKeyInset
                let isDefaultReturn: Bool = context.returnKeyType.isDefaultReturn
                let keyState: ReturnKeyState = context.returnKeyState
                let glassBackColor: Color = {
                        guard isTouching.negative else { return Color.clear }
                        switch keyState {
                        case .standbyABC, .standbyMutilated, .standbyTraditional:
                                return isDefaultReturn ? Color.clear : Color.accentColor
                        default:
                                return Color.clear
                        }
                }()
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
                ZStack {
                        Color.interactiveClear
                        if #available(iOSApplicationExtension 26.0, *) {
                                glassBackColor
                                        .clipShape(.rect(cornerRadius: PresetConstant.ultraKeyCornerRadius))
                                        .glassEffect(isTouching ? .regular : .clear, in: .rect(cornerRadius: PresetConstant.ultraKeyCornerRadius))
                                        .shadow(color: isTouching ? colorScheme.glassShadow : Color.clear, radius: 0.5)
                                        .padding(isTouching ? (inset - 2) : inset)
                        } else {
                                RoundedRectangle(cornerRadius: PresetConstant.ultraKeyCornerRadius)
                                        .fill(backColor)
                                        .shadow(color: .shadowGray, radius: 0.5, y: 0.5)
                                        .padding(isTouching ? (inset - 2) : inset)
                        }
                        VStack(spacing: 4) {
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
                                Text(context.returnKeyText).font(.labelCaption)
                        }
                        .foregroundStyle(foreColor)
                }
                .contentShape(.rect)
                .gesture(DragGesture(minimumDistance: 0)
                        .updating($isTouching) { _, isTouchBegan, _ in
                                if isTouchBegan.negative {
                                        isTouchBegan = true
                                        AudioFeedback.modified()
                                        context.triggerHapticFeedback()
                                }
                        }
                        .onEnded { _ in
                                context.operate(.return)
                        }
                )
        }
}
