import SwiftUI

struct MenuCopyButton: View {
        let content: String
        var body: some View {
                Button(action: {
                        UIPasteboard.general.string = content
                }) {
                        MenuLabel(text: "Copy", image: "doc.on.doc")
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
