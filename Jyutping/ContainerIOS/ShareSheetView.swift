import SwiftUI

private struct ActivityView: UIViewControllerRepresentable {

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

struct ShareSheetView<Content: View>: View {

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
                        ActivityView(activityItems: activityItems)
                }
        }
}
