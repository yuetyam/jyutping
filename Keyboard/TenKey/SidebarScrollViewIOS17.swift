import SwiftUI

@available(iOS, introduced: 17.0, deprecated: 18.0)
@available(iOSApplicationExtension, introduced: 17.0, deprecated: 18.0)
struct SidebarScrollViewIOS17: View {

        @EnvironmentObject private var context: KeyboardViewController

        private var topID: Int = -1000
        @State private var positionID: Int? = nil
        @State private var sensoryFeedbackTrigger: Bool = false

        var body: some View {
                let idealHeight: CGFloat = ((context.heightUnit * 3.0) / 4.0) - 1.0
                let compactHeight: CGFloat = idealHeight / 2.0
                ScrollView(.vertical) {
                        LazyVStack(spacing: 0) {
                                EmptyView().id(topID)
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
                .scrollPosition(id: $positionID, anchor: .top)
                .defaultScrollAnchor(.top)
                .onChange(of: context.candidateState) {
                        withAnimation {
                                positionID = topID
                        }
                }
                .sensoryFeedback(.selection, trigger: sensoryFeedbackTrigger)
        }
}
