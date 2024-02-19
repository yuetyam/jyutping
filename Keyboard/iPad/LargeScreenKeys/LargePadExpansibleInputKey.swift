import SwiftUI

struct LargePadExpansibleInputKey: View {

        /// Create a LargePadExpansibleInputKey
        /// - Parameters:
        ///   - keyLocale: Key location, left half (leading) or right half (trailing).
        ///   - keyModel: KeyElements
        init(keyLocale: HorizontalEdge, keyModel: KeyModel) {
                self.keyLocale = keyLocale
                self.keyModel = keyModel
        }

        private let keyLocale: HorizontalEdge
        private let keyModel: KeyModel

        @EnvironmentObject private var context: KeyboardViewController

        @Environment(\.colorScheme) private var colorScheme
        private var keyColor: Color {
                switch colorScheme {
                case .light:
                        return .light
                case .dark:
                        return .dark
                @unknown default:
                        return .light
                }
        }
        private var activeKeyColor: Color {
                switch colorScheme {
                case .light:
                        return .lightEmphatic
                case .dark:
                        return .darkEmphatic
                @unknown default:
                        return .lightEmphatic
                }
        }
        private var keyPreviewColor: Color {
                switch colorScheme {
                case .light:
                        return .light
                case .dark:
                        return .darkOpacity
                @unknown default:
                        return .light
                }
        }

        @GestureState private var isTouching: Bool = false
        private let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
        @State private var buffer: Int = 0
        @State private var isLongPressing: Bool = false
        @State private var selectedIndex: Int = 0

        var body: some View {
                let shouldShowLowercaseKeys: Bool = Options.showLowercaseKeys && context.keyboardCase.isLowercased
                let textCase: Text.Case = shouldShowLowercaseKeys ? .lowercase : .uppercase
                let widthUnit: CGFloat = context.widthUnit
                let heightUnit: CGFloat = context.heightUnit
                ZStack {
                        if isLongPressing {
                                let memberCount: Int = keyModel.members.count
                                let expansions: Int = keyModel.members.count - 1
                                PadKeyExpansionPath(keyLocale: keyLocale, expansions: expansions)
                                        .fill(keyPreviewColor)
                                        .shadow(color: .black.opacity(0.8), radius: 1)
                                        .overlay {
                                                HStack(spacing: 0) {
                                                        ForEach(0..<memberCount, id: \.self) { index in
                                                                let elementIndex: Int = keyLocale.isLeading ? index : ((memberCount - 1) - index)
                                                                let element: KeyElement = keyModel.members[elementIndex]
                                                                let isHighlighted: Bool = selectedIndex == elementIndex
                                                                ZStack {
                                                                        RoundedRectangle(cornerRadius: 5, style: .continuous)
                                                                                .fill(selectedIndex == elementIndex ? Color.accentColor : Color.clear)
                                                                        ZStack(alignment: .top) {
                                                                                Color.interactiveClear
                                                                                Text(verbatim: element.header ?? String.space)
                                                                                        .font(.keyFooter)
                                                                                        .padding(.top, 1)
                                                                                        .foregroundStyle(isHighlighted ? Color.white : Color.primary)
                                                                                        .opacity(0.8)
                                                                        }
                                                                        ZStack(alignment: .bottom) {
                                                                                Color.interactiveClear
                                                                                Text(verbatim: element.footer ?? String.space)
                                                                                        .font(.keyFooter)
                                                                                        .padding(.bottom, 1)
                                                                                        .foregroundStyle(isHighlighted ? Color.white : Color.primary)
                                                                                        .opacity(0.8)
                                                                        }
                                                                        Text(verbatim: element.text)
                                                                                .textCase(textCase)
                                                                                .font(.title2)
                                                                                .foregroundStyle(isHighlighted ? Color.white : Color.primary)
                                                                }
                                                                .frame(maxWidth: .infinity)
                                                        }
                                                }
                                                .frame(width: (widthUnit - 12) * CGFloat(memberCount), height: heightUnit * 0.7)
                                                .padding(.bottom, heightUnit * 1.8)
                                                .padding(.leading, keyLocale.isLeading ? ((widthUnit - 10) * CGFloat(expansions)) : 0)
                                                .padding(.trailing, keyLocale.isTrailing ? ((widthUnit - 10) * CGFloat(expansions)) : 0)
                                        }
                                        .padding(4)
                        } else {
                                Color.interactiveClear
                                RoundedRectangle(cornerRadius: 5, style: .continuous)
                                        .fill(isTouching ? activeKeyColor : keyColor)
                                        .shadow(color: .black.opacity(0.4), radius: 0.5, y: 1)
                                        .padding(4)
                                ZStack(alignment: .topTrailing) {
                                        Color.clear
                                        Text(verbatim: keyModel.primary.header ?? String.space)
                                                .textCase(textCase)
                                                .font(.keyFooter)
                                                .opacity(0.8)
                                                .padding(.trailing, 8)
                                                .padding(.top, 8)
                                }
                                ZStack(alignment: .bottomTrailing) {
                                        Color.clear
                                        Text(verbatim: keyModel.primary.footer ?? String.space)
                                                .textCase(textCase)
                                                .font(.keyFooter)
                                                .opacity(0.8)
                                                .padding(.trailing, 8)
                                                .padding(.bottom, 8)
                                }
                                Text(verbatim: keyModel.primary.text)
                                        .textCase(textCase)
                                        .font(.title2)
                        }
                }
                .frame(width: widthUnit, height: heightUnit)
                .contentShape(Rectangle())
                .gesture(DragGesture(minimumDistance: 0)
                        .updating($isTouching) { _, tapped, _ in
                                if !tapped {
                                        AudioFeedback.inputed()
                                        tapped = true
                                }
                        }
                        .onChanged { state in
                                guard isLongPressing else { return }
                                let memberCount: Int = keyModel.members.count
                                guard memberCount > 1 else { return }
                                let distance: CGFloat = keyLocale.isLeading ? state.translation.width : -(state.translation.width)
                                guard distance > 10 else { return }
                                let step: CGFloat = widthUnit - 14
                                for index in 0..<memberCount {
                                        let lowPoint: CGFloat = step * CGFloat(index)
                                        let heightPoint: CGFloat = step * CGFloat(index + 1)
                                        let maxLowPoint: CGFloat = step * CGFloat(memberCount)
                                        if distance > lowPoint && distance < heightPoint {
                                                selectedIndex = index
                                                break
                                        } else if distance > maxLowPoint {
                                                selectedIndex = memberCount - 1
                                                break
                                        }
                                }
                        }
                        .onEnded { _ in
                                buffer = 0
                                if isLongPressing {
                                        guard let selectedElement = keyModel.members.fetch(selectedIndex) else { return }
                                        let text: String = context.keyboardCase.isLowercased ? selectedElement.text : selectedElement.text.uppercased()
                                        AudioFeedback.inputed()
                                        context.operate(.process(text))
                                        selectedIndex = 0
                                        isLongPressing = false
                                } else {
                                        let text: String = context.keyboardCase.isLowercased ? keyModel.primary.text : keyModel.primary.text.uppercased()
                                        context.operate(.process(text))
                                }
                         }
                )
                .onReceive(timer) { _ in
                        guard isTouching else { return }
                        guard !isLongPressing else { return }
                        if buffer > 3 {
                                isLongPressing = true
                        } else {
                                buffer += 1
                        }
                }
        }
}
