import SwiftUI

struct InputMethodInstallationView: View {

        private let GitHubAddress: String = "https://github.com/yuetyam/jyutping/releases"

        var body: some View {
                ScrollView {
                        LazyVStack(spacing: 16) {
                                VStack(spacing: 16) {
                                        HStack {
                                                Text(verbatim: "由於各種因素限制，本App並冇包含輸入法本身。請前往 GitHub 下載輸入法程式，另行安裝。")
                                                Spacer()
                                        }
                                        HStack {
                                                Text(verbatim: "Due to various limitations, this App does not contain an Input Method. Please go to GitHub to download the Input Method program and install it separately.")
                                                Spacer()
                                        }
                                }
                                .block()

                                HStack(spacing: 16) {
                                        Link("GitHub", destination: URL(string: GitHubAddress)!)
                                        Text(verbatim: GitHubAddress).font(.body.monospaced())
                                        Spacer()
                                }
                                .block()
                        }
                        .textSelection(.enabled)
                        .padding()
                }
                .navigationTitle("Install Input Method")
        }
}
