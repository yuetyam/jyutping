import SwiftUI

@available(iOS 14.0, *)
struct AboutView_iOS14: View {

        private let version: String = {
                let versionString: String = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? "_error"
                let buildString: String = (Bundle.main.infoDictionary?["CFBundleVersion"] as? String) ?? "_error"
                return versionString + " (" + buildString + ")"
        }()

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

        var body: some View {
                NavigationView {
                        List {
                                Section {
                                        EnhancedLabel("Version", icon: "info.circle", message: Text(verbatim: version))
                                                .contextMenu {
                                                        MenuCopyButton(version)
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
                                        LinkSafariView(url: URL(string: "https://ososo.io/jyutping/terms")!) {
                                                EnhancedLabel("Terms of Use", icon: "text.alignleft", symbol: .safari)
                                        }
                                        .contextMenu {
                                                URLCopyButton("https://ososo.io/jyutping/terms")
                                        }
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
                                                URLCopyButton("https://t.me/jyutping")
                                                Button {
                                                        UIPasteboard.general.string = "jyutping"
                                                } label: {
                                                        Label("Copy Username", systemImage: "doc.on.doc")
                                                }
                                        }
                                        Button {
                                                let appUrl: URL = URL(string: "https://www.truthsocial.com")!
                                                let webUrl: URL = URL(string: "https://www.truthsocial.com")!
                                                AppMaster.open(appUrl: appUrl, webUrl: webUrl)
                                        } label: {
                                                EnhancedLabel("TRUTH Social", icon: "at", symbol: Image(systemName: "arrow.up.right"))
                                        }
                                        .contextMenu {
                                                URLCopyButton("https://www.truthsocial.com")
                                                Button {
                                                        UIPasteboard.general.string = "username"
                                                } label: {
                                                        Label("Copy Username", systemImage: "doc.on.doc")
                                                }
                                        }
                                        Button {
                                                // Instagram App doesn't support Universal Links
                                                let appUrl: URL = URL(string: "instagram://user?username=jyutping_app")!
                                                let webUrl: URL = URL(string: "https://www.instagram.com/jyutping_app")!
                                                AppMaster.open(appUrl: appUrl, webUrl: webUrl)
                                        } label: {
                                                EnhancedLabel("Instagram", icon: "circle.square", symbol: Image(systemName: "arrow.up.right"))
                                        }
                                        .contextMenu {
                                                URLCopyButton("https://www.instagram.com/jyutping_app")
                                                Button {
                                                        UIPasteboard.general.string = "jyutping_app"
                                                } label: {
                                                        Label("Copy Username", systemImage: "doc.on.doc")
                                                }
                                        }
                                }
                                Section {
                                        // GitHub App supports Universal Links
                                        Link(destination: URL(string: "https://github.com/yuetyam/jyutping/issues")!) {
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
                                                                Label("Copy Email Address", systemImage: "doc.on.doc")
                                                        }
                                                }
                                }
                                Section {
                                        Link(destination: URL(string: "itms-apps://apple.com/app/id1509367629")!) {
                                                EnhancedLabel("Review on the App Store", icon: "heart", symbol: Image(systemName: "arrow.up.right"))
                                        }
                                        .contextMenu {
                                                Button {
                                                        UIPasteboard.general.string = "https://apps.apple.com/app/id1509367629"
                                                } label: {
                                                        Label("Copy App Store link", systemImage: "doc.on.doc")
                                                }
                                        }
                                        ShareSheetView(activityItems: [URL(string: "https://apps.apple.com/app/id1509367629")!]) {
                                                EnhancedLabel("Share this App", icon: "square.and.arrow.up")
                                        }
                                        .contextMenu {
                                                Button {
                                                        UIPasteboard.general.string = "https://apps.apple.com/app/id1509367629"
                                                } label: {
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
