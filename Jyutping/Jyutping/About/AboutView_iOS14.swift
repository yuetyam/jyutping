import SwiftUI

@available(iOS 14.0, *)
struct AboutView_iOS14: View {

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
                                        EnhancedLabel("Version", icon: "info.circle", message: Text(verbatim: AppMaster.version))
                                                .contextMenu {
                                                        MenuCopyButton(AppMaster.version)
                                                }
                                }
                                Section {
                                        LinkSafariView(url: URL(string: "https://yuetyam.github.io/jyutping")!) {
                                                EnhancedLabel("Website", icon: websiteIconName, symbol: .safari)
                                        }
                                        .contextMenu {
                                                URLCopyButton("https://yuetyam.github.io/jyutping")
                                        }
                                        LinkSafariView(url: URL(string: "https://github.com/yuetyam/jyutping")!) {
                                                EnhancedLabel("Source Code", icon: sourceCodeIconName, symbol: .safari)
                                        }
                                        .contextMenu {
                                                URLCopyButton("https://github.com/yuetyam/jyutping")
                                        }
                                        LinkSafariView(url: URL(string: "https://yuetyam.github.io/jyutping/privacy")!) {
                                                EnhancedLabel("Privacy Policy", icon: "lock.circle", symbol: .safari)
                                        }
                                        .contextMenu {
                                                URLCopyButton("https://yuetyam.github.io/jyutping/privacy")
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
