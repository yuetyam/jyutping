import SwiftUI

struct MenuCopyButton: View {

        init(_ content: String) {
                self.content = content
        }

        let content: String

        var body: some View {
                Button(action: {
                        UIPasteboard.general.string = content
                }) {
                        if #available(iOS 14.0, *) {
                                Label("Copy", systemImage: "doc.on.doc")
                        } else {
                                HStack {
                                        Text("Copy")
                                        Spacer()
                                        Image(systemName: "doc.on.doc")
                                }
                        }
                }
        }
}
