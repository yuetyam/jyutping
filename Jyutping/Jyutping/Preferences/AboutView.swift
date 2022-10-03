import SwiftUI

struct AboutView: View {
        var body: some View {
                ScrollView {
                        LazyVStack(spacing: 16) {
                                HStack(spacing: 16) {
                                        Image(systemName: "info.circle")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 16, height: 16)
                                                .foregroundColor(.blue)
                                        Text("Version")
                                        Text(verbatim: version)
                                        Spacer()
                                }
                                .block()

                                VStack {
                                        LinkLabel(icon: "globe.asia.australia", tittle: "Website", link: "https://jyutping.app")
                                        LinkLabel(icon: "chevron.left.forwardslash.chevron.right", tittle: "Source Code", link: "https://github.com/yuetyam/jyutping")
                                        LinkLabel(icon: "lock.circle", tittle: "Privacy Policy", link: "https://jyutping.app/privacy")
                                }
                                .block()

                                VStack {
                                        LinkLabel(icon: "paperplane", tittle: "Telegram Group", link: "https://t.me/jyutping")
                                        LinkLabel(icon: "person.2", tittle: "QQ Group", link: #"https://jq.qq.com/?k=4PR17m3t"#, message: "293148593")
                                }
                                .block()

                                VStack {
                                        LinkLabel(icon: "t.square", tittle: "TRUTH Social", link: "https://truthsocial.com/@Cantonese")
                                        LinkLabel(icon: "at", tittle: "Twitter", link: "https://twitter.com/JyutpingApp")
                                        LinkLabel(icon: "circle.square", tittle: "Instagram", link: "https://www.instagram.com/jyutping_app")
                                }
                                .block()
                        }
                        .textSelection(.enabled)
                        .padding()
                }
                .background(.ultraThinMaterial)
                .navigationTitle("About")
        }

        /// Example: 1.0.1 (23)
        private let version: String = {
                let versionString: String = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? "error"
                let buildString: String = (Bundle.main.infoDictionary?["CFBundleVersion"] as? String) ?? "null"
                return versionString + " (" + buildString + ")"
        }()

}

private struct LinkLabel: View {

        init(icon: String, tittle: LocalizedStringKey, link: String, message: String? = nil) {
                self.icon = icon
                self.tittle = tittle
                self.link = link
                self.message = message ?? link
        }

        private let icon: String
        private let tittle: LocalizedStringKey
        private let link: String
        private let message: String

        var body: some View {
                HStack(spacing: 16) {
                        Link(destination: URL(string: link)!) {
                                HStack(spacing: 16) {
                                        Image(systemName: icon)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 16, height: 16)
                                        Text(tittle)
                                }
                        }
                        Text(verbatim: message).font(.callout.monospaced())
                        Spacer()
                }
        }
}
