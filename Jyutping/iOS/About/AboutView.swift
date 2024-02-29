#if os(iOS)

import SwiftUI
import AboutKit

struct AboutView: View {
        var body: some View {
                NavigationView {
                        List {
                                Section {
                                        EnhancedLabel("Shared.About.Version", icon: "info.circle", message: Text(verbatim: AppMaster.version))
                                                .contextMenu {
                                                        MenuCopyButton(AppMaster.version)
                                                }
                                }
                                Section {
                                        SafariLink(About.WebsiteAddress) {
                                                EnhancedLabel("Shared.About.Website", icon: "globe.asia.australia", symbol: .safari)
                                        }
                                        SafariLink(About.Jyutping4MacAddress) {
                                                EnhancedLabel("IOSAboutTab.LabelTitle.JyutpingForMac", icon: "command.square", symbol: .safari)
                                        }
                                        SafariLink(About.SourceCodeAddress) {
                                                EnhancedLabel("Shared.About.SourceCode", icon: "chevron.left.forwardslash.chevron.right", symbol: .safari)
                                        }
                                        SafariLink(About.PrivacyPolicyAddress) {
                                                EnhancedLabel("Shared.About.PrivacyPolicy", icon: "lock.circle", symbol: .safari)
                                        }
                                        SafariLink(About.FAQAddress) {
                                                EnhancedLabel("Shared.About.FAQ", icon: "questionmark.circle", symbol: .safari)
                                        }
                                }
                                Section {
                                        Button {
                                                let appUrl: URL = URL(string: About.TelegramAppScheme)!
                                                let webUrl: URL = URL(string: About.TelegramAddress)!
                                                AppMaster.open(appUrl: appUrl, webUrl: webUrl)
                                        } label: {
                                                EnhancedLabel("Shared.About.Telegram", icon: "paperplane", symbol: .arrowUpForward)
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
                                                EnhancedLabel("Shared.About.QQ", icon: "person.2", symbol: .arrowUpForward)
                                        }
                                        .contextMenu {
                                                MenuCopyButton(About.QQGroupID, title: "IOSAboutTab.ContextMenu.CopyQQGroupID")
                                        }

                                        // Twitter App supports Universal Links
                                        Link(destination: URL(string: About.TwitterAddress)!) {
                                                EnhancedLabel("Shared.About.Twitter", icon: "at", symbol: .arrowUpForward)
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
                                                EnhancedLabel("Shared.About.Instagram", icon: "circle.square", symbol: .arrowUpForward)
                                        }
                                        .contextMenu {
                                                UsernameCopyButton(About.InstagramUsername)
                                                URLCopyButton(About.InstagramAddress)
                                        }
                                }
                                Section {
                                        Link(destination: URL(string: About.GoogleFormsAddress)!) {
                                                EnhancedLabel("Shared.About.GoogleForms", icon: "checkmark.message", symbol: .safari)
                                        }
                                        .contextMenu {
                                                URLCopyButton(About.GoogleFormsAddress)
                                        }
                                        Link(destination: URL(string: About.TencentSurveyAddress)!) {
                                                EnhancedLabel("Shared.About.TencentSurvey", icon: "checkmark.message", symbol: .safari)
                                        }
                                        .contextMenu {
                                                URLCopyButton(About.TencentSurveyAddress)
                                        }

                                        EmailFeedbackButton()
                                                .contextMenu {
                                                        MenuCopyButton(About.EmailAddress, title: "IOSAboutTab.ContextMenu.CopyEmailAddress")
                                                }
                                }
                                Section {
                                        Link(destination: URL(string: About.AppStoreAppScheme)!) {
                                                EnhancedLabel("IOSAboutTab.LabelTitle.ReviewOnTheAppStore", icon: "heart", symbol: .arrowUpForward)
                                        }
                                        .contextMenu {
                                                MenuCopyButton(About.AppStoreAddress, title: "IOSAboutTab.ContextMenu.CopyAppStoreLink")
                                        }
                                        if #available(iOS 16.0, *) {
                                                ShareLink(item: About.AppStoreWebURL) {
                                                        EnhancedLabel("IOSAboutTab.LabelTitle.ShareThisApp", icon: "square.and.arrow.up")
                                                }
                                                .contextMenu {
                                                        MenuCopyButton(About.AppStoreAddress, title: "IOSAboutTab.ContextMenu.CopyAppStoreLink")
                                                }
                                        } else {
                                                ShareSheetView(activityItems: [About.AppStoreWebURL]) {
                                                        EnhancedLabel("IOSAboutTab.LabelTitle.ShareThisApp", icon: "square.and.arrow.up")
                                                }
                                                .contextMenu {
                                                        MenuCopyButton(About.AppStoreAddress, title: "IOSAboutTab.ContextMenu.CopyAppStoreLink")
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
                        EnhancedLabel("Shared.About.Email", icon: "envelope", symbol: Image(systemName: "square.and.pencil"))
                }
                .actionSheet(isPresented: $isMailOnPhoneUnavailable) {
                        ActionSheet(title: Text("IOSAboutTab.Email.UnableToComposeMail"),
                                    message: Text("IOSAboutTab.Email.MailUnavailable"),
                                    buttons: [.cancel(Text("General.OK"))])
                }
                .alert(isPresented: $isMailOnPadUnavailable) {
                        Alert(title: Text("IOSAboutTab.Email.UnableToComposeMail"),
                              message: Text("IOSAboutTab.Email.MailUnavailable"),
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
