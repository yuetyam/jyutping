import SwiftUI

struct TenKeySidebarScrollView: View {

        @EnvironmentObject private var context: KeyboardViewController
        @Namespace private var topID

        var body: some View {
                let sidebarTexts: [String] = context.sidebarTexts
                let buttonHeight: CGFloat = context.heightUnit * 3.0 / 4.0 - 1.0
                ScrollViewReader { proxy in
                        ScrollView(.vertical) {
                                LazyVStack(spacing: 0) {
                                        EmptyView().id(topID)
                                        ForEach(sidebarTexts.indices, id: \.self) { index in
                                                let text: String = sidebarTexts[index]
                                                ScrollViewButton {
                                                        AudioFeedback.inputed()
                                                        context.triggerSelectionHapticFeedback()
                                                        if context.inputStage.isBuffering {
                                                                // FIXME: Handle tapping
                                                                // context.operate(.toggle(text))
                                                        } else {
                                                                context.operate(.input(text))
                                                        }
                                                        withAnimation {
                                                                proxy.scrollTo(topID)
                                                        }
                                                } label: {
                                                        ZStack {
                                                                Color.interactiveClear
                                                                Text(verbatim: text)
                                                        }
                                                        .frame(height: buttonHeight)
                                                        .frame(maxWidth: .infinity)
                                                }
                                                Divider()
                                        }
                                }
                        }
                }
        }
}
