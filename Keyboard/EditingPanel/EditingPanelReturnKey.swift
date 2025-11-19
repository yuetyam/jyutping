import SwiftUI
import CommonExtensions

struct EditingPanelReturnKey: View {

        @EnvironmentObject private var context: KeyboardViewController
        @Environment(\.colorScheme) private var colorScheme

        @GestureState private var isTouching: Bool = false

        var body: some View {
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
                        RoundedRectangle(cornerRadius: PresetConstant.largeKeyCornerRadius, style: .continuous)
                                .fill(backColor)
                                .shadow(color: .shadowGray, radius: 0.5, y: 0.5)
                                .padding(4)
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
                                Text(context.returnKeyText).font(.keyCaption)
                        }
                        .foregroundStyle(foreColor)
                }
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
