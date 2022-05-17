import SwiftUI

struct AboutView: View {

        private let websiteIconName: String = {
                if #available(iOS 15.0, *) {
                        return "globe.asia.australia"
                } else {
                        return "house"
                }
        }()
        private let sourceCodeIconName: String = {
                if #available(iOS 15.0, *) {
                        return "chevron.left.forwardslash.chevron.right"
                } else {
                        return "chevron.left.slash.chevron.right"
                }
        }()
        private let githubIssuesIconName: String = {
                if #available(iOS 15.0, *) {
                        return "smallcircle.filled.circle"
                } else {
                        return "smallcircle.fill.circle"
                }
        }()

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
                                        LinkSafariView(url: URL(string: "https://ososo.io")!) {
                                                EnhancedLabel("Website", icon: websiteIconName, symbol: .safari)
                                        }
                                        .contextMenu {
                                                URLCopyButton("https://ososo.io")
                                        }
                                        LinkSafariView(url: URL(string: "https://github.com/yuetyam/jyutping")!) {
                                                EnhancedLabel("Source Code", icon: sourceCodeIconName, symbol: .safari)
                                        }
                                        .contextMenu {
                                                URLCopyButton("https://github.com/yuetyam/jyutping")
                                        }
                                        LinkSafariView(url: URL(string: "https://ososo.io/jyutping/privacy")!) {
                                                EnhancedLabel("Privacy Policy", icon: "lock.circle", symbol: .safari)
                                        }
                                        .contextMenu {
                                                URLCopyButton("https://ososo.io/jyutping/privacy")
                                        }
                                }
                                Section {
                                        Button {
                                                let appUrl: URL = URL(string: "tg://resolve?domain=jyutping")!
                                                let webUrl: URL = URL(string: "https://t.me/jyutping")!
                                                AppMaster.open(appUrl: appUrl, webUrl: webUrl)
                                        } label: {
                                                EnhancedLabel("Telegram Group", icon: "paperplane", symbol: .arrowUpForward)
                                        }
                                        .contextMenu {
                                                UsernameCopyButton("jyutping")
                                                URLCopyButton("https://t.me/jyutping")
                                        }
                                        Button {
                                                let scheme: String = #"mqqapi://card/show_pslcard?src_type=internal&version=1&card_type=group&uin=293148593"#
                                                let address: String = #"https://jq.qq.com/?k=4PR17m3t"#
                                                let appUrl: URL = URL(string: scheme)!
                                                let webUrl: URL = URL(string: address)!
                                                AppMaster.open(appUrl: appUrl, webUrl: webUrl)
                                        } label: {
                                                EnhancedLabel("QQ Group", icon: "person.2", symbol: .arrowUpForward)
                                        }
                                        .contextMenu {
                                                MenuCopyButton("293148593", title: "Copy QQ Group ID")
                                        }
                                }
                                Section {
                                        Button {
                                                let appUrl: URL = URL(string: "https://truthsocial.com/@Cantonese")!
                                                let webUrl: URL = URL(string: "https://truthsocial.com/@Cantonese")!
                                                AppMaster.open(appUrl: appUrl, webUrl: webUrl)
                                        } label: {
                                                EnhancedLabel("TRUTH Social", icon: "t.square", symbol: .arrowUpForward)
                                        }
                                        .contextMenu {
                                                UsernameCopyButton("Cantonese")
                                                URLCopyButton("https://truthsocial.com/@Cantonese")
                                        }

                                        // Twitter App supports Universal Links
                                        Link(destination: URL(string: "https://twitter.com/JyutpingApp")!) {
                                                EnhancedLabel("Twitter", icon: "at", symbol: .arrowUpForward)
                                        }
                                        .contextMenu {
                                                UsernameCopyButton("JyutpingApp")
                                                URLCopyButton("https://twitter.com/JyutpingApp")
                                        }

                                        Button {
                                                let appUrl: URL = URL(string: "instagram://user?username=jyutping_app")!
                                                let webUrl: URL = URL(string: "https://www.instagram.com/jyutping_app")!
                                                AppMaster.open(appUrl: appUrl, webUrl: webUrl)
                                        } label: {
                                                EnhancedLabel("Instagram", icon: "circle.square", symbol: .arrowUpForward)
                                        }
                                        .contextMenu {
                                                UsernameCopyButton("jyutping_app")
                                                URLCopyButton("https://www.instagram.com/jyutping_app")
                                        }
                                }
                                Section {
                                        // GitHub App supports Universal Links
                                        Link(destination: URL(string: "https://github.com/yuetyam/jyutping/issues")!) {
                                                EnhancedLabel("GitHub Issues", icon: githubIssuesIconName, symbol: .arrowUpForward)
                                        }
                                        .contextMenu {
                                                URLCopyButton("https://github.com/yuetyam/jyutping/issues")
                                        }
                                        EmailFeedbackButton()
                                                .contextMenu {
                                                        MenuCopyButton("bing@ososo.io", title: "Copy Email Address")
                                                }
                                }
                                Section {
                                        Link(destination: URL(string: "itms-apps://apple.com/app/id1509367629")!) {
                                                EnhancedLabel("Review on the App Store", icon: "heart", symbol: .arrowUpForward)
                                        }
                                        .contextMenu {
                                                MenuCopyButton("https://apps.apple.com/app/id1509367629", title: "Copy App Store link")
                                        }
                                        ShareSheetView(activityItems: [URL(string: "https://apps.apple.com/app/id1509367629")!]) {
                                                EnhancedLabel("Share this App", icon: "square.and.arrow.up")
                                        }
                                        .contextMenu {
                                                MenuCopyButton("https://apps.apple.com/app/id1509367629", title: "Copy App Store link")
                                        }
                                }

                                if #available(iOS 15.0, *) {
                                        Section {
                                                NavigationLink(destination: DonationView()) {
                                                        Label {
                                                                Text("label.support_author").foregroundColor(.primary)
                                                        } icon: {
                                                                Image(systemName: "heart").symbolRenderingMode(.multicolor)
                                                        }
                                                }
                                        }
                                }
                        }
                        .listStyle(.insetGrouped)
                        .navigationTitle("About")
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
                                    buttons: [.cancel(Text("OK"))])
                }
                .alert(isPresented: $isMailOnPadUnavailable) {
                        Alert(title: Text("Unable to compose mail"),
                              message: Text("Mail Unavailable"),
                              dismissButton: .cancel(Text("OK")))
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
                let address: String = "bing@ososo.io"
                let subject: String = "Jyutping Feedback"
                let scheme: String = "mailto:\(address)?subject=\(subject)&body=\(messageBody)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                return URL(string: scheme)!
        }()
}
