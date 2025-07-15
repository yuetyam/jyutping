import SwiftUI
import CommonExtensions
import CoreIME

struct LargePadUpperLowerInputKey: View {

        /// Create a LargePadUpperLowerInputKey
        /// - Parameters:
        ///   - keyLocale: Key location, left half screen (leading) or right half screen (trailing)
        ///   - upper: Key upper text
        ///   - lower: Key lower text
        ///   - event: InputEvent, corresponding to the lower text
        ///   - keyModel: KeyElements
        init(keyLocale: HorizontalEdge, upper: String, lower: String, event: InputEvent? = nil, keyModel: KeyModel) {
                self.keyLocale = keyLocale
                self.upper = upper
                self.lower = lower
                self.event = event
                self.keyModel = keyModel
        }

        private let keyLocale: HorizontalEdge
        private let upper: String
        private let lower: String
        private let event: InputEvent?
        private let keyModel: KeyModel

        @EnvironmentObject private var context: KeyboardViewController
        @Environment(\.colorScheme) private var colorScheme

        @GestureState private var isTouching: Bool = false
        private let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
        @State private var buffer: Int = 0
        @State private var isLongPressing: Bool = false
        @State private var selectedIndex: Int = 0
        @State private var isPullingDown: Bool = false

        var body: some View {
                let keyWidth: CGFloat = context.widthUnit
                let keyHeight: CGFloat = context.heightUnit
                let isLandscape: Bool = context.keyboardInterface.isPadLandscape
                let verticalPadding: CGFloat = isLandscape ? 5 : 4
                let horizontalPadding: CGFloat = isLandscape ? 5 : 4
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
                                        .fill(colorScheme.previewBubbleColor)
                                        .shadow(color: .shadowGray, radius: 1)
                                        .overlay {
                                                HStack(spacing: 0) {
                                                        ForEach(keyModel.members.indices, id: \.self) { index in
                                                                let elementIndex: Int = keyLocale.isLeading ? index : ((memberCount - 1) - index)
                                                                let element: KeyElement = keyModel.members[elementIndex]
                                                                let isHighlighted: Bool = (selectedIndex == elementIndex)
                                                                ZStack {
                                                                        RoundedRectangle(cornerRadius: PresetConstant.innerLargeKeyCornerRadius, style: .continuous)
                                                                                .fill(isHighlighted ? Color.accentColor : Color.clear)
                                                                        ZStack(alignment: .top) {
                                                                                Color.clear
                                                                                Text(verbatim: element.header ?? String.space)
                                                                                        .font(.keyFootnote)
                                                                                        .shallow()
                                                                        }
                                                                        .padding(2)
                                                                        ZStack(alignment: .bottom) {
                                                                                Color.clear
                                                                                Text(verbatim: element.footer ?? String.space)
                                                                                        .font(.keyFootnote)
                                                                                        .shallow()
                                                                        }
                                                                        .padding(2)
                                                                        Text(verbatim: element.text)
                                                                                .font(.title2)
                                                                }
                                                                .foregroundStyle(isHighlighted ? Color.white : Color.primary)
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
                                RoundedRectangle(cornerRadius: PresetConstant.largeKeyCornerRadius, style: .continuous)
                                        .fill(isTouching ? colorScheme.activeInputKeyColor : colorScheme.inputKeyColor)
                                        .shadow(color: .shadowGray, radius: 0.5, y: 0.5)
                                        .padding(.vertical, verticalPadding)
                                        .padding(.horizontal, horizontalPadding)
                                if isPullingDown {
                                        Text(verbatim: upper).font(.title2)
                                } else {
                                        ZStack(alignment: .top) {
                                                Color.clear
                                                Text(verbatim: upper)
                                        }
                                        .padding(.vertical, verticalPadding + 6)
                                        .padding(.horizontal, horizontalPadding + 6)
                                        ZStack(alignment: .bottom) {
                                                Color.clear
                                                Text(verbatim: lower)
                                        }
                                        .padding(.vertical, verticalPadding + 6)
                                        .padding(.horizontal, horizontalPadding + 6)
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
                                        if distance < (baseWidth / 2.0) {
                                                if selectedIndex != 0 {
                                                        selectedIndex = 0
                                                }
                                        } else {
                                                let maxPoint: CGFloat = baseWidth * CGFloat(memberCount)
                                                let endIndex: Int = memberCount - 1
                                                let index = memberCount - Int((maxPoint - distance) / baseWidth)
                                                selectedIndex = min(endIndex, max(0, index))
                                        }
                                } else if isPullingDown.negative {
                                        let distance: CGFloat = state.translation.height
                                        guard distance > 30 else { return }
                                        isPullingDown = true
                                }
                        }
                        .onEnded { _ in
                                buffer = 0
                                defer {
                                        selectedIndex = 0
                                        isLongPressing = false
                                        isPullingDown = false
                                }
                                if isLongPressing {
                                        guard let selectedElement = keyModel.members.fetch(selectedIndex) else { return }
                                        let text: String = selectedElement.text
                                        AudioFeedback.inputed()
                                        context.operate(.process(text))
                                } else if isPullingDown {
                                        let text: String = upper
                                        context.operate(.process(text))
                                } else if let event {
                                        context.handle(event)
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
