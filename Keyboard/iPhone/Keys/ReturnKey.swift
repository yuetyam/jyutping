import SwiftUI
import CommonExtensions

struct ReturnKey: View {

        @EnvironmentObject private var context: KeyboardViewController
        @Environment(\.colorScheme) private var colorScheme

        private var keyColor: Color {
                return colorScheme.isDark ? .darkAction : .lightAction
        }
        private var keyActiveColor: Color {
                return colorScheme.isDark ? .activeDarkAction : .activeLightAction
        }

        @GestureState private var isTouching: Bool = false

        var body: some View {
                let keyWidth: CGFloat = context.widthUnit * 2
                let keyHeight: CGFloat = context.heightUnit
                let isPhoneLandscape: Bool = context.keyboardInterface.isPhoneLandscape
                let verticalPadding: CGFloat = isPhoneLandscape ? 3 : 6
                let horizontalPadding: CGFloat = isPhoneLandscape ? 6 : 3
                let isDefaultReturn: Bool = context.returnKeyType.isDefaultReturn
                let keyState: ReturnKeyState = context.returnKeyState
                let shouldDisplayKeyImage: Bool = {
                        guard isDefaultReturn else { return false }
                        switch keyState {
                        case .bufferingSimplified, .bufferingTraditional:
                                return false
                        default:
                                return true
                        }
                }()
                let backColor: Color = {
                        guard isTouching.negative else { return keyActiveColor }
                        switch keyState {
                        case .bufferingSimplified, .bufferingTraditional:
                                return keyColor
                        case .standbyABC, .standbySimplified, .standbyTraditional:
                                return isDefaultReturn ? keyColor : Color.accentColor
                        case .unavailableABC, .unavailableSimplified, .unavailableTraditional:
                                return keyColor
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
                        RoundedRectangle(cornerRadius: PresetConstant.keyCornerRadius, style: .continuous)
                                .fill(backColor)
                                .shadow(color: .shadowGray, radius: 0.5, y: 0.5)
                                .padding(.vertical, verticalPadding)
                                .padding(.horizontal, horizontalPadding)
                        if shouldDisplayKeyImage {
                                Image.return.foregroundStyle(foreColor)
                        } else {
                                Text(context.returnKeyText).foregroundStyle(foreColor)
                        }
                }
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
