import SwiftUI
import CommonExtensions

struct TenKeyReturnKey: View {

        @EnvironmentObject private var context: KeyboardViewController
        @Environment(\.colorScheme) private var colorScheme

        @GestureState private var isTouching: Bool = false

        var body: some View {
                let isDefaultReturn: Bool = context.returnKeyType.isDefaultReturn
                let keyState: ReturnKeyState = context.returnKeyState
                let backColor: Color = {
                        guard isTouching.negative else { return colorScheme.activeActionKeyColor }
                        switch keyState {
                        case .bufferingSimplified, .bufferingTraditional:
                                return colorScheme.actionKeyColor
                        case .standbyABC, .standbySimplified, .standbyTraditional:
                                return isDefaultReturn ? colorScheme.actionKeyColor : Color.accentColor
                        case .unavailableABC, .unavailableSimplified, .unavailableTraditional:
                                return colorScheme.actionKeyColor
                        }
                }()
                let foreColor: Color = {
                        guard isTouching.negative else { return Color.primary }
                        switch keyState {
                        case .bufferingSimplified, .bufferingTraditional:
                                return Color.primary
                        case .standbyABC, .standbySimplified, .standbyTraditional:
                                return isDefaultReturn ? Color.primary : Color.white
                        case .unavailableABC, .unavailableSimplified, .unavailableTraditional:
                                return Color.primary.opacity(0.5)
                        }
                }()
                ZStack {
                        Color.interactiveClear
                        RoundedRectangle(cornerRadius: PresetConstant.largeKeyCornerRadius, style: .continuous)
                                .fill(backColor)
                                .shadow(color: .shadowGray, radius: 0.5, y: 0.5)
                                .padding(3)
                        switch (context.returnKeyState.isBuffering, isDefaultReturn) {
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
                .frame(width: context.tenKeyWidthUnit, height: context.heightUnit * 2)
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
