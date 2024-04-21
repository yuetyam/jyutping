import SwiftUI

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
                        guard !isTouching else { return activeKeyColor }
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
                        guard !isTouching else { return Color.primary }
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
                                .shadow(color: .black.opacity(0.4), radius: 0.5, y: 1)
                                .padding(4)
                        ZStack(alignment: .bottomTrailing) {
                                Color.clear
                                Image(systemName: isSearchReturn ? "magnifyingglass" : "return")
                                        .foregroundStyle(foreColor)
                                        .padding(12)
                        }
                        .opacity(shouldDisplayKeyImage ? 1 : 0)
                        ZStack(alignment: .topTrailing) {
                                Color.clear
                                Text(verbatim: context.returnKeyText)
                                        .foregroundStyle(foreColor)
                                        .padding(12)
                        }
                        .opacity(shouldDisplayKeyText ? 1 : 0)
                }
                .frame(width: context.widthUnit * widthUnitTimes, height: context.heightUnit)
                .contentShape(Rectangle())
                .gesture(DragGesture(minimumDistance: 0)
                        .updating($isTouching) { _, tapped, _ in
                                if !tapped {
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
