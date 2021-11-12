import SwiftUI

struct AboutView: View {

        private let versionString: String = {
                let version: String = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? "_error"
                let build: String = (Bundle.main.infoDictionary?["CFBundleVersion"] as? String) ?? "_error"
                return version + " (" + build + ")"
        }()

        var body: some View {
                NavigationView {
                        List {
                                Section {
                                        HStack(spacing: 16) {
                                                Image(systemName: "info.circle").foregroundColor(.blue)
                                                Text("Version")
                                                Spacer()
                                                Text(verbatim: versionString)
                                        }
                                        .contextMenu {
                                                MenuCopyButton(versionString)
                                        }
                                }
                                Section {
                                        LinkSafariView(url: URL(string: "https://github.com/yuetyam/jyutping")!) {
                                                EnhancedLabel("Source Code", icon: "chevron.left.slash.chevron.right", symbol: Image(systemName: "safari"))
                                        }
                                        .contextMenu {
                                                Button(action: {
                                                        UIPasteboard.general.string = "https://github.com/yuetyam/jyutping"
                                                }) {
                                                        EnhancedLabel("Copy Source Code URL", icon: "doc.on.doc")
                                                }
                                        }
                                        LinkSafariView(url: URL(string: "https://yuetyam.github.io/jyutping/privacy")!) {
                                                EnhancedLabel("Privacy Policy", icon: "lock.circle", symbol: Image(systemName: "safari"))
                                        }
                                        .contextMenu {
                                                Button(action: {
                                                        UIPasteboard.general.string = "https://yuetyam.github.io/jyutping/privacy"
                                                }) {
                                                        EnhancedLabel("Copy Privacy Policy URL", icon: "doc.on.doc")
                                                }
                                        }
                                        NavigationLink(destination: AcknowledgementsView()) {
                                                HStack(spacing: 16) {
                                                        Image(systemName: "wand.and.stars").foregroundColor(.blue)
                                                        Text("Acknowledgements")
                                                        Spacer()
                                                }
                                        }
                                }
                                Section {
                                        Button(action: {
                                                // Telegram App doesn't support Universal Links
                                                let appUrl: URL = URL(string: "tg://resolve?domain=jyutping")!
                                                let webUrl: URL = URL(string: "https://t.me/jyutping")!
                                                UIApplication.shared.open(appUrl) { success in
                                                        if !success {
                                                                UIApplication.shared.open(webUrl)
                                                        }
                                                }
                                        }) {
                                                EnhancedLabel("Join Telegram Group", icon: "paperplane", symbol: Image(systemName: "arrow.up.right"), tintColor: .primary)
                                        }
                                        .contextMenu {
                                                Button(action: {
                                                        UIPasteboard.general.string = "https://t.me/jyutping"
                                                }) {
                                                        EnhancedLabel("Copy Telegram URL", icon: "doc.on.doc")
                                                }
                                        }
                                        Button(action: {
                                                UIApplication.shared.open(URL(string: "https://twitter.com/JyutpingApp")!)
                                        }) {
                                                EnhancedLabel("Follow us on Twitter", icon: "at", symbol: Image(systemName: "arrow.up.right"))
                                        }
                                        .contextMenu {
                                                Button(action: {
                                                        UIPasteboard.general.string = "https://twitter.com/JyutpingApp"
                                                }) {
                                                        EnhancedLabel("Copy Twitter URL", icon: "doc.on.doc")
                                                }
                                        }
                                        Button(action: {
                                                // Instagram App doesn't support Universal Links
                                                let appUrl: URL = URL(string: "instagram://user?username=jyutping_app")!
                                                let webUrl: URL = URL(string: "https://www.instagram.com/jyutping_app")!
                                                UIApplication.shared.open(appUrl) { success in
                                                        if !success {
                                                                UIApplication.shared.open(webUrl)
                                                        }
                                                }
                                        }) {
                                                EnhancedLabel("Follow us on Instagram", icon: "dot.square", symbol: Image(systemName: "arrow.up.right"))
                                        }
                                        .contextMenu {
                                                Button(action: {
                                                        UIPasteboard.general.string = "https://www.instagram.com/jyutping_app"
                                                }) {
                                                        EnhancedLabel("Copy Instagram URL", icon: "doc.on.doc")
                                                }
                                        }
                                }
                                Section {
                                        // GitHub App supports Universal Links
                                        Button(action: {
                                                UIApplication.shared.open(URL(string: "https://github.com/yuetyam/jyutping/issues")!)
                                        }) {
                                                EnhancedLabel("GitHub Issues", icon: "smallcircle.fill.circle", symbol: Image(systemName: "arrow.up.right"))
                                        }
                                        .contextMenu {
                                                Button(action: {
                                                        UIPasteboard.general.string = "https://github.com/yuetyam/jyutping"
                                                }) {
                                                        EnhancedLabel("Copy GitHub URL", icon: "doc.on.doc")
                                                }
                                        }
                                        EmailFeedbackButton()
                                                .contextMenu {
                                                        Button(action: {
                                                                UIPasteboard.general.string = "bing@ososo.io"
                                                        }) {
                                                                EnhancedLabel("Copy Email Address", icon: "doc.on.doc")
                                                        }
                                                }
                                }
                                Section {
                                        Button(action: {
                                                UIApplication.shared.open(URL(string: "itms-apps://apple.com/app/id1509367629")!)
                                        }) {
                                                EnhancedLabel("Review on the App Store", icon: "heart", symbol: Image(systemName: "arrow.up.right"))
                                        }
                                        .contextMenu {
                                                Button(action: {
                                                        UIPasteboard.general.string = "https://apps.apple.com/app/id1509367629"
                                                }) {
                                                        EnhancedLabel("Copy App Store link", icon: "doc.on.doc")
                                                }
                                        }
                                        ShareSheetView(activityItems: [URL(string: "https://apps.apple.com/app/id1509367629")!]) {
                                                EnhancedLabel("Share this App", icon: "square.and.arrow.up")
                                        }
                                        .contextMenu {
                                                Button(action: {
                                                        UIPasteboard.general.string = "https://apps.apple.com/app/id1509367629"
                                                }) {
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
                let versionString: String = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? "_error"
                let buildString: String = (Bundle.main.infoDictionary?["CFBundleVersion"] as? String) ?? "_error"
                let version: String = versionString + " (" + buildString + ")"

                let device: String = UIDevice.modelName
                let system: String = UIDevice.current.systemName + " " + UIDevice.current.systemVersion
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
