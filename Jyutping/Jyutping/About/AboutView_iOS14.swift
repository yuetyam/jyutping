import SwiftUI

@available(iOS 14.0, *)
struct AboutView_iOS14: View {

        private let versionString: String = {
                let version: String = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? "_error"
                let build: String = (Bundle.main.infoDictionary?["CFBundleVersion"] as? String) ?? "_error"
                return version + " (" + build + ")"
        }()

        private let sourceCodeIconName: String = {
                if #available(iOS 15.0, *) {
                        return "chevron.left.forwardslash.chevron.right"
                } else {
                        return "chevron.left.slash.chevron.right"
                }
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
                                                EnhancedLabel("Source Code", icon: sourceCodeIconName, symbol: Image(systemName: "safari"))
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
                                                EnhancedLabel("GitHub Issues", icon: "smallcircle.fill.circle", symbol: Image(systemName: "arrow.up.right"))
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
                                        ShareSheetView(activityItems: [URL(string: "https://apps.apple.com/app/id1509367629")!]) {
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
                        .listStyle(.insetGrouped)
                        .navigationTitle("About")
                }
                .navigationViewStyle(.stack)
        }
}
