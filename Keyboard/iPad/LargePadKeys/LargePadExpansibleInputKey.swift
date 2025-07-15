import SwiftUI
import CommonExtensions
import CoreIME

struct LargePadExpansibleInputKey: View {

        /// Create a LargePadExpansibleInputKey
        /// - Parameters:
        ///   - keyLocale: Key location, left half (leading) or right half (trailing).
        ///   - event: InputEvent
        ///   - keyModel: KeyElements
        init(keyLocale: HorizontalEdge ,event: InputEvent? = nil, keyModel: KeyModel) {
                self.keyLocale = keyLocale
                self.event = event
                self.keyModel = keyModel
        }

        private let keyLocale: HorizontalEdge
        private let event: InputEvent?
        private let keyModel: KeyModel

        @EnvironmentObject private var context: KeyboardViewController
        @Environment(\.colorScheme) private var colorScheme

        @GestureState private var isTouching: Bool = false
        private let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
        @State private var buffer: Int = 0
        @State private var isLongPressing: Bool = false
        @State private var selectedIndex: Int = 0

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
                let shouldShowLowercaseKeys: Bool = Options.showLowercaseKeys && context.keyboardCase.isLowercased
                let textCase: Text.Case = shouldShowLowercaseKeys ? .lowercase : .uppercase
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
                                                                ZStack {
                                                                        RoundedRectangle(cornerRadius: PresetConstant.innerLargeKeyCornerRadius, style: .continuous)
                                                                                .fill(selectedIndex == elementIndex ? Color.accentColor : Color.clear)
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
                                                                                .textCase(textCase)
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
                                RoundedRectangle(cornerRadius: PresetConstant.largeKeyCornerRadius, style: .continuous)
                                        .fill(isTouching ? colorScheme.activeInputKeyColor : colorScheme.inputKeyColor)
                                        .shadow(color: .shadowGray, radius: 0.5, y: 0.5)
                                        .padding(.vertical, verticalPadding)
                                        .padding(.horizontal, horizontalPadding)
                                ZStack(alignment: .topTrailing) {
                                        Color.clear
                                        Text(verbatim: keyModel.primary.header ?? String.space)
                                                .textCase(textCase)
                                                .font(.keyFootnote)
                                                .shallow()
                                }
                                .padding(.vertical, verticalPadding + 2)
                                .padding(.horizontal, horizontalPadding + 4)
                                ZStack(alignment: .bottomTrailing) {
                                        Color.clear
                                        Text(verbatim: keyModel.primary.footer ?? String.space)
                                                .textCase(textCase)
                                                .font(.keyFootnote)
                                                .shallow()
                                }
                                .padding(.vertical, verticalPadding + 2)
                                .padding(.horizontal, horizontalPadding + 4)
                                Text(verbatim: keyModel.primary.text)
                                        .textCase(textCase)
                                        .font(.title2)
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
                                guard isLongPressing else { return }
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
                        }
                        .onEnded { _ in
                                buffer = 0
                                if isLongPressing {
                                        defer {
                                                selectedIndex = 0
                                                isLongPressing = false
                                        }
                                        guard let selectedElement = keyModel.members.fetch(selectedIndex) else { return }
                                        let text: String = context.keyboardCase.isLowercased ? selectedElement.text : selectedElement.text.uppercased()
                                        AudioFeedback.inputed()
                                        context.operate(.process(text))
                                } else if let event {
                                        context.process(event, isCapitalized: context.keyboardCase.isCapitalized)
                                } else {
                                        let text: String = context.keyboardCase.isLowercased ? keyModel.primary.text : keyModel.primary.text.uppercased()
                                        context.operate(.process(text))
                                }
                         }
                )
                .onReceive(timer) { _ in
                        guard isTouching else { return }
                        guard isLongPressing.negative else { return }
                        if buffer > 3 {
                                isLongPressing = true
                        } else {
                                buffer += 1
                        }
                }
        }
}
