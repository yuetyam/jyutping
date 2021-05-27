import SwiftUI

struct MessageView: View {
        
        let icon: String
        let text: Text
        let message: Text?
        let symbol: Image?
        
        var body: some View {
                HStack(spacing: 16) {
                        Image(systemName: icon)
                        text
                        Spacer()
                        message
                        symbol.opacity(0.5)
                }
                .padding(.horizontal)
        }
        
        init(icon: String, text: Text, message: Text? = nil, symbol: Image? = nil) {
                self.icon = icon
                self.text = text
                self.message = message
                self.symbol = symbol
        }
}

struct MessageView_Previews: PreviewProvider {
        static var previews: some View {
                MessageView(icon: "link.circle",
                            text: Text("Test Text"),
                            message: Text("Test Message"),
                            symbol: Image(systemName: "trash"))
        }
}
