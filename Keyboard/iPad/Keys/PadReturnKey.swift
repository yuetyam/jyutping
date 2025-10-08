import SwiftUI
import CommonExtensions

struct PadReturnKey: View {

        let widthUnitTimes: CGFloat

        @EnvironmentObject private var context: KeyboardViewController
        @Environment(\.colorScheme) private var colorScheme

        @GestureState private var isTouching: Bool = false

        var body: some View {
                let keyWidth: CGFloat = context.widthUnit * widthUnitTimes
                let keyHeight: CGFloat = context.heightUnit
                let isLandscape: Bool = context.keyboardInterface.isPadLandscape
                let verticalPadding: CGFloat = isLandscape ? 7 : 5
                let horizontalPadding: CGFloat = isLandscape ? 7 : 5
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
                                .padding(.vertical, verticalPadding)
                                .padding(.horizontal, horizontalPadding)
                        switch (keyState.isBuffering, isDefaultReturn) {
                        case (true, _):
                                Text(context.returnKeyText).foregroundStyle(foreColor)
                        case (false, true):
                                Image.return.foregroundStyle(foreColor)
                        default:
                                ZStack(alignment: .bottomTrailing) {
                                        Color.clear
                                        Text(context.returnKeyText)
                                                .font(.keyCaption)
                                                .foregroundStyle(foreColor)
                                }
                                .padding(.vertical, verticalPadding + 2)
                                .padding(.horizontal, horizontalPadding + 4)
                                switch context.returnKeyType {
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
                .contentShape(Rectangle())
                .gesture(DragGesture(minimumDistance: 0)
                        .updating($isTouching) { _, tapped, _ in
                                if tapped.negative {
                                        AudioFeedback.modified()
                                        tapped = true
                                }
                        }
                        .onEnded { _ in
                                context.operate(.return)
                        }
                )
        }
}
