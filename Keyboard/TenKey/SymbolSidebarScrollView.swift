import SwiftUI

@available(iOS 18.0, *)
@available(iOSApplicationExtension 18.0, *)
struct SymbolSidebarScrollView: View {

        let texts: [String]

        @EnvironmentObject private var context: KeyboardViewController

        @State private var scrollPosition = ScrollPosition()

        var body: some View {
                let buttonHeight: CGFloat = context.heightUnit * 3.0 / 4.0 - 1.0
                ScrollView(.vertical) {
                        LazyVStack(spacing: 0) {
                                ForEach(texts.indices, id: \.self) { index in
                                        let symbol: String = texts[index]
                                        ScrollViewButton {
                                                AudioFeedback.inputed()
                                                context.triggerHapticFeedback()
                                                context.operate(.input(symbol))
                                                withAnimation {
                                                        scrollPosition.scrollTo(edge: .top)
                                                }
                                        } label: {
                                                ZStack {
                                                        Color.interactiveClear
                                                        Text(verbatim: symbol)
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
        }
}
