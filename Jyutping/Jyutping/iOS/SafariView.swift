#if os(iOS)

import SwiftUI
import SafariServices

private struct SafariView: UIViewControllerRepresentable {
        
        let url: URL
        
        func makeUIViewController(context: Context) -> SFSafariViewController {
                return SFSafariViewController(url: url)
        }
        
        func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {}
}


struct SafariLink<Content: View>: View {

        init(_ address: String, @ViewBuilder label: () -> Content) {
                self.address = address
                self.label = label()
        }

        private let address: String
        private let label: Content

        @State private var isSafariSheetPresented: Bool = false

        var body: some View {
                Button {
                        isSafariSheetPresented = true
                } label: {
                        label
                }
                .contextMenu {
                        URLCopyButton(address)
                }
                .sheet(isPresented: $isSafariSheetPresented) {
                        SafariView(url: URL(string: address)!)
                }
        }
}


struct ExtendedLinkLabel: View {

        init(icon: String = "link.circle", title: String, footnote: String? = nil, address: String, symbol: String = "safari") {
                self.icon = icon
                self.text = Text(verbatim: title)
                self.footnote = footnote ?? address
                self.address = address
                self.symbol = symbol
        }
        init(icon: String = "link.circle", text: Text, footnote: String? = nil, address: String, symbol: String = "safari") {
                self.icon = icon
                self.text = text
                self.footnote = footnote ?? address
                self.address = address
                self.symbol = symbol
        }

        private let icon: String
        private let text: Text
        private let footnote: String
        private let address: String
        private let symbol: String

        @State private var isSafariSheetPresented: Bool = false

        var body: some View {
                Button {
                        isSafariSheetPresented = true
                } label: {
                        HStack(spacing: 16) {
                                Image(systemName: icon)
                                VStack(spacing: 2) {
                                        HStack {
                                                text.foregroundColor(.primary)
                                                Spacer()
                                        }
                                        HStack {
                                                Text(verbatim: footnote)
                                                        .minimumScaleFactor(0.5)
                                                        .lineLimit(1)
                                                        .font(.caption2)
                                                        .foregroundColor(.secondary)
                                                Spacer()
                                        }
                                }
                                Spacer()
                                Image(systemName: symbol).foregroundColor(.secondary)
                        }
                }
                .contextMenu {
                        URLCopyButton(address)
                }
                .sheet(isPresented: $isSafariSheetPresented) {
                        SafariView(url: URL(string: address)!)
                }
        }
}

#endif
