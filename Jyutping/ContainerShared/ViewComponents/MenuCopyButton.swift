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
                        AppMaster.copy(content)
                } label: {
                        Label(title, systemImage: "doc.on.doc")
                }
        }
}


struct URLCopyButton: View {

        init(_ url: String) {
                self.url = url
        }

        private let url: String

        var body: some View {
                Button {
                        AppMaster.copy(url)
                } label: {
                        Label("Copy URL", systemImage: "doc.on.doc")
                }
        }
}

struct UsernameCopyButton: View {

        init(_ username: String) {
                self.username = username
        }

        private let username: String

        var body: some View {
                Button {
                        AppMaster.copy(username)
                } label: {
                        Label("Copy Username", systemImage: "doc.on.doc")
                }
        }
}
