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
                                Text(title).foregroundStyle(Color.primary)
                        } icon: {
                                Image(systemName: icon).foregroundStyle(Color.accentColor)
                        }
                        Spacer()
                        message?.foregroundStyle(Color.primary)
                        symbol?.foregroundStyle(Color.secondary)
                }
        }
}
