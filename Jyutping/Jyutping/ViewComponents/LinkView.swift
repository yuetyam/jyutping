import SwiftUI

struct LinkView: View {

        let iconName: String
        let text: Text
        let footnote: Text?
        let symbolName: String?
        let url: URL

        @State private var isSheetPresented: Bool = false

        var body: some View {
                Button(action: {
                        isSheetPresented = true
                }) {
                        HStack(spacing: 16) {
                                Image(systemName: iconName)
                                VStack(spacing: 2) {
                                        HStack {
                                                text.lineLimit(1)
                                                Spacer()
                                        }
                                        HStack {
                                                if #available(iOS 14.0, *) {
                                                        footnote?.lineLimit(1).font(.system(.caption2, design: .monospaced)).opacity(0.7)
                                                } else {
                                                        footnote?.lineLimit(1).font(.system(.caption, design: .monospaced)).opacity(0.7)
                                                }
                                                Spacer()
                                        }
                                }
                                Spacer()
                                if symbolName != nil {
                                        Image(systemName: symbolName ?? "circle").opacity(0.5)
                                }
                        }
                }
                .padding(.horizontal)
                .sheet(isPresented: $isSheetPresented) {
                        SafariView(url: url)
                }
        }
}

struct LinkView_Previews: PreviewProvider {
        static var previews: some View {
                LinkView(iconName: "link.circle",
                         text: Text("Test"),
                         footnote: Text("cantonese.im"),
                         symbolName: "safari",
                         url: URL(string: "https://cantonese.im")!)
        }
}

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
