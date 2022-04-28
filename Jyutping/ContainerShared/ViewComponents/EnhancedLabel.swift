import SwiftUI

struct EnhancedLabel: View {

        private let title: LocalizedStringKey
        private let icon: String
        private let message: Text?
        private let symbol: Image?

        init(_ title: LocalizedStringKey, icon: String, message: Text? = nil, symbol: Image? = nil) {
                self.title = title
                self.icon = icon
                self.message = message
                self.symbol = symbol
        }

        var body: some View {
                HStack {
                        Label {
                                Text(title).foregroundColor(.primary)
                        } icon: {
                                Image(systemName: icon).foregroundColor(.blue)
                        }
                        Spacer()
                        message?.foregroundColor(.primary)
                        symbol?.foregroundColor(.secondary)
                }
        }
}

struct EnhancedLabel_Previews: PreviewProvider {
        static var previews: some View {
                EnhancedLabel("Test Text",
                              icon: "info.circle",
                              message: Text("Test Message"),
                              symbol: Image(systemName: "plus"))
        }
}


struct FootnoteLabelView: View {

        init(icon: String = "link.circle", title: Text, footnote: String, symbol: String = "safari") {
                self.icon = icon
                self.title = title
                self.footnote = footnote
                self.symbol = symbol
        }

        private let icon: String
        private let title: Text
        private let footnote: String
        private let symbol: String

        var body: some View {
                HStack(spacing: 16) {
                        Image(systemName: icon)
                        VStack(spacing: 2) {
                                HStack {
                                        title.foregroundColor(.primary)
                                        Spacer()
                                }
                                HStack {
                                        Text(verbatim: footnote).lineLimit(1).font(.caption2).foregroundColor(.secondary)
                                        Spacer()
                                }
                        }
                        Spacer()
                        Image(systemName: symbol).foregroundColor(.secondary)
                }
        }
}
