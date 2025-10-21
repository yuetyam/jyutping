import SwiftUI

@available(iOS, deprecated: 17.0)
@available(iOSApplicationExtension, deprecated: 17.0)
struct SymbolSidebarScrollViewIOS16: View {

        let texts: [String]

        @EnvironmentObject private var context: KeyboardViewController
        @Namespace private var topID

        var body: some View {
                let buttonHeight: CGFloat = context.heightUnit * 3.0 / 4.0 - 1.0
                ScrollViewReader { proxy in
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
                                                                proxy.scrollTo(topID)
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
                }
        }
}
