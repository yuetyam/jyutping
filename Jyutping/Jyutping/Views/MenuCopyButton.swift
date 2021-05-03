import SwiftUI

struct MenuCopyButton: View {
        let content: String
        var body: some View {
                Button(action: {
                        UIPasteboard.general.string = content
                }) {
                        HStack {
                                Text("Copy")
                                Spacer()
                                Image(systemName: "doc.on.doc")
                        }
                }
        }
}
