import SwiftUI
import CommonExtensions

struct NineKeyReturnKey: View {

        @EnvironmentObject private var context: KeyboardViewController
        @Environment(\.colorScheme) private var colorScheme

        @GestureState private var isTouching: Bool = false

        var body: some View {
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
                                        .clipShape(RoundedRectangle(cornerRadius: PresetConstant.largeKeyCornerRadius, style: .continuous))
                                        .glassEffect(isTouching ? .regular : .clear, in: RoundedRectangle(cornerRadius: PresetConstant.largeKeyCornerRadius, style: .continuous))
                                        .shadow(color: isTouching ? colorScheme.glassShadow : Color.clear, radius: 0.5)
                                        .padding(3)
                        } else {
                                RoundedRectangle(cornerRadius: PresetConstant.largeKeyCornerRadius, style: .continuous)
                                        .fill(backColor)
                                        .shadow(color: .shadowGray, radius: 0.5, y: 0.5)
                                        .padding(3)
                        }
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
                .frame(width: context.nineKeyWidthUnit * 0.94, height: context.heightUnit * 2)
                .contentShape(.rect)
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
