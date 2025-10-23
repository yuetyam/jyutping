#if os(macOS)

import SwiftUI
import AboutKit

struct MacInputMethodView: View {

        @State private var isWebsiteAddressCopied: Bool = false

        var body: some View {
                ScrollView {
                        LazyVStack(spacing: 16) {
                                VStack(spacing: 16) {
                                        HStack {
                                                Text(verbatim: "由於第三方輸入法無法上架 Mac App Store，所以本應用程式係冇辦法提供輸入法相關功能嘅。詳情可以前往我哋個官網瞭解。")
                                                        .font(.master)
                                                        .lineSpacing(5)
                                                Spacer()
                                        }
                                        HStack {
                                                Text(verbatim: "Due to limitations imposed by the Mac App Store on third-party input methods, this app is impossible to provide input method related features. You can find more details on our website.")
                                                Spacer()
                                        }
                                }
                                .block()

                                HStack(spacing: 16) {
                                        Link("Shared.About.Website", destination: About.WebsiteURL)
                                                .font(.master)
                                                .foregroundStyle(Color.accentColor)
                                        Text(verbatim: About.WebsiteAddress).monospaced()
                                        Button {
                                                AppMaster.copy(About.WebsiteAddress)
                                                isWebsiteAddressCopied = true
                                                Task {
                                                        try await Task.sleep(nanoseconds: 2_000_000_000) // 2s
                                                        isWebsiteAddressCopied = false
                                                }
                                        } label: {
                                                HStack(spacing: 4) {
                                                        Image(systemName: isWebsiteAddressCopied ? "text.badge.checkmark" : "doc.on.doc")
                                                                .resizable()
                                                                .scaledToFit()
                                                                .frame(width: 16, height: 16)
                                                        if isWebsiteAddressCopied {
                                                                Text("General.Copied").font(.master)
                                                        } else {
                                                                Text("General.Copy").font(.master)
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
