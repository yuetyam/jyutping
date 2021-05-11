import SwiftUI

struct ShareSheetView: View {

        let content: MessageView
        let activityItems: [Any]

        @State private var isSheetPresented: Bool = false

        var body: some View {
                Button {
                        isSheetPresented = true
                } label: {
                        content
                }
                .sheet(isPresented: $isSheetPresented) {
                        ActivityView(activityItems: activityItems)
                }
        }
}

struct ShareSheetView_Previews: PreviewProvider {
        static var previews: some View {
                ShareSheetView(content: MessageView(icon: "link.circle",
                                                    text: Text("Test Text"),
                                                    message: Text("Test Message"),
                                                    symbol: Image(systemName: "info.circle")),
                               activityItems: ["Test Item"])
        }
}


private struct ActivityView: UIViewControllerRepresentable {

        let activityItems: [Any]

        func makeUIViewController(context: Context) -> UIActivityViewController {
                return UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        }

        func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
