#if os(iOS)

import SwiftUI
import AboutKit

struct AboutView: View {
        var body: some View {
                NavigationView {
                        List {
                                Section {
                                        EnhancedLabel("Version", icon: "info.circle", message: Text(verbatim: AppMaster.version))
                                                .contextMenu {
                                                        MenuCopyButton(AppMaster.version)
                                                }
                                }
                                Section {
                                        SafariLink(About.WebsiteAddress) {
                                                EnhancedLabel("Website", icon: "globe.asia.australia", symbol: .safari)
                                        }
                                        SafariLink(About.Jyutping4MacAddress) {
                                                EnhancedLabel("Jyutping for macOS", icon: "command.square", symbol: .safari)
                                        }
                                        SafariLink(About.SourceCodeAddress) {
                                                EnhancedLabel("Source Code", icon: "chevron.left.forwardslash.chevron.right", symbol: .safari)
                                        }
                                        SafariLink(About.PrivacyPolicyAddress) {
                                                EnhancedLabel("Privacy Policy", icon: "lock.circle", symbol: .safari)
                                        }
                                        SafariLink(About.FAQAddress) {
                                                EnhancedLabel("FAQ", icon: "questionmark.circle", symbol: .safari)
                                        }
                                }
                                Section {
                                        Button {
                                                let appUrl: URL = URL(string: About.TelegramAppScheme)!
                                                let webUrl: URL = URL(string: About.TelegramAddress)!
                                                AppMaster.open(appUrl: appUrl, webUrl: webUrl)
                                        } label: {
                                                EnhancedLabel("Telegram Group", icon: "paperplane", symbol: .arrowUpForward)
                                        }
                                        .contextMenu {
                                                UsernameCopyButton(About.TelegramUsername)
                                                URLCopyButton(About.TelegramAddress)
                                        }

                                        Button {
                                                let appUrl: URL = URL(string: About.QQAppScheme)!
                                                let webUrl: URL = URL(string: About.QQAddress)!
                                                AppMaster.open(appUrl: appUrl, webUrl: webUrl)
                                        } label: {
                                                EnhancedLabel("QQ Group", icon: "person.2", symbol: .arrowUpForward)
                                        }
                                        .contextMenu {
                                                MenuCopyButton(About.QQGroupID, title: "Copy QQ Group ID")
                                        }

                                        // Twitter App supports Universal Links
                                        Link(destination: URL(string: About.TwitterAddress)!) {
                                                EnhancedLabel("Twitter", icon: "at", symbol: .arrowUpForward)
                                        }
                                        .contextMenu {
                                                UsernameCopyButton(About.TwitterUsername)
                                                URLCopyButton(About.TwitterAddress)
                                        }

                                        Button {
                                                let appUrl: URL = URL(string: About.InstagramAppScheme)!
                                                let webUrl: URL = URL(string: About.InstagramAddress)!
                                                AppMaster.open(appUrl: appUrl, webUrl: webUrl)
                                        } label: {
                                                EnhancedLabel("Instagram", icon: "circle.square", symbol: .arrowUpForward)
                                        }
                                        .contextMenu {
                                                UsernameCopyButton(About.InstagramUsername)
                                                URLCopyButton(About.InstagramAddress)
                                        }
                                }
                                Section {
                                        Link(destination: URL(string: About.GoogleFormsAddress)!) {
                                                EnhancedLabel("Google Forms", icon: "checkmark.message", symbol: .safari)
                                        }
                                        .contextMenu {
                                                URLCopyButton(About.GoogleFormsAddress)
                                        }
                                        Link(destination: URL(string: About.TencentSurveyAddress)!) {
                                                EnhancedLabel("Tencent Survey", icon: "checkmark.message", symbol: .safari)
                                        }
                                        .contextMenu {
                                                URLCopyButton(About.TencentSurveyAddress)
                                        }

                                        EmailFeedbackButton()
                                                .contextMenu {
                                                        MenuCopyButton(About.EmailAddress, title: "Copy Email Address")
                                                }
                                }
                                Section {
                                        Link(destination: URL(string: About.AppStoreAppScheme)!) {
                                                EnhancedLabel("Review on the App Store", icon: "heart", symbol: .arrowUpForward)
                                        }
                                        .contextMenu {
                                                MenuCopyButton(About.AppStoreAddress, title: "Copy App Store link")
                                        }
                                        if #available(iOS 16.0, *) {
                                                ShareLink(item: About.AppStoreWebURL) {
                                                        EnhancedLabel("Share this App", icon: "square.and.arrow.up")
                                                }
                                                .contextMenu {
                                                        MenuCopyButton(About.AppStoreAddress, title: "Copy App Store link")
                                                }
                                        } else {
                                                ShareSheetView(activityItems: [About.AppStoreWebURL]) {
                                                        EnhancedLabel("Share this App", icon: "square.and.arrow.up")
                                                }
                                                .contextMenu {
                                                        MenuCopyButton(About.AppStoreAddress, title: "Copy App Store link")
                                                }
                                        }
                                }
                        }
                        .navigationTitle("IOSTabView.NavigationTitle.About")
                }
                .navigationViewStyle(.stack)
        }
}


private struct EmailFeedbackButton: View {

        @State private var isMailOnPhoneUnavailable: Bool = false
        @State private var isMailOnPadUnavailable: Bool = false

        var body: some View {
                Button {
                        UIApplication.shared.open(mailtoUrl) { success in
                                if !success {
                                        if Device.isPhone {
                                                UINotificationFeedbackGenerator().notificationOccurred(.warning)
                                                isMailOnPhoneUnavailable = true
                                        } else {
                                                isMailOnPadUnavailable = true
                                        }
                                }
                        }
                } label: {
                        EnhancedLabel("Email Feedback", icon: "envelope", symbol: Image(systemName: "square.and.pencil"))
                }
                .actionSheet(isPresented: $isMailOnPhoneUnavailable) {
                        ActionSheet(title: Text("Unable to compose mail"),
                                    message: Text("Mail Unavailable"),
                                    buttons: [.cancel(Text("General.OK"))])
                }
                .alert(isPresented: $isMailOnPadUnavailable) {
                        Alert(title: Text("Unable to compose mail"),
                              message: Text("Mail Unavailable"),
                              dismissButton: .cancel(Text("General.OK")))
                }
        }

        private let mailtoUrl: URL = {
                let version: String = AppMaster.version
                let device: String = Device.modelName
                let system: String = Device.system
                let messageBody: String = """


                Version: \(version)
                Device: \(device)
                System: \(system)
                """
                let address: String = About.EmailAddress
                let subject: String = "Jyutping Feedback"
                let scheme: String = "mailto:\(address)?subject=\(subject)&body=\(messageBody)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                return URL(string: scheme)!
        }()
}

#endif