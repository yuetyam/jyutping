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

                                HStack(spacing: 20) {
                                        HStack(spacing: 8) {
                                                HStack(spacing: 4) {
                                                        Text("Shared.About.Website").font(.master)
                                                        Text.separator
                                                }
                                                Link(About.WebsiteAddress, destination: About.WebsiteURL).monospaced()
                                        }
                                        Button {
                                                AppMaster.copy(About.WebsiteAddress)
                                                isWebsiteAddressCopied = true
                                                Task {
                                                        try? await Task.sleep(for: .seconds(1))
                                                        isWebsiteAddressCopied = false
                                                }
                                        } label: {
                                                ZStack {
                                                        Capsule()
                                                                .fill(Color.textBackgroundColor.opacity(0.9))
                                                                .frame(width: 88, height: 28)
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
                                                        .textSelection(.disabled)
                                                }
                                                .contentShape(.rect)
                                        }
                                        .buttonStyle(.plain)
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
