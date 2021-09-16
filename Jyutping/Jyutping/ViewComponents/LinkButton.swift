import SwiftUI

struct LinkButton: View {

        let url: URL
        let content: MessageView

        @State private var isSheetPresented: Bool = false

        var body: some View {
                Button {
                        isSheetPresented = true
                } label: {
                        content
                }
                .sheet(isPresented: $isSheetPresented) {
                        SafariView(url: url)
                }
        }
}

struct LinkButton_Previews: PreviewProvider {
        static var previews: some View {
                LinkButton(url: URL(string: "https://cantonese.im")!,
                           content: MessageView(icon: "link.circle",
                                                text: Text("Test Text"),
                                                message: Text("Test Message"),
                                                symbol: Image(systemName: "trash")))
        }
}
