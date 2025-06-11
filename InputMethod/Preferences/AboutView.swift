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
                                        Text("AboutView.Version")
                                        Text(verbatim: version)
                                        Spacer()
                                }
                                .block()

                                VStack {
                                        LinkLabel(icon: "globe.asia.australia", title: "AboutView.Website", link: About.WebsiteAddress)
                                        LinkLabel(icon: "curlybraces.square", title: "AboutView.SourceCode", link: About.SourceCodeAddress)
                                        LinkLabel(icon: "lock.circle", title: "AboutView.PrivacyPolicy", link: About.PrivacyPolicyAddress)
                                        LinkLabel(icon: "questionmark.circle", title: "AboutView.FAQ", link: About.FAQAddress)
                                }
                                .block()

                                VStack {
                                        LinkLabel(icon: "paperplane", title: "AboutView.TelegramGroup", link: About.TelegramAddress)
                                        LinkLabel(icon: "person.2", title: "AboutView.QQGroup", link: About.QQAddress, message: About.QQGroupID)
                                        LinkLabel(icon: "book", title: "AboutView.RedNote", link: About.RedNoteAddress)
                                        LinkLabel(icon: "circle.square", title: "AboutView.Instagram", link: About.InstagramAddress)
                                        LinkLabel(icon: "at", title: "AboutView.Threads", link: About.ThreadsAddress)
                                        LinkLabel(icon: "at", title: "AboutView.Twitter", link: About.TwitterAddress)
                                }
                                .block()

                                VStack {
                                        LinkLabel(icon: "checkmark.message", title: "AboutView.GoogleForms", link: About.GoogleFormsAddress)
                                        LinkLabel(icon: "checkmark.message", title: "AboutView.TencentSurvey", link: About.TencentSurveyAddress)
                                        LinkLabel(icon: "envelope", title: "AboutView.EmailFeedback", link: mailtoScheme, message: About.EmailAddress)
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

        private let mailtoScheme: String = {
                let versionString: String = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? "error"
                let buildString: String = (Bundle.main.infoDictionary?["CFBundleVersion"] as? String) ?? "null"
                let appVersion: String = versionString + " (" + buildString + ")"
                let osVersion = ProcessInfo.processInfo.operatingSystemVersion
                let system: String = "macOS \(osVersion.majorVersion).\(osVersion.minorVersion).\(osVersion.patchVersion)"
                let messageBody: String = """


                Version: \(appVersion)
                System: \(system)
                """
                let address: String = About.EmailAddress
                let subject: String = "Mac Jyutping Input Method Feedback"
                let scheme: String = "mailto:\(address)?subject=\(subject)&body=\(messageBody)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                return scheme
        }()
}

private struct LinkLabel: View {

        init(icon: String, title: LocalizedStringKey, link: String, message: String? = nil) {
                self.icon = icon
                self.title = title
                self.link = link
                let messageText: String = message ?? link
                self.message = messageText
                self.isLongMessage = messageText.count > 64
        }

        private let icon: String
        private let title: LocalizedStringKey
        private let link: String
        private let message: String
        private let isLongMessage: Bool

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
                        Text(verbatim: message)
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                                .font(isLongMessage ? Font.callout : Font.callout.monospaced())
                        Spacer()
                }
        }
}
