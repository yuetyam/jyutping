import SwiftUI
import CommonExtensions

@available(iOS 26.0, *)
@available(iOSApplicationExtension 26.0, *)
struct EditingPanelGlassEnterKey: View {

        @EnvironmentObject private var context: KeyboardViewController
        @Environment(\.colorScheme) private var colorScheme
        @State private var isTouching: Bool = false

        var body: some View {
                let inset = context.keyboardInterface.editingKeyInset
                let isDefaultReturn: Bool = context.enterKeyType.isDefaultReturn
                let keyState: EnterKeyState = context.enterKeyState
                let glassBackColor: Color = {
                        guard isTouching.negative else { return Color.clear }
                        switch keyState {
                        case .standbyABC, .standbyMutilated, .standbyTraditional:
                                return isDefaultReturn ? Color.clear : Color.accentColor
                        default:
                                return Color.clear
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
                                glassBackColor
                                        .clipShape(.rect(cornerRadius: PresetConstant.ultraKeyCornerRadius))
                                        .glassEffect(isTouching ? .regular : .clear, in: .rect(cornerRadius: PresetConstant.ultraKeyCornerRadius))
                                        .shadow(color: isTouching ? colorScheme.glassShadow : Color.clear, radius: 0.5)
                                        .padding(isTouching ? (inset - 2) : inset)
                                VStack(spacing: 4) {
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
                                        Text(context.enterKeyText).font(.labelCaption)
                                }
                                .foregroundStyle(foreColor)
                        }
                }
                .buttonStyle(PressButtonStyle($isTouching) {
                        context.performAudioFeedback(.modify)
                        context.triggerHapticFeedback()
                        context.operate(.return)
                })
        }
}

struct EditingPanelEnterKey: View {

        @EnvironmentObject private var context: KeyboardViewController
        @Environment(\.colorScheme) private var colorScheme
        @State private var isTouching: Bool = false

        var body: some View {
                let inset = context.keyboardInterface.editingKeyInset
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
                                RoundedRectangle(cornerRadius: PresetConstant.ultraKeyCornerRadius)
                                        .fill(backColor)
                                        .shadow(color: .shadowGray, radius: 0.5, y: 0.5)
                                        .padding(isTouching ? (inset - 2) : inset)
                                VStack(spacing: 4) {
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
                                        Text(context.enterKeyText).font(.labelCaption)
                                }
                                .foregroundStyle(foreColor)
                        }
                }
                .buttonStyle(PressButtonStyle($isTouching) {
                        context.performAudioFeedback(.modify)
                        context.triggerHapticFeedback()
                        context.operate(.return)
                })
        }
}
