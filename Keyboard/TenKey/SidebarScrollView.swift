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
        @State private var sensoryFeedbackTrigger: Bool = false

        var body: some View {
                let idealHeight: CGFloat = ((context.heightUnit * 3.0) / 4.0) - 1.0
                let compactHeight: CGFloat = idealHeight / 2.0
                ScrollView(.vertical) {
                        LazyVStack(spacing: 0) {
                                ForEach(context.sidebarSyllables.indices, id: \.self) { index in
                                        let item = context.sidebarSyllables[index]
                                        ScrollViewButton {
                                                AudioFeedback.inputed()
                                                sensoryFeedbackTrigger.toggle()
                                                context.handleSidebarTapping(at: index)
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
                .onChange(of: context.candidateState) {
                        withAnimation {
                                scrollPosition.scrollTo(edge: .top)
                        }
                }
                .sensoryFeedback(.selection, trigger: sensoryFeedbackTrigger)
        }
}
