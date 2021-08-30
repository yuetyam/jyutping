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


@available(iOS 15.0, *)
struct ActivityView_iOS15: UIViewControllerRepresentable {

        private let activityItems: [Any]
        private let excludedActivityTypes: [UIActivity.ActivityType]?
        private let completion: (() -> Void)?

        init(activityItems: [Any], excludedActivityTypes: [UIActivity.ActivityType]? = nil, completion: (() -> Void)? = nil) {
                self.activityItems = activityItems
                self.excludedActivityTypes = excludedActivityTypes
                self.completion = completion
        }

        private func completionHandler(activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, activityError: Error?) {
                completion?()
        }

        func makeUIViewController(context: Context) -> UIActivityViewController {
                let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
                controller.excludedActivityTypes = excludedActivityTypes
                controller.completionWithItemsHandler = completionHandler
                return controller
        }

        func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

@available(iOS 15.0, *)
struct ShareSheetView_iOS15<Content: View>: View {

        private let activityItems: [Any]
        private let label: Content

        init(activityItems: [Any], @ViewBuilder label: () -> Content) {
                self.activityItems = activityItems
                self.label = label()
        }

        @State private var isSheetPresented: Bool = false

        var body: some View {
                Button(action: {
                        isSheetPresented = true
                }) {
                        label
                }
                .sheet(isPresented: $isSheetPresented) {
                        ActivityView_iOS15(activityItems: activityItems)
                }
        }
}
