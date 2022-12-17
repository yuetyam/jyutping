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
