import SwiftUI

struct MenuCopyButton: View {

        init(_ content: String, title: LocalizedStringKey = "Copy") {
                self.content = content
                self.title = title
        }

        private let content: String
        private let title: LocalizedStringKey

        var body: some View {
                Button {
                        UIPasteboard.general.string = content
                } label: {
                        if #available(iOS 14.0, *) {
                                Label(title, systemImage: "doc.on.doc")
                        } else {
                                HStack {
                                        Text(title)
                                        Spacer()
                                        Image(systemName: "doc.on.doc")
                                }
                        }
                }
        }
}
