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

struct UsernameCopyButton: View {

        init(_ username: String) {
                self.username = username
        }

        private let username: String

        var body: some View {
                Button {
                        UIPasteboard.general.string = username
                } label: {
                        if #available(iOS 14.0, *) {
                                Label("Copy Username", systemImage: "doc.on.doc")
                        } else {
                                HStack {
                                        Text("Copy Username")
                                        Spacer()
                                        Image(systemName: "doc.on.doc")
                                }
                        }
                }
        }
}
