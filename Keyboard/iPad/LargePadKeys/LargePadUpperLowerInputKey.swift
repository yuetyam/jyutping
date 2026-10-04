import SwiftUI
import CommonExtensions
import CoreIME

/// A large-iPad punctuation key supporting a downward pull and long-press alternative selection.
///
/// Holding the key expands its alternatives; sliding selects an element and releasing commits it.
/// Drag tracking keeps the selector active when the finger moves outside the original button.
struct LargePadUpperLowerInputKey: View {

        /// Creates a LargePadUpperLowerInputKey with primary content and selectable alternatives.
        ///
        /// - Parameters:
        ///   - side: Key location in the leading or trailing half of the keyboard. Alternatives expand toward the opposite side.
        ///   - upper: Text shown above the primary content and committed by a downward pull.
        ///   - lower: Text committed on an ordinary release when no virtual event is supplied.
        ///   - virtual: Optional event handled on an ordinary release. When nil, the lower text is processed instead.
        ///   - unit: Primary content and alternatives for long-press selection.
        init(side: HorizontalEdge, upper: String, lower: String, virtual: VirtualInputKey? = nil, unit: KeyUnit) {
                self.side = side
                self.upper = upper
                self.lower = lower
                self.virtual = virtual
                self.unit = unit
        }

        /// Determines the direction of expansion and slide selection.
        private let side: HorizontalEdge

        /// Text selected by a downward pull.
        private let upper: String

        /// Text committed on an ordinary release when no pull or virtual event is selected.
        private let lower: String

        /// Event handled on release when no alternative or pulled text is selected.
        private let virtual: VirtualInputKey?

        /// Primary key content and alternatives shown in the expanded selector.
        private let unit: KeyUnit

        /// Keyboard properties and handlers.
        @EnvironmentObject private var context: KeyboardViewController

        /// Retrieves the current system color scheme (light or dark mode) from the environment.
        @Environment(\.colorScheme) private var colorScheme

        /// Button press state reported by PressButtonStyle; may end when sliding outside the key.
        @State private var isTouching: Bool = false

        /// Number of elapsed 100 ms checkpoints used for pull and long-press thresholds.
        @State private var buffer: Int = 0

        /// Indicates that the expanded alternative selector has been activated.
        @State private var isLongPressing: Bool = false

        /// Selected index in unit.members, independent of the visual expansion direction.
        @State private var selectedIndex: Int = 0

        /// Indicates that a downward pull has selected the upper text.
        @State private var isPullingDown: Bool = false

        var body: some View {
                let keyWidth: CGFloat = context.widthUnit
                let keyHeight: CGFloat = context.heightUnit
                let insets = context.keyboardInterface.keyShapeInsets
                let baseWidth: CGFloat = keyWidth - insets.horizontalTotal
                let baseHeight: CGFloat = keyHeight - insets.verticalTotal
                let extraHeight: CGFloat = 4
                let previewBottomOffset: CGFloat = (baseHeight + extraHeight) * 2
                Button(action: {}) {
                        ZStack {
                                Color.interactiveClear
                                if isLongPressing {
                                        let memberCount: Int = unit.members.count
                                        let expansionCount: Int = memberCount - 1
                                        let offsetX: CGFloat = baseWidth * CGFloat(expansionCount)
                                        let leadingOffset: CGFloat = side.isLeading ? offsetX : 0
                                        let trailingOffset: CGFloat = side.isTrailing ? offsetX : 0
                                        PadExpansiveBubbleShape(side: side, expansionCount: expansionCount)
                                                .fill(colorScheme.previewBubbleColor)
                                                .shadow(color: .shadowGray, radius: 1)
                                                .overlay {
                                                        HStack(spacing: 0) {
                                                                ForEach(unit.members.indices, id: \.self) { index in
                                                                        let elementIndex: Int = side.isLeading ? index : ((memberCount - 1) - index)
                                                                        let element: KeyElement = unit.members[elementIndex]
                                                                        let isSelected: Bool = selectedIndex == elementIndex
                                                                        ZStack {
                                                                                RoundedRectangle(cornerRadius: PresetConstant.innerLargeKeyCornerRadius)
                                                                                        .fill(isSelected ? Color.accentColor : Color.clear)
                                                                                ForEach(element.extras.indices, id: \.self) { extraIndex in
                                                                                        let extra = element.extras[extraIndex]
                                                                                        ZStack(alignment: extra.alignment) {
                                                                                                Color.clear
                                                                                                Text(verbatim: extra.text)
                                                                                                        .font(.labelCaption)
                                                                                                        .shallow()
                                                                                        }
                                                                                        .padding(2)
                                                                                }
                                                                                Text(verbatim: element.text)
                                                                                        .font(.title2)
                                                                        }
                                                                        .foregroundStyle(isSelected ? Color.white : Color.primary)
                                                                        .padding(4)
                                                                        .frame(maxWidth: .infinity)
                                                                }
                                                        }
                                                        .frame(width: baseWidth * CGFloat(memberCount), height: baseHeight)
                                                        .padding(.bottom, previewBottomOffset)
                                                        .padding(.leading, leadingOffset)
                                                        .padding(.trailing, trailingOffset)
                                                }
                                                .padding(insets)
                                } else {
                                        RoundedRectangle(cornerRadius: PresetConstant.largeKeyCornerRadius)
                                                .fill(isTouching ? colorScheme.activeInputKeyColor : colorScheme.inputKeyColor)
                                                .shadow(color: .shadowGray, radius: 0.5, y: 0.5)
                                                .padding(insets)
                                        if isPullingDown {
                                                Text(verbatim: upper).font(.title2)
                                        } else {
                                                ZStack(alignment: .top) {
                                                        Color.clear
                                                        Text(verbatim: upper)
                                                }
                                                .padding(insets.plused(horizontal: 6, vertical: 6))
                                                ZStack(alignment: .bottom) {
                                                        Color.clear
                                                        Text(verbatim: lower)
                                                }
                                                .padding(insets.plused(horizontal: 6, vertical: 6))
                                        }
                                }
                        }
                        .frame(width: keyWidth, height: keyHeight)
                }
                .buttonStyle(PressButtonStyle($isTouching) {
                        AudioFeedback.inputed()
                })
                .simultaneousGesture(DragGesture(minimumDistance: 0)
                        .onChanged { state in
                                if isLongPressing {
                                        let memberCount: Int = unit.members.count
                                        guard memberCount > 1 else { return }
                                        let distance: CGFloat = side.isLeading ? state.translation.width : -(state.translation.width)
                                        if distance < (baseWidth / 2.0) {
                                                if selectedIndex != 0 {
                                                        selectedIndex = 0
                                                }
                                        } else {
                                                let maxPoint: CGFloat = baseWidth * CGFloat(memberCount)
                                                let endIndex: Int = memberCount - 1
                                                let index = memberCount - Int((maxPoint - distance) / baseWidth)
                                                let newSelectedIndex = min(endIndex, max(0, index))
                                                if selectedIndex != newSelectedIndex {
                                                        selectedIndex = newSelectedIndex
                                                }
                                        }
                                } else if isPullingDown.negative {
                                        let distance: CGFloat = state.translation.height
                                        let isSatisfied: Bool = distance > 36 || (buffer > 1 && distance > 24)
                                        guard isSatisfied else { return }
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
                                        guard let selectedElement = unit.members.fetch(selectedIndex) else { return }
                                        let text: String = selectedElement.text
                                        AudioFeedback.inputed()
                                        context.operate(.process(text))
                                } else if isPullingDown {
                                        let text: String = upper
                                        context.operate(.process(text))
                                } else if let virtual {
                                        context.handle(virtual)
                                } else {
                                        let text: String = lower
                                        context.operate(.process(text))
                                }
                        }
                )
                .task(id: isTouching) {
                        guard isTouching else { return }
                        while isLongPressing.negative {
                                try? await Task.sleep(for: .milliseconds(100))
                                guard Task.isCancelled.negative else { break }
                                guard isPullingDown.negative else { break }
                                if buffer >= 3 {
                                        isLongPressing = true
                                } else {
                                        buffer += 1
                                }
                        }
                }
        }
}
