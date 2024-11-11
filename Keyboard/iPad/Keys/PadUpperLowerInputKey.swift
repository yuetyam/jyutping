import SwiftUI
import CommonExtensions

struct PadUpperLowerInputKey: View {

        /// Create a PadUpperLowerInputKey
        /// - Parameters:
        ///   - keyLocale: Key location, left half (leading) or right half (trailing).
        ///   - upper: Key upper text
        ///   - lower: Key lower text
        ///   - keyModel: KeyElements
        init(keyLocale: HorizontalEdge, upper: String, lower: String, keyModel: KeyModel) {
                self.keyLocale = keyLocale
                self.upper = upper
                self.lower = lower
                self.keyModel = keyModel
        }

        private let keyLocale: HorizontalEdge
        private let upper: String
        private let lower: String
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
        @State private var isPullingDown: Bool = false

        var body: some View {
                let keyWidth: CGFloat = context.widthUnit
                let keyHeight = context.heightUnit
                let verticalPadding: CGFloat = 5
                let horizontalPadding: CGFloat = 5
                let baseWidth: CGFloat = keyWidth - (horizontalPadding * 2)
                let baseHeight: CGFloat = keyHeight - (verticalPadding * 2)
                let extraHeight: CGFloat = 4
                let previewBottomOffset: CGFloat = (baseHeight + extraHeight) * 2
                ZStack {
                        Color.interactiveClear
                        if isLongPressing {
                                let memberCount: Int = keyModel.members.count
                                let expansionCount: Int = memberCount - 1
                                let offsetX: CGFloat = baseWidth * CGFloat(expansionCount)
                                let leadingOffset: CGFloat = keyLocale.isLeading ? offsetX : 0
                                let trailingOffset: CGFloat = keyLocale.isTrailing ? offsetX : 0
                                PadExpansiveBubbleShape(keyLocale: keyLocale, expansionCount: expansionCount)
                                        .fill(keyPreviewColor)
                                        .shadow(color: .shadowGray, radius: 1)
                                        .overlay {
                                                HStack(spacing: 0) {
                                                        ForEach(keyModel.members.indices, id: \.self) { index in
                                                                let elementIndex: Int = keyLocale.isLeading ? index : ((memberCount - 1) - index)
                                                                let element: KeyElement = keyModel.members[elementIndex]
                                                                ZStack {
                                                                        RoundedRectangle(cornerRadius: 5, style: .continuous)
                                                                                .fill(selectedIndex == elementIndex ? Color.accentColor : Color.clear)
                                                                        ZStack(alignment: .top) {
                                                                                Color.clear
                                                                                Text(verbatim: element.header ?? String.space)
                                                                                        .font(.keyFooter)
                                                                                        .opacity(0.8)
                                                                        }
                                                                        .padding(2)
                                                                        ZStack(alignment: .bottom) {
                                                                                Color.clear
                                                                                Text(verbatim: element.footer ?? String.space)
                                                                                        .font(.keyFooter)
                                                                                        .opacity(0.8)
                                                                        }
                                                                        .padding(2)
                                                                        Text(verbatim: element.text)
                                                                                .font(.title2)

                                                                }
                                                                .foregroundStyle(selectedIndex == elementIndex ? Color.white : Color.primary)
                                                                .padding(4)
                                                                .frame(maxWidth: .infinity)
                                                        }
                                                }
                                                .frame(width: baseWidth * CGFloat(memberCount), height: baseHeight)
                                                .padding(.bottom, previewBottomOffset)
                                                .padding(.leading, leadingOffset)
                                                .padding(.trailing, trailingOffset)
                                        }
                                        .padding(.vertical, verticalPadding)
                                        .padding(.horizontal, horizontalPadding)
                        } else {
                                RoundedRectangle(cornerRadius: 5, style: .continuous)
                                        .fill(isTouching ? activeKeyColor : keyColor)
                                        .shadow(color: .shadowGray, radius: 0.5, y: 0.5)
                                        .padding(.vertical, verticalPadding)
                                        .padding(.horizontal, horizontalPadding)
                                if isPullingDown {
                                        Text(verbatim: upper)
                                                .font(.title2)
                                } else {
                                        ZStack(alignment: .top) {
                                                Color.clear
                                                Text(verbatim: upper)
                                        }
                                        .padding(.vertical, verticalPadding + 7)
                                        .padding(.horizontal, horizontalPadding + 7)
                                        ZStack(alignment: .bottom) {
                                                Color.clear
                                                Text(verbatim: lower)
                                        }
                                        .padding(.vertical, verticalPadding + 7)
                                        .padding(.horizontal, horizontalPadding + 7)
                                }
                        }
                }
                .frame(width: keyWidth, height: keyHeight)
                .contentShape(Rectangle())
                .gesture(DragGesture(minimumDistance: 0)
                        .updating($isTouching) { _, tapped, _ in
                                if tapped.negative {
                                        AudioFeedback.inputed()
                                        tapped = true
                                }
                        }
                        .onChanged { state in
                                if isLongPressing {
                                        let memberCount: Int = keyModel.members.count
                                        guard memberCount > 1 else { return }
                                        let distance: CGFloat = keyLocale.isLeading ? state.translation.width : -(state.translation.width)
                                        guard distance > 10 else { return }
                                        let step: CGFloat = baseWidth
                                        for index in keyModel.members.indices {
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
                                } else {
                                        guard isPullingDown.negative else { return }
                                        let distance: CGFloat = state.translation.height
                                        guard distance > 20 else { return }
                                        isPullingDown = true
                                }
                        }
                        .onEnded { _ in
                                buffer = 0
                                if isLongPressing {
                                        defer {
                                                selectedIndex = 0
                                                isLongPressing = false
                                        }
                                        guard let selectedElement = keyModel.members.fetch(selectedIndex) else { return }
                                        let text: String = selectedElement.text
                                        AudioFeedback.inputed()
                                        context.operate(.process(text))
                                } else if isPullingDown {
                                        let text: String = upper
                                        context.operate(.process(text))
                                        isPullingDown = false
                                } else {
                                        let text: String = lower
                                        context.operate(.process(text))
                                }
                         }
                )
                .onReceive(timer) { _ in
                        guard isTouching else { return }
                        guard isLongPressing.negative && isPullingDown.negative else { return }
                        if buffer > 3 {
                                isLongPressing = true
                        } else {
                                buffer += 1
                        }
                }
        }
}
