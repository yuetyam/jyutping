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

        init(icon: String = "globe.asia.australia", title: String, footnote: String? = nil, address: String, symbol: String = "safari") {
                self.icon = icon
                self.title = title
                self.footnote = footnote ?? address
                self.address = address
                self.symbol = symbol
                self.url = URL(string: address) ?? URL(string: "https://jyutping.app")!
        }

        private let icon: String
        private let title: String
        private let footnote: String
        private let address: String
        private let symbol: String
        private let url: URL

        @State private var isSafariSheetPresented: Bool = false

        var body: some View {
                Button {
                        isSafariSheetPresented = true
                } label: {
                        Label {
                                HStack {
                                        VStack(alignment: .leading, spacing: 1) {
                                                Text(verbatim: title).foregroundStyle(Color.primary)
                                                Text(verbatim: footnote)
                                                        .minimumScaleFactor(0.5)
                                                        .lineLimit(1)
                                                        .font(.caption2)
                                                        .foregroundStyle(Color.secondary)
                                        }
                                        Spacer()
                                        Image(systemName: symbol).foregroundStyle(Color.secondary)
                                }
                        } icon: {
                                Image(systemName: icon)
                        }
                }
                .contextMenu {
                        URLCopyButton(address)
                }
                .sheet(isPresented: $isSafariSheetPresented) {
                        SafariView(url: url)
                }
        }
}

#endif
