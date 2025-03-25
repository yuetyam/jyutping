import SwiftUI

@available(iOS 17.0, *)
@available(iOSApplicationExtension 17.0, *)
struct TenKeySidebarScrollViewIOS17: View {

        @EnvironmentObject private var context: KeyboardViewController

        private var topID: Int = -1000
        @State private var positionID: Int? = nil

        var body: some View {
                let sidebarTexts: [String] = context.sidebarTexts
                let buttonHeight: CGFloat = context.heightUnit * 3.0 / 4.0 - 1.0
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
                                                        positionID = topID
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
                .scrollPosition(id: $positionID, anchor: .top)
                .defaultScrollAnchor(.top)
        }
}
