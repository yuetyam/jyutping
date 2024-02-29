#if os(macOS)

import SwiftUI
import AboutKit

struct MacAboutView: View {
        var body: some View {
                ScrollView {
                        LazyVStack(spacing: 16) {
                                HStack(spacing: 16) {
                                        Image.info
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 16, height: 16)
                                                .foregroundStyle(Color.accentColor)
                                        Text("Shared.About.Version").font(.master)
                                        Text(verbatim: AppMaster.version)
                                        Spacer()
                                }
                                .block()
                                VStack {
                                        LinkLabel(icon: "globe.asia.australia", title: "Shared.About.Website", link: About.WebsiteAddress)
                                        LinkLabel(icon: "chevron.left.forwardslash.chevron.right", title: "Shared.About.SourceCode", link: About.SourceCodeAddress)
                                        LinkLabel(icon: "lock.circle", title: "Shared.About.PrivacyPolicy", link: About.PrivacyPolicyAddress)
                                        LinkLabel(icon: "questionmark.circle", title: "Shared.About.FAQ", link: About.FAQAddress)
                                }
                                .block()
                                VStack {
                                        LinkLabel(icon: "paperplane", title: "Shared.About.Telegram", link: About.TelegramAddress)
                                        LinkLabel(icon: "person.2", title: "Shared.About.QQ", link: About.QQAddress, message: About.QQGroupID)
                                        LinkLabel(icon: "at", title: "Shared.About.Twitter", link: About.TwitterAddress)
                                        LinkLabel(icon: "circle.square", title: "Shared.About.Instagram", link: About.InstagramAddress)
                                }
                                .block()
                                VStack {
                                        LinkLabel(icon: "checkmark.message", title: "Shared.About.GoogleForms", link: About.GoogleFormsAddress)
                                        LinkLabel(icon: "checkmark.message", title: "Shared.About.TencentSurvey", link: About.TencentSurveyAddress)
                                        LinkLabel(icon: "envelope", title: "Shared.About.Email", link: mailtoScheme, message: About.EmailAddress)
                                }
                                .block()
                        }
                        .textSelection(.enabled)
                        .padding()
                }
                .navigationTitle("MacSidebar.NavigationTitle.About")
        }

        private let mailtoScheme: String = {
                let osVersion = ProcessInfo.processInfo.operatingSystemVersion
                let system: String = "macOS \(osVersion.majorVersion).\(osVersion.minorVersion).\(osVersion.patchVersion)"
                let messageBody: String = """


                Version: \(AppMaster.version)
                System: \(system)
                """
                let address: String = About.EmailAddress
                let subject: String = "Mac Jyutping App Feedback"
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
                                        Text(title).font(.master)
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

#endif
