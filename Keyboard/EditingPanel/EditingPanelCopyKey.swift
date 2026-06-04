import SwiftUI
import CommonExtensions

@available(iOS 26.0, *)
@available(iOSApplicationExtension 26.0, *)
struct EditingPanelGlassCopyKey: View {

        @EnvironmentObject private var context: KeyboardViewController
        @Environment(\.colorScheme) private var colorScheme

        @GestureState private var isTouching: Bool = false

        var body: some View {
                let inset = context.keyboardInterface.editingKeyInset
                ZStack {
                        Color.interactiveClear
                        Color.clear
                                .glassEffect(isTouching ? .regular : .clear, in: RoundedRectangle(cornerRadius: PresetConstant.ultraKeyCornerRadius, style: .continuous))
                                .shadow(color: isTouching ? colorScheme.glassShadow : Color.clear, radius: 0.5)
                                .padding(isTouching ? (inset - 2) : inset)
                        VStack(spacing: 4) {
                                Image(systemName: "doc.on.doc")
                                Text("EditingPanel.Copy")
                                        .font(.labelCaption)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.5)
                                        .padding(.horizontal, 4)
                        }
                }
                .contentShape(.rect)
                .gesture(DragGesture(minimumDistance: 0)
                        .updating($isTouching) { _, isTouchBegan, _ in
                                if isTouchBegan.negative {
                                        isTouchBegan = true
                                        AudioFeedback.modified()
                                        context.triggerHapticFeedback()
                                }
                        }
                        .onEnded { _ in
                                context.operate(.copyAllText)
                        }
                )
        }
}

struct EditingPanelCopyKey: View {

        @EnvironmentObject private var context: KeyboardViewController
        @Environment(\.colorScheme) private var colorScheme

        @GestureState private var isTouching: Bool = false

        var body: some View {
                let inset = context.keyboardInterface.editingKeyInset
                ZStack {
                        Color.interactiveClear
                        RoundedRectangle(cornerRadius: PresetConstant.ultraKeyCornerRadius, style: .continuous)
                                .fill(isTouching ? colorScheme.activeActionKeyColor : colorScheme.actionKeyColor)
                                .shadow(color: .shadowGray, radius: 0.5, y: 0.5)
                                .padding(isTouching ? (inset - 2) : inset)
                        VStack(spacing: 4) {
                                Image(systemName: "doc.on.doc")
                                Text("EditingPanel.Copy")
                                        .font(.labelCaption)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.5)
                                        .padding(.horizontal, 4)
                        }
                }
                .contentShape(.rect)
                .gesture(DragGesture(minimumDistance: 0)
                        .updating($isTouching) { _, isTouchBegan, _ in
                                if isTouchBegan.negative {
                                        isTouchBegan = true
                                        AudioFeedback.modified()
                                        context.triggerHapticFeedback()
                                }
                        }
                        .onEnded { _ in
                                context.operate(.copyAllText)
                        }
                )
        }
}
