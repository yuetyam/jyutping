import SwiftUI
import AboutKit

struct AboutView: View {
        var body: some View {
                ScrollView {
                        LazyVStack(spacing: 16) {
                                HStack(spacing: 16) {
                                        Image(systemName: "info.circle")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 16, height: 16)
                                                .foregroundStyle(Color.accentColor)
                                        Text("Version")
                                        Text(verbatim: version)
                                        Spacer()
                                }
                                .block()

                                VStack {
                                        LinkLabel(icon: "globe.asia.australia", title: "Website", link: About.WebsiteAddress)
                                        LinkLabel(icon: "chevron.left.forwardslash.chevron.right", title: "Source Code", link: About.SourceCodeAddress)
                                        LinkLabel(icon: "lock.circle", title: "Privacy Policy", link: About.PrivacyPolicyAddress)
                                        LinkLabel(icon: "questionmark.circle", title: "FAQ", link: About.FAQAddress)
                                }
                                .block()

                                VStack {
                                        LinkLabel(icon: "paperplane", title: "Telegram Group", link: About.TelegramAddress)
                                        LinkLabel(icon: "person.2", title: "QQ Group", link: About.QQAddress, message: About.QQGroupID)
                                        // TODO: Add Email Feedback
                                }
                                .block()

                                VStack {
                                        LinkLabel(icon: "at", title: "Twitter", link: About.TwitterAddress)
                                        LinkLabel(icon: "circle.square", title: "Instagram", link: About.InstagramAddress)
                                }
                                .block()
                        }
                        .textSelection(.enabled)
                        .padding()
                }
                .navigationTitle("PreferencesView.NavigationTitle.About")
        }

        /// Example: 1.0.1 (23)
        private let version: String = {
                let versionString: String = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? "error"
                let buildString: String = (Bundle.main.infoDictionary?["CFBundleVersion"] as? String) ?? "null"
                return versionString + " (" + buildString + ")"
        }()

}

private struct LinkLabel: View {

        init(icon: String, title: LocalizedStringKey, link: String, message: String? = nil) {
                self.icon = icon
                self.title = title
                self.link = link
                self.message = message ?? link
        }

        private let icon: String
        private let title: LocalizedStringKey
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
                                        Text(title)
                                }
                        }
                        .foregroundStyle(Color.accentColor)
                        Text(verbatim: message).font(.callout.monospaced())
                        Spacer()
                }
        }
}
