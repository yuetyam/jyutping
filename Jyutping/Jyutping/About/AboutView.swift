import SwiftUI

struct AboutView: View {
        var body: some View {
                NavigationView {
                        List {
                                Section {
                                        HStack(spacing: 16) {
                                                Image(systemName: "info.circle").foregroundColor(.blue)
                                                Text("Version")
                                                Spacer()
                                                Text(verbatim: AppMaster.version)
                                        }
                                        .contextMenu {
                                                MenuCopyButton(AppMaster.version)
                                        }
                                }
                                Section {
                                        /*
                                        LinkSafariView(url: URL(string: "https://ososo.io")!) {
                                                EnhancedLabel("Website", icon: "house", symbol: .safari)
                                        }
                                        .contextMenu {
                                                URLCopyButton("https://ososo.io")
                                        }
                                        */
                                        LinkSafariView(url: URL(string: "https://github.com/yuetyam/jyutping")!) {
                                                EnhancedLabel("Source Code", icon: "chevron.left.slash.chevron.right", symbol: .safari)
                                        }
                                        .contextMenu {
                                                URLCopyButton("https://github.com/yuetyam/jyutping")
                                        }
                                        /*
                                        LinkSafariView(url: URL(string: "https://ososo.io/jyutping/terms")!) {
                                                EnhancedLabel("Terms of Use", icon: "text.alignleft", symbol: .safari)
                                        }
                                        .contextMenu {
                                                URLCopyButton("https://ososo.io/jyutping/terms")
                                        }
                                        */
                                        LinkSafariView(url: URL(string: "https://ososo.io/jyutping/privacy-ios")!) {
                                                EnhancedLabel("Privacy Policy", icon: "lock.circle", symbol: .safari)
                                        }
                                        .contextMenu {
                                                URLCopyButton("https://ososo.io/jyutping/privacy-ios")
                                        }
                                }
                                Section {
                                        Button {
                                                // Telegram App doesn't support Universal Links
                                                let appUrl: URL = URL(string: "tg://resolve?domain=jyutping")!
                                                let webUrl: URL = URL(string: "https://t.me/jyutping")!
                                                AppMaster.open(appUrl: appUrl, webUrl: webUrl)
                                        } label: {
                                                EnhancedLabel("Telegram Group", icon: "paperplane", symbol: Image(systemName: "arrow.up.right"))
                                        }
                                        .contextMenu {
                                                UsernameCopyButton("jyutping")
                                                URLCopyButton("https://t.me/jyutping")
                                        }
                                        /*
                                        Button {
                                                let appUrl: URL = URL(string: "https://www.truthsocial.com")!
                                                let webUrl: URL = URL(string: "https://www.truthsocial.com")!
                                                AppMaster.open(appUrl: appUrl, webUrl: webUrl)
                                        } label: {
                                                EnhancedLabel("TRUTH Social", icon: "at", symbol: Image(systemName: "arrow.up.right"))
                                        }
                                        .contextMenu {
                                                UsernameCopyButton("username")
                                                URLCopyButton("https://www.truthsocial.com")
                                        }
                                        */
                                        Button {
                                                // Instagram App doesn't support Universal Links
                                                let appUrl: URL = URL(string: "instagram://user?username=jyutping_app")!
                                                let webUrl: URL = URL(string: "https://www.instagram.com/jyutping_app")!
                                                AppMaster.open(appUrl: appUrl, webUrl: webUrl)
                                        } label: {
                                                EnhancedLabel("Instagram", icon: "circle.square", symbol: Image(systemName: "arrow.up.right"))
                                        }
                                        .contextMenu {
                                                UsernameCopyButton("jyutping_app")
                                                URLCopyButton("https://www.instagram.com/jyutping_app")
                                        }
                                }
                                Section {
                                        // GitHub App supports Universal Links
                                        Button {
                                                UIApplication.shared.open(URL(string: "https://github.com/yuetyam/jyutping/issues")!)
                                        } label: {
                                                EnhancedLabel("GitHub Issues", icon: "smallcircle.fill.circle", symbol: Image(systemName: "arrow.up.right"))
                                        }
                                        .contextMenu {
                                                URLCopyButton("https://github.com/yuetyam/jyutping/issues")
                                        }
                                        EmailFeedbackButton()
                                                .contextMenu {
                                                        Button {
                                                                UIPasteboard.general.string = "bing@ososo.io"
                                                        } label: {
                                                                EnhancedLabel("Copy Email Address", icon: "doc.on.doc")
                                                        }
                                                }
                                }
                                Section {
                                        Button {
                                                UIApplication.shared.open(URL(string: "itms-apps://apple.com/app/id1509367629")!)
                                        } label: {
                                                EnhancedLabel("Review on the App Store", icon: "heart", symbol: Image(systemName: "arrow.up.right"))
                                        }
                                        .contextMenu {
                                                Button {
                                                        UIPasteboard.general.string = "https://apps.apple.com/app/id1509367629"
                                                } label: {
                                                        EnhancedLabel("Copy App Store link", icon: "doc.on.doc")
                                                }
                                        }
                                        ShareSheetView(activityItems: [URL(string: "https://apps.apple.com/app/id1509367629")!]) {
                                                EnhancedLabel("Share this App", icon: "square.and.arrow.up")
                                        }
                                        .contextMenu {
                                                Button {
                                                        UIPasteboard.general.string = "https://apps.apple.com/app/id1509367629"
                                                } label: {
                                                        EnhancedLabel("Copy App Store link", icon: "doc.on.doc")
                                                }
                                        }
                                }
                        }
                        .listStyle(.grouped)
                        .navigationBarTitle("About")
                }
                .navigationViewStyle(.stack)
        }
}

struct AboutView_Previews: PreviewProvider {
        static var previews: some View {
                AboutView()
        }
}


struct EmailFeedbackButton: View {

        @State private var isMailOnPhoneUnavailable: Bool = false
        @State private var isMailOnPadUnavailable: Bool = false

        var body: some View {
                Button(action: {
                        UIApplication.shared.open(mailtoUrl) { success in
                                if !success {
                                        if UITraitCollection.current.userInterfaceIdiom == .phone {
                                                isMailOnPhoneUnavailable = true
                                                UINotificationFeedbackGenerator().notificationOccurred(.warning)
                                        } else {
                                                isMailOnPadUnavailable = true
                                        }
                                }
                        }
                }) {
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
