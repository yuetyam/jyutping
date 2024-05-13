#if os(macOS)

import SwiftUI
import AboutKit

struct MacInstallInputMethodView: View {

        @State private var isWebsiteAddressCopied: Bool = false

        var body: some View {
                ScrollView {
                        LazyVStack(spacing: 16) {
                                VStack(spacing: 16) {
                                        HStack {
                                                Text(verbatim: "由於各種因素限制，本應用程式並冇包含輸入法本身。請前往官網瞭解詳情。")
                                                        .font(.master)
                                                Spacer()
                                        }
                                        HStack {
                                                Text(verbatim: "Due to various limitations, this App does not contain an Input Method. Please visit out website for more details.")
                                                Spacer()
                                        }
                                }
                                .block()

                                HStack(spacing: 16) {
                                        Link("Shared.About.Website", destination: About.WebsiteURL)
                                                .font(.master)
                                                .foregroundStyle(Color.accentColor)
                                        Text(verbatim: About.WebsiteAddress)
                                                .font(.fixedWidth)
                                        Button {
                                                AppMaster.copy(About.WebsiteAddress)
                                                isWebsiteAddressCopied = true
                                        } label: {
                                                if isWebsiteAddressCopied {
                                                        HStack(spacing: 4) {
                                                                Image(systemName: "text.badge.checkmark")
                                                                Text("General.Copied")
                                                                        .font(.master)
                                                        }
                                                } else {
                                                        HStack(spacing: 4) {
                                                                Image(systemName: "doc.on.doc")
                                                                Text("General.Copy")
                                                                        .font(.master)
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
                .navigationTitle("MacSidebar.NavigationTitle.InstallInputMethod")
        }
}

#endif
