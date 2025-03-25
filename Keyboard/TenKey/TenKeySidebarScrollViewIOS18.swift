import SwiftUI

@available(iOS 18.0, *)
@available(iOSApplicationExtension 18.0, *)
struct TenKeySidebarScrollViewIOS18: View {

        @EnvironmentObject private var context: KeyboardViewController

        @State private var scrollPosition = ScrollPosition()

        var body: some View {
                let sidebarTexts: [String] = context.sidebarTexts
                let buttonHeight: CGFloat = context.heightUnit * 3.0 / 4.0 - 1.0
                ScrollView(.vertical) {
                        LazyVStack(spacing: 0) {
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
                                                        scrollPosition.scrollTo(edge: .top)
                                                }
                                        } label: {
                                                ZStack {
                                                        Color.interactiveClear
                                                        Text(verbatim: text).font(.title3)
                                                }
                                                .frame(height: buttonHeight)
                                                .frame(maxWidth: .infinity)
                                        }
                                        Divider()
                                }
                        }
                }
                .scrollPosition($scrollPosition, anchor: .top)
                .defaultScrollAnchor(.top)
                .defaultScrollAnchor(.top, for: .initialOffset)
                .defaultScrollAnchor(.top, for: .alignment)
                .defaultScrollAnchor(.top, for: .sizeChanges)
        }
}
