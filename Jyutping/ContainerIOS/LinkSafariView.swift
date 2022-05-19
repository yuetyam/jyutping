import SwiftUI

struct LinkSafariView<Content: View>: View {

        private let url: URL
        private let label: Content

        init(url: URL, @ViewBuilder label: () -> Content) {
                self.url = url
                self.label = label()
        }

        @State private var isSafariSheetPresented: Bool = false

        var body: some View {
                Button(action: {
                        isSafariSheetPresented = true
                }) {
                        label
                }
                .sheet(isPresented: $isSafariSheetPresented) {
                        SafariView(url: url)
                }
        }
}
