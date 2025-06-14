import SwiftUI

struct SidebarSyllable: Hashable {
        let text: String
        let isSelected: Bool
}

@available(iOS 18.0, *)
@available(iOSApplicationExtension 18.0, *)
struct SidebarScrollView: View {

        @EnvironmentObject private var context: KeyboardViewController

        @State private var scrollPosition = ScrollPosition()

        var body: some View {
                let items = context.sidebarSyllables
                let idealHeight: CGFloat = ((context.heightUnit * 3.0) / 4.0) - 1.0
                let compactHeight: CGFloat = idealHeight / 2.0
                ScrollView(.vertical) {
                        LazyVStack(spacing: 0) {
                                ForEach(items.indices, id: \.self) { index in
                                        let item = items[index]
                                        ScrollViewButton {
                                                AudioFeedback.inputed()
                                                context.triggerSelectionHapticFeedback()
                                                context.handleSidebarTapping(at: index)
                                                withAnimation {
                                                        scrollPosition.scrollTo(edge: .top)
                                                }
                                        } label: {
                                                ZStack {
                                                        Color.interactiveClear
                                                        Rectangle()
                                                                .fill(Material.regular)
                                                                .opacity(item.isSelected ? 1 : 0)
                                                        Text(verbatim: item.text)
                                                }
                                                .frame(height: item.isSelected ? compactHeight : idealHeight)
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
