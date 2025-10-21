import SwiftUI

@available(iOS, deprecated: 17.0)
@available(iOSApplicationExtension, deprecated: 17.0)
struct SidebarScrollViewIOS16: View {

        @EnvironmentObject private var context: KeyboardViewController
        @Namespace private var topID

        var body: some View {
                let idealHeight: CGFloat = ((context.heightUnit * 3.0) / 4.0) - 1.0
                let compactHeight: CGFloat = idealHeight / 2.0
                ScrollViewReader { proxy in
                        ScrollView(.vertical) {
                                LazyVStack(spacing: 0) {
                                        EmptyView().id(topID)
                                        ForEach(context.sidebarSyllables.indices, id: \.self) { index in
                                                let item = context.sidebarSyllables[index]
                                                ScrollViewButton {
                                                        AudioFeedback.inputed()
                                                        context.triggerSelectionHapticFeedback()
                                                        context.handleSidebarTapping(at: index)
                                                } label: {
                                                        ZStack {
                                                                Color.interactiveClear
                                                                Rectangle()
                                                                        .fill(Material.regular)
                                                                        .opacity(item.isSelected ? 1 : 0)
                                                                Text(verbatim: item.text)
                                                                        .lineLimit(1)
                                                                        .minimumScaleFactor(0.5)
                                                        }
                                                        .frame(height: item.isSelected ? compactHeight : idealHeight)
                                                        .frame(maxWidth: .infinity)
                                                }
                                                Divider()
                                        }
                                }
                        }
                        .onChange(of: context.candidateState) { _ in
                                withAnimation {
                                        proxy.scrollTo(topID)
                                }
                        }
                }
        }
}
