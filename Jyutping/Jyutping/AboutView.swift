import SwiftUI

@available(iOS 15.0, *)
struct AboutView_iOS15: View {

        private let versionString: String = {
                let version: String = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? "_error"
                let build: String = (Bundle.main.infoDictionary?["CFBundleVersion"] as? String) ?? "_error"
                return version + " (" + build + ")"
        }()

        var body: some View {
                NavigationView {
                        List {
                                Section {
                                        EnhancedLabel("Version", icon: "info.circle", message: Text(verbatim: versionString))
                                                .contextMenu {
                                                        MenuCopyButton(content: versionString)
                                                }
                                }
                                Section {
                                        LinkSafariView(url: URL(string: "https://github.com/yuetyam/jyutping")!) {
                                                EnhancedLabel("Source Code", icon: "number.circle", symbol: Image(systemName: "safari"))
                                        }
                                        .contextMenu {
                                                Button(action: {
                                                        UIPasteboard.general.string = "https://github.com/yuetyam/jyutping"
                                                }) {
                                                        Label("Copy Source Code URL", systemImage: "doc.on.doc")
                                                }
                                        }
                                        NavigationLink(destination: AcknowledgementsView()) {
                                                Label("Acknowledgements", systemImage: "wand.and.stars")
                                        }
                                        LinkSafariView(url: URL(string: "https://yuetyam.github.io/jyutping/privacy")!) {
                                                EnhancedLabel("Privacy Policy", icon: "lock.circle", symbol: Image(systemName: "safari"))
                                        }
                                        .contextMenu {
                                                Button(action: {
                                                        UIPasteboard.general.string = "https://yuetyam.github.io/jyutping/privacy"
                                                }) {
                                                        Label("Copy Privacy Policy URL", systemImage: "doc.on.doc")
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
                                                        Label("Copy Telegram URL", systemImage: "doc.on.doc")
                                                }
                                        }
                                        Link(destination: URL(string: "https://twitter.com/JyutpingApp")!) {
                                                EnhancedLabel("Follow us on Twitter", icon: "at", symbol: Image(systemName: "arrow.up.right"))
                                        }
                                        .contextMenu {
                                                Button(action: {
                                                        UIPasteboard.general.string = "https://twitter.com/JyutpingApp"
                                                }) {
                                                        Label("Copy Twitter URL", systemImage: "doc.on.doc")
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
                                                EnhancedLabel("Follow us on Instagram", icon: "circle.square", symbol: Image(systemName: "arrow.up.right"))
                                        }
                                        .contextMenu {
                                                Button(action: {
                                                        UIPasteboard.general.string = "https://www.instagram.com/jyutping_app"
                                                }) {
                                                        Label("Copy Instagram URL", systemImage: "doc.on.doc")
                                                }
                                        }
                                }
                                Section {
                                        // GitHub App supports Universal Links
                                        Link(destination: URL(string: "https://github.com/yuetyam/jyutping/issues")!) {
                                                EnhancedLabel("GitHub Issues", icon: "info.circle", symbol: Image(systemName: "arrow.up.right"))
                                        }
                                        .contextMenu {
                                                Button(action: {
                                                        UIPasteboard.general.string = "https://github.com/yuetyam/jyutping"
                                                }) {
                                                        Label("Copy GitHub URL", systemImage: "doc.on.doc")
                                                }
                                        }
                                        EmailFeedbackButton()
                                                .contextMenu {
                                                        Button(action: {
                                                                UIPasteboard.general.string = "bing@ososo.io"
                                                        }) {
                                                                Label("Copy Email Address", systemImage: "doc.on.doc")
                                                        }
                                                }
                                }
                                Section {
                                        Link(destination: URL(string: "itms-apps://apple.com/app/id1509367629")!) {
                                                EnhancedLabel("Review on the App Store", icon: "heart", symbol: Image(systemName: "arrow.up.right"))
                                        }
                                        .contextMenu {
                                                Button(action: {
                                                        UIPasteboard.general.string = "https://apps.apple.com/app/id1509367629"
                                                }) {
                                                        Label("Copy App Store link", systemImage: "doc.on.doc")
                                                }
                                        }
                                        ShareSheetView_iOS15(activityItems: [URL(string: "https://apps.apple.com/app/id1509367629")!]) {
                                                EnhancedLabel("Share this App", icon: "square.and.arrow.up")
                                        }
                                        .contextMenu {
                                                Button(action: {
                                                        UIPasteboard.general.string = "https://apps.apple.com/app/id1509367629"
                                                }) {
                                                        Label("Copy App Store link", systemImage: "doc.on.doc")
                                                }
                                        }
                                }
                        }
                        .navigationTitle("About")
                }
                .navigationViewStyle(.stack)
        }
}


private let version: String = {
        let versionString: String = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? "_error"
        let buildString: String = (Bundle.main.infoDictionary?["CFBundleVersion"] as? String) ?? "_error"
        return versionString + " (" + buildString + ")"
}()

struct AboutView: View {
        var body: some View {
                NavigationView {
                        ZStack {
                                if #available(iOS 14.0, *) {
                                        GlobalBackgroundColor().ignoresSafeArea()
                                } else {
                                        GlobalBackgroundColor().edgesIgnoringSafeArea(.all)
                                }
                                ScrollView {

                                        // MARK: - Version

                                        MessageView(icon: "info.circle", text: Text("Version"), message: Text(version))
                                                .padding(.vertical)
                                                .fillBackground()
                                                .contextMenu {
                                                        MenuCopyButton(content: version)
                                                }
                                                .padding()


                                        // MARK: - Source Code & Privacy

                                        VStack {
                                                LinkButton(url: URL(string: "https://github.com/yuetyam/jyutping")!,
                                                           content: MessageView(icon: "number.circle", text: Text("Source Code"), symbol: Image(systemName: "safari")))
                                                        .padding(.top)
                                                Divider()
                                                NavigationLink(destination: AcknowledgementsView()) {
                                                        MessageView(icon: "wand.and.stars",
                                                                    text: Text("Acknowledgements"),
                                                                    symbol: Image(systemName: "chevron.right"))
                                                }
                                                Divider()
                                                LinkButton(url: URL(string: "https://yuetyam.github.io/jyutping/privacy")!,
                                                           content: MessageView(icon: "lock.circle", text: Text("Privacy Policy"), symbol: Image(systemName: "safari")))
                                                        .padding(.bottom)
                                        }
                                        .fillBackground()
                                        .contextMenu {
                                                Button(action: {
                                                        UIPasteboard.general.string = "https://github.com/yuetyam/jyutping"
                                                }) {
                                                        MenuLabel(text: "Copy Source Code URL", image: "doc.on.doc")
                                                }
                                                Button(action: {
                                                        UIPasteboard.general.string = "https://yuetyam.github.io/jyutping/privacy"
                                                }) {
                                                        MenuLabel(text: "Copy Privacy Policy URL", image: "doc.on.doc")
                                                }
                                        }
                                        .padding()


                                        // MARK: - Contact & Feedback

                                        VStack {
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
                                                        MessageView(icon: "paperplane", text: Text("Join Telegram Group"), symbol: Image(systemName: "arrow.up.right"))
                                                }
                                                .padding(.top)
                                                Divider()
                                                Button(action: {
                                                        // Twitter App supports Universal Links
                                                        let url: URL = URL(string: "https://twitter.com/JyutpingApp")!
                                                        UIApplication.shared.open(url)
                                                }) {
                                                        MessageView(icon: "at", text: Text("Follow us on Twitter"), symbol: Image(systemName: "arrow.up.right"))
                                                }
                                                Divider()
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
                                                        let icon: String = {
                                                                if #available(iOS 14, *) {
                                                                        return "circle.square"
                                                                } else {
                                                                        return "dot.square"
                                                                }
                                                        }()
                                                        MessageView(icon: icon, text: Text("Follow us on Instagram"), symbol: Image(systemName: "arrow.up.right"))
                                                }
                                                .padding(.bottom)
                                        }
                                        .fillBackground()
                                        .contextMenu {
                                                Button(action: {
                                                        UIPasteboard.general.string = "https://t.me/jyutping"
                                                }) {
                                                        MenuLabel(text: "Copy Telegram URL", image: "doc.on.doc")
                                                }
                                                Button(action: {
                                                        UIPasteboard.general.string = "https://twitter.com/JyutpingApp"
                                                }) {
                                                        MenuLabel(text: "Copy Twitter URL", image: "doc.on.doc")
                                                }
                                                Button(action: {
                                                        UIPasteboard.general.string = "https://www.instagram.com/jyutping_app"
                                                }) {
                                                        MenuLabel(text: "Copy Instagram URL", image: "doc.on.doc")
                                                }
                                        }
                                        .padding()

                                        VStack {
                                                Button(action: {
                                                        // GitHub App supports Universal Links
                                                        let url: URL = URL(string: "https://github.com/yuetyam/jyutping/issues")!
                                                        UIApplication.shared.open(url)
                                                }) {
                                                        MessageView(icon: "info.circle", text: Text("GitHub Issues"), symbol: Image(systemName: "arrow.up.right"))
                                                }.padding(.top)
                                                Divider()
                                                EmailFeedbackButton().padding(.bottom)
                                        }
                                        .fillBackground()
                                        .contextMenu {
                                                Button(action: {
                                                        UIPasteboard.general.string = "https://github.com/yuetyam/jyutping"
                                                }) {
                                                        MenuLabel(text: "Copy GitHub URL", image: "doc.on.doc")
                                                }
                                                Button(action: {
                                                        UIPasteboard.general.string = "bing@ososo.io"
                                                }) {
                                                        MenuLabel(text: "Copy Email Address", image: "doc.on.doc")
                                                }
                                        }
                                        .padding()


                                        // MARK: - Review & Share

                                        VStack {
                                                Button(action: {
                                                        let appStoreUrl: URL = URL(string: "itms-apps://apple.com/app/id1509367629")!
                                                        UIApplication.shared.open(appStoreUrl)
                                                }) {
                                                        MessageView(icon: "heart", text: Text("Review on the App Store"), symbol: Image(systemName: "arrow.up.right"))
                                                }.padding(.top)
                                                Divider()
                                                ShareSheetView(content: MessageView(icon: "square.and.arrow.up", text: Text("Share this App")),
                                                               activityItems: [URL(string: "https://apps.apple.com/app/id1509367629")!])
                                                        .padding(.bottom)
                                        }
                                        .fillBackground()
                                        .contextMenu {
                                                Button(action: {
                                                        UIPasteboard.general.string = "https://apps.apple.com/app/id1509367629"
                                                }) {
                                                        MenuLabel(text: "Copy App Store link", image: "doc.on.doc")
                                                }
                                        }
                                        .padding()
                                        .padding(.bottom, 100)
                                }
                                .foregroundColor(.primary)
                                .navigationBarTitle(Text("About"))
                        }
                }
                .navigationViewStyle(StackNavigationViewStyle())
        }
}

struct AboutView_Previews: PreviewProvider {
        static var previews: some View {
                AboutView()
        }
}


private struct EmailFeedbackButton: View {

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
                        if #available(iOS 15.0, *) {
                                EnhancedLabel("Email Feedback", icon: "envelope", symbol: Image(systemName: "square.and.pencil"))
                        } else {
                                MessageView(icon: "envelope", text: Text("Email Feedback"), symbol: Image(systemName: "square.and.pencil"))
                        }
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
                let device: String = UIDevice.modelName
                let system: String = UIDevice.current.systemName + " " + UIDevice.current.systemVersion
                let messageBody: String = """


                Version: \(version)
                Device: \(device)
                System: \(system)
                """
                let address: String = "bing@ososo.io"
                let subject: String = "Jyutping User Feedback"
                let scheme: String = "mailto:\(address)?subject=\(subject)&body=\(messageBody)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                return URL(string: scheme)!
        }()
}
