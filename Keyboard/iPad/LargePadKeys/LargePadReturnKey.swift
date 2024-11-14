import SwiftUI
import CommonExtensions

struct LargePadReturnKey: View {

        let widthUnitTimes: CGFloat

        @EnvironmentObject private var context: KeyboardViewController

        @Environment(\.colorScheme) private var colorScheme
        private var keyColor: Color {
                switch colorScheme {
                case .light:
                        return .lightEmphatic
                case .dark:
                        return .darkEmphatic
                @unknown default:
                        return .lightEmphatic
                }
        }
        private var activeKeyColor: Color {
                switch colorScheme {
                case .light:
                        return .light
                case .dark:
                        return .dark
                @unknown default:
                        return .light
                }
        }

        @GestureState private var isTouching: Bool = false

        var body: some View {
                let keyWidth: CGFloat = context.widthUnit * widthUnitTimes
                let keyHeight: CGFloat = context.heightUnit
                let isLandscape: Bool = context.keyboardInterface.isPadLandscape
                let verticalPadding: CGFloat = isLandscape ? 5 : 4
                let horizontalPadding: CGFloat = isLandscape ? 5 : 4
                let isDefaultReturn: Bool = context.returnKeyType.isDefaultReturn
                let isSearchReturn: Bool = context.returnKeyType == .search
                let keyState: ReturnKeyState = context.returnKeyState
                let shouldDisplayKeyImage: Bool = {
                        switch keyState {
                        case .bufferingSimplified, .bufferingTraditional:
                                return false
                        default:
                                return true
                        }
                }()
                let shouldDisplayKeyText: Bool = {
                        guard isDefaultReturn else { return true }
                        switch keyState {
                        case .bufferingSimplified, .bufferingTraditional:
                                return true
                        default:
                                return false
                        }
                }()
                let backColor: Color = {
                        guard isTouching.negative else { return activeKeyColor }
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
                        RoundedRectangle(cornerRadius: 5, style: .continuous)
                                .fill(backColor)
                                .shadow(color: .shadowGray, radius: 0.5, y: 0.5)
                                .padding(.vertical, verticalPadding)
                                .padding(.horizontal, horizontalPadding)
                        switch (shouldDisplayKeyImage, shouldDisplayKeyText) {
                        case (true, true):
                                ZStack(alignment: .topTrailing) {
                                        Color.clear
                                        if isSearchReturn {
                                                Image.search
                                        } else {
                                                Image.return
                                        }
                                }
                                .foregroundStyle(foreColor)
                                .padding(.vertical, verticalPadding + 7)
                                .padding(.horizontal, horizontalPadding + 7)
                                ZStack(alignment: .bottomTrailing) {
                                        Color.clear
                                        Text(context.returnKeyText)
                                }
                                .foregroundStyle(foreColor)
                                .padding(.vertical, verticalPadding + 7)
                                .padding(.horizontal, horizontalPadding + 7)
                        case (true, false):
                                ZStack(alignment: .bottomTrailing) {
                                        Color.clear
                                        if isSearchReturn {
                                                Image.search
                                        } else {
                                                Image.return
                                        }
                                }
                                .foregroundStyle(foreColor)
                                .padding(.vertical, verticalPadding + 7)
                                .padding(.horizontal, horizontalPadding + 7)
                        case (false, true), (false, false):
                                ZStack(alignment: .bottomTrailing) {
                                        Color.clear
                                        Text(context.returnKeyText)
                                }
                                .foregroundStyle(foreColor)
                                .padding(.vertical, verticalPadding + 7)
                                .padding(.horizontal, horizontalPadding + 7)
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
