import SwiftUI
import CommonExtensions

@available(iOS 26.0, *)
@available(iOSApplicationExtension 26.0, *)
struct GlassTailoredEnterKey: View {

        @EnvironmentObject private var context: KeyboardViewController
        @Environment(\.colorScheme) private var colorScheme
        @State private var isTouching: Bool = false

        var body: some View {
                let keyWidth: CGFloat = context.nineKeyWidthUnit * PresetConstant.tailoredActionKeyWidthCoefficient
                let keyHeight: CGFloat = context.heightUnit * 2
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
                                        .clipShape(.rect(cornerRadius: PresetConstant.largeKeyCornerRadius))
                                        .glassEffect(isTouching ? .regular : .clear, in: .rect(cornerRadius: PresetConstant.largeKeyCornerRadius))
                                        .shadow(color: isTouching ? colorScheme.glassShadow : Color.clear, radius: 0.5)
                                        .padding(isTouching ? 1 : 3)
                                switch (keyState.isBuffering, isDefaultReturn) {
                                case (true, _):
                                        Text(context.enterKeyText)
                                                .font(.staticBody)
                                                .foregroundStyle(foreColor)
                                case (false, true):
                                        Image.return
                                                .font(.symbol)
                                                .foregroundStyle(foreColor)
                                default:
                                        VStack(spacing: 5) {
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
                                                Text(context.enterKeyText).font(.footnote)
                                        }
                                        .font(.symbol)
                                        .foregroundStyle(foreColor)
                                }
                        }
                        .frame(width: keyWidth, height: keyHeight)
                }
                .buttonStyle(PressButtonStyle($isTouching) {
                        context.performAudioFeedback(.modify)
                        context.triggerHapticFeedback()
                        context.operate(.return)
                })
        }
}
