import SwiftUI

struct InputMethodInstallationView: View {

        private let homebrewCommand: String = "brew install --cask jyutping"
        private let GitHubAddress: String = "https://github.com/yuetyam/jyutping/releases"

        @State private var isHomebrewCommandCopied: Bool = false
        @State private var isGitHubAddressCopied: Bool = false

        var body: some View {
                ScrollView {
                        LazyVStack(spacing: 16) {
                                VStack(spacing: 16) {
                                        HStack {
                                                Text(verbatim: "由於各種因素限制，本應用程式並冇包含輸入法本身。請另行下載、安裝輸入法程式。")
                                                Spacer()
                                        }
                                        HStack {
                                                Text(verbatim: "Due to various limitations, this App does not contain an Input Method. Please download and install the Input Method program separately.")
                                                Spacer()
                                        }
                                }
                                .block()

                                VStack(alignment: .leading, spacing: 16) {
                                        HStack {
                                                Text("Option 1").font(.subheadline)
                                                Spacer()
                                        }
                                        HStack {
                                                Text("If you're using Homebrew")
                                                Spacer()
                                        }
                                        HStack(spacing: 16) {
                                                Text(verbatim: homebrewCommand).font(.body.monospaced())
                                                Button {
                                                        NSPasteboard.general.clearContents()
                                                        NSPasteboard.general.setString(homebrewCommand, forType: .string)
                                                        isHomebrewCommandCopied = true
                                                        isGitHubAddressCopied = false
                                                } label: {
                                                        HStack(spacing: 4) {
                                                                if isHomebrewCommandCopied {
                                                                        Image(systemName: "text.badge.checkmark")
                                                                        Text("Copied")
                                                                } else {
                                                                        Image(systemName: "doc.on.doc")
                                                                        Text("Copy")
                                                                }
                                                        }
                                                }
                                                Spacer()
                                        }
                                }
                                .block()

                                VStack(alignment: .leading, spacing: 16) {
                                        HStack {
                                                Text("Option 2").font(.subheadline)
                                                Spacer()
                                        }
                                        HStack {
                                                Text("Install from GitHub")
                                                Spacer()
                                        }
                                        HStack(spacing: 16) {
                                                Text(verbatim: GitHubAddress).font(.body.monospaced())
                                                Button {
                                                        NSPasteboard.general.clearContents()
                                                        NSPasteboard.general.setString(GitHubAddress, forType: .string)
                                                        isGitHubAddressCopied = true
                                                        isHomebrewCommandCopied = false
                                                } label: {
                                                        HStack(spacing: 4) {
                                                                if isGitHubAddressCopied {
                                                                        Image(systemName: "text.badge.checkmark")
                                                                        Text("Copied")
                                                                } else {
                                                                        Image(systemName: "doc.on.doc")
                                                                        Text("Copy")
                                                                }
                                                        }
                                                }
                                                Spacer()
                                        }
                                }
                                .block()
                        }
                        .textSelection(.enabled)
                        .padding()
                }
                .navigationTitle("Install Input Method")
        }
}
