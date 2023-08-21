import SwiftUI

struct PadExpansibleInputKey: View {

        /// Create an ExpansibleInputKey
        /// - Parameters:
        ///   - keyLocale: Key location, left half (leading) or right half (trailing).
        ///   - widthUnitTimes: Times of widthUnit
        ///   - keyModel: keyModel
        init(keyLocale: HorizontalEdge, widthUnitTimes: CGFloat = 1, keyModel: KeyModel) {
                self.keyLocale = keyLocale
                self.widthUnitTimes = widthUnitTimes
                self.keyModel = keyModel
        }

        private let keyLocale: HorizontalEdge
        private let widthUnitTimes: CGFloat
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
                let keyWidth: CGFloat = context.widthUnit * widthUnitTimes
                ZStack {
                        if isLongPressing {
                                let memberCount: Int = keyModel.members.count
                                let expansions: Int = keyModel.members.count - 1
                                PadKeyPreviewExpansionPath(keyLocale: keyLocale, expansions: expansions)
                                        .fill(keyPreviewColor)
                                        .shadow(color: .black.opacity(0.8), radius: 1)
                                        .overlay {
                                                HStack(spacing: 0) {
                                                        ForEach(0..<memberCount, id: \.self) { index in
                                                                let elementIndex: Int = keyLocale.isLeading ? index : ((memberCount - 1) - index)
                                                                let element: KeyElement = keyModel.members[elementIndex]
                                                                ZStack {
                                                                        RoundedRectangle(cornerRadius: 5, style: .continuous)
                                                                                .fill(selectedIndex == elementIndex ? Color.accentColor : Color.clear)
                                                                        ZStack(alignment: .top) {
                                                                                Color.interactiveClear
                                                                                Text(verbatim: element.header ?? String.space)
                                                                                        .font(.keyFooter)
                                                                                        .foregroundColor(.secondary)
                                                                                        .padding(.top, 1)
                                                                        }
                                                                        ZStack(alignment: .bottom) {
                                                                                Color.interactiveClear
                                                                                Text(verbatim: element.footer ?? String.space)
                                                                                        .font(.keyFooter)
                                                                                        .foregroundColor(.secondary)
                                                                                        .padding(.bottom, 1)
                                                                        }
                                                                        Text(verbatim: element.text)
                                                                                .font(.title2)
                                                                                .foregroundStyle(selectedIndex == elementIndex ? Color.white : Color.primary)
                                                                }
                                                                .frame(maxWidth: .infinity)
                                                        }
                                                }
                                                .frame(width: (keyWidth - 14) * CGFloat(memberCount), height: context.heightUnit * 0.7)
                                                .padding(.bottom, context.heightUnit * 1.7)
                                                .padding(.leading, keyLocale.isLeading ? ((keyWidth - 10) * CGFloat(expansions)) : 0)
                                                .padding(.trailing, keyLocale.isTrailing ? ((keyWidth - 10) * CGFloat(expansions)) : 0)
                                        }
                                        .padding(5)
                        } else {
                                RoundedRectangle(cornerRadius: 5, style: .continuous)
                                        .fill(isTouching ? activeKeyColor : keyColor)
                                        .shadow(color: .black.opacity(0.4), radius: 0.5, y: 1)
                                        .padding(5)
                                ZStack(alignment: .topTrailing) {
                                        Color.interactiveClear
                                        Text(verbatim: keyModel.primary.header ?? String.space)
                                                .font(.keyFooter)
                                                .foregroundColor(.secondary)
                                                .padding(.trailing, 5)
                                                .padding(.top, 8)
                                }
                                ZStack(alignment: .bottomTrailing) {
                                        Color.interactiveClear
                                        Text(verbatim: keyModel.primary.footer ?? String.space)
                                                .font(.keyFooter)
                                                .foregroundColor(.secondary)
                                                .padding(.trailing, 5)
                                                .padding(.bottom, 8)
                                }
                                Text(verbatim: keyModel.primary.text)
                                        .textCase(context.keyboardCase.isLowercased ? .lowercase : .uppercase)
                                        .font(.title3)
                        }
                }
                .frame(width: keyWidth, height: context.heightUnit)
                .contentShape(Rectangle())
                .gesture(DragGesture(minimumDistance: 0)
                        .updating($isTouching) { _, tapped, _ in
                                if !tapped {
                                        AudioFeedback.inputed()
                                        context.triggerHapticFeedback()
                                        tapped = true
                                }
                        }
                        .onChanged { state in
                                guard isLongPressing else { return }
                                let memberCount: Int = keyModel.members.count
                                guard memberCount > 1 else { return }
                                let distance: CGFloat = keyLocale.isLeading ? state.translation.width : -(state.translation.width)
                                guard distance > 0 else { return }
                                let step: CGFloat = keyWidth - 14
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
                                        AudioFeedback.inputed()
                                        context.triggerSelectionHapticFeedback()
                                        let text: String = context.keyboardCase.isLowercased ? selectedElement.text : selectedElement.text.uppercased()
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
