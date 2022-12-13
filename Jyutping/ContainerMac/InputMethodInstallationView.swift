import SwiftUI

struct InputMethodInstallationView: View {

        private let websiteAddress: String = "https://jyutping.app"

        @State private var isWebsiteAddressCopied: Bool = false

        var body: some View {
                ScrollView {
                        LazyVStack(spacing: 16) {
                                VStack(spacing: 16) {
                                        HStack {
                                                Text(verbatim: "由於各種因素限制，本應用程式並冇包含輸入法本身。請前往網站下載輸入法程式，另行安裝。")
                                                Spacer()
                                        }
                                        HStack {
                                                Text(verbatim: "Due to various limitations, this App does not contain an Input Method. Please download the Input Method program from our website and install it separately.")
                                                Spacer()
                                        }
                                }
                                .block()

                                HStack(spacing: 16) {
                                        Link("Website", destination: URL(string: websiteAddress)!)
                                        Text(verbatim: websiteAddress).font(.body.monospaced())
                                        Button {
                                                AppMaster.copy(websiteAddress)
                                                isWebsiteAddressCopied = true
                                        } label: {
                                                if isWebsiteAddressCopied {
                                                        HStack(spacing: 4) {
                                                                Image(systemName: "text.badge.checkmark")
                                                                Text("Copied")
                                                        }
                                                } else {
                                                        HStack(spacing: 4) {
                                                                Image(systemName: "doc.on.doc")
                                                                Text("Copy")
                                                        }
                                                }
                                        }
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
