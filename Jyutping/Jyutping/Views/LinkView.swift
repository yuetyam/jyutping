import SwiftUI

struct LinkView: View {
        @State private var isPresented: Bool = false

        let iconName: String
        let text: Text
        let footnote: Text?
        let symbolName: String?

        let url: URL

        var body: some View {
                Button(action: { isPresented = true }) {
                        HStack(spacing: 16) {
                                Image(systemName: iconName)
                                VStack {
                                        HStack {
                                                text.lineLimit(1)
                                                Spacer()
                                        }
                                        Spacer().frame(height: 4)
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
                .padding(.top, 10)
                .padding(.bottom, 6)
                .sheet(isPresented: $isPresented) {
                        SafariView(url: url)
                }
        }
}

struct LinkView_Previews: PreviewProvider {
        static var previews: some View {
                LinkView(iconName: "link.circle",
                         text: Text("粵拼"),
                         footnote: Text("www.jyutping.org"),
                         symbolName: "safari",
                         url: URL(string: "https://www.jyutping.org")!)
        }
}
