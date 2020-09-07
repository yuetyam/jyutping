import SwiftUI

struct LinkButton: View {
        
        @State private var isPresented: Bool = false
        
        let url: URL
        let content: MessageView
        
        var body: some View {
                Button(action: { self.isPresented.toggle() }) { content }
                        .sheet(isPresented: $isPresented) { SafariView(url: self.url) }
        }
}

struct LinkButton_Previews: PreviewProvider {
        static var previews: some View {
                LinkButton(url: URL(string: "https://ososo.io")!,
                           content: MessageView(icon: "link.circle",
                                                text: Text("Test Text"),
                                                message: Text("Test Message"),
                                                symbol: Image(systemName: "trash")))
        }
}
