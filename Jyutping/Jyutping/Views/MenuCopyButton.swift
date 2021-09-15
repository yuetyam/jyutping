import SwiftUI

struct MenuCopyButton: View {
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

struct MenuLabel: View {
        let text: String
        let image: String
        var body: some View {
                HStack {
                        Text(NSLocalizedString(text, comment: ""))
                        Spacer()
                        Image(systemName: image)
                }
        }
}
