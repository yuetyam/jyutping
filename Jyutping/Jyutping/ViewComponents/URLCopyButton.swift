import SwiftUI

struct URLCopyButton: View {

        init(_ url: String) {
                self.url = url
        }

        private let url: String

        var body: some View {
                Button {
                        UIPasteboard.general.string = url
                } label: {
                        if #available(iOS 14.0, *) {
                                Label("Copy URL", systemImage: "doc.on.doc")
                        } else {
                                HStack {
                                        Text("Copy URL")
                                        Spacer()
                                        Image(systemName: "doc.on.doc")
                                }
                        }
                }
        }
}


struct URLCopyButton_Previews: PreviewProvider {
        static var previews: some View {
                URLCopyButton("URL")
        }
}
