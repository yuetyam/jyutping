import SwiftUI
import CommonExtensions

struct EditingPanelClearClipboardKey: View {

        @EnvironmentObject private var context: KeyboardViewController
        @Environment(\.colorScheme) private var colorScheme

        @GestureState private var isTouching: Bool = false

        private let clipboardImageName: String = {
                if #available(iOSApplicationExtension 16.0, *) {
                        return "clipboard"
                } else {
                        return "doc"
                }
        }()

        var body: some View {
                ZStack {
                        Color.interactiveClear
                        RoundedRectangle(cornerRadius: PresetConstant.largeKeyCornerRadius, style: .continuous)
                                .fill(isTouching ? colorScheme.activeActionKeyColor : colorScheme.actionKeyColor)
                                .shadow(color: .shadowGray, radius: 0.5, y: 0.5)
                                .padding(4)
                        VStack(spacing: 4) {
                                Image(systemName: clipboardImageName)
                                Text("EditingPanel.ClearSystemClipboard").font(.keyCaption)
                        }
                }
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
                                context.operate(.clearClipboard)
                        }
                )
        }
}
