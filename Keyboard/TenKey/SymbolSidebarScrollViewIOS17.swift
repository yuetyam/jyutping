import SwiftUI

@available(iOS, introduced: 17.0, deprecated: 18.0)
@available(iOSApplicationExtension, introduced: 17.0, deprecated: 18.0)
struct SymbolSidebarScrollViewIOS17: View {

        init(texts: [String]) {
                self.texts = texts
        }

        private let texts: [String]

        @EnvironmentObject private var context: KeyboardViewController

        private var topID: Int = -1000
        @State private var positionID: Int? = nil

        var body: some View {
                let buttonHeight: CGFloat = context.heightUnit * 3.0 / 4.0 - 1.0
                ScrollView(.vertical) {
                        LazyVStack(spacing: 0) {
                                EmptyView().id(topID)
                                ForEach(texts.indices, id: \.self) { index in
                                        let symbol: String = texts[index]
                                        ScrollViewButton {
                                                AudioFeedback.inputed()
                                                context.triggerHapticFeedback()
                                                context.operate(.input(symbol))
                                                withAnimation {
                                                        positionID = topID
                                                }
                                        } label: {
                                                ZStack {
                                                        Color.interactiveClear
                                                        Text(verbatim: symbol).font(.title3)
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
