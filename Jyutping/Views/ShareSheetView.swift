import SwiftUI

struct ShareSheetView: View {
        @State private var isPresented: Bool = false
        let content: MessageView
        let activityItems: [Any]
        var body: some View {
                Button(action: { self.isPresented.toggle() }) { content }
                        .sheet(isPresented: $isPresented) {
                                ActivityView(activityItems: self.activityItems)
                }
        }
}

struct ShareSheetView_Previews: PreviewProvider {
        static var previews: some View {
                ShareSheetView(content: MessageView(icon: "link.circle",
                                                    text: Text("Test Text"),
                                                    message: Text("Test Message"),
                                                    symbol: Image(systemName: "trash")),
                               activityItems: ["Test Item"])
        }
}
