import SwiftUI
import CommonExtensions

struct ReturnKey: View {

        @EnvironmentObject private var context: KeyboardViewController
        @Environment(\.colorScheme) private var colorScheme

        @GestureState private var isTouching: Bool = false

        var body: some View {
                let keyWidth: CGFloat = context.widthUnit * 2
                let keyHeight: CGFloat = context.heightUnit
                let isPhoneLandscape: Bool = context.keyboardInterface.isPhoneLandscape
                let verticalPadding: CGFloat = isPhoneLandscape ? 3 : 6
                let horizontalPadding: CGFloat = isPhoneLandscape ? 6 : 3
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
                ZStack {
                        Color.interactiveClear
                        RoundedRectangle(cornerRadius: PresetConstant.keyCornerRadius, style: .continuous)
                                .fill(backColor)
                                .shadow(color: .shadowGray, radius: 0.5, y: 0.5)
                                .padding(.vertical, verticalPadding)
                                .padding(.horizontal, horizontalPadding)
                        switch (keyState.isBuffering, isDefaultReturn) {
                        case (true, _):
                                Text(context.returnKeyText).font(.staticBody)
                        case (false, true):
                                Image.return
                        default:
                                ZStack(alignment: .bottomTrailing) {
                                        Color.clear
                                        Text(context.returnKeyText).font(.keyCaption)
                                }
                                .padding(.vertical, verticalPadding + 1)
                                .padding(.horizontal, horizontalPadding + 1)
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
                        }
                }
                .font(.symbol)
                .foregroundStyle(foreColor)
                .frame(width: keyWidth, height: keyHeight)
                .contentShape(Rectangle())
                .gesture(DragGesture(minimumDistance: 0)
                        .updating($isTouching) { _, tapped, _ in
                                if tapped.negative {
                                        AudioFeedback.modified()
                                        context.triggerHapticFeedback()
                                        tapped = true
                                }
                        }
                        .onEnded { _ in
                                context.operate(.return)
                        }
                )
        }
}
