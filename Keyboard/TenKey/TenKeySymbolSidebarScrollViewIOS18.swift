import SwiftUI

@available(iOS 18.0, *)
@available(iOSApplicationExtension 18.0, *)
struct TenKeySymbolSidebarScrollViewIOS18: View {

        @EnvironmentObject private var context: KeyboardViewController

        @State private var scrollPosition = ScrollPosition()

        var body: some View {
                let sidebarTexts: [String] = PresetConstant.symbolSidebarTexts
                let buttonHeight: CGFloat = context.heightUnit * 3.0 / 4.0 - 1.0
                ScrollView(.vertical) {
                        LazyVStack(spacing: 0) {
                                ForEach(sidebarTexts.indices, id: \.self) { index in
                                        let symbol: String = sidebarTexts[index]
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
                                                        Text(verbatim: symbol).font(.title3)
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
