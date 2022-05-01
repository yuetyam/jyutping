import SwiftUI

@available(iOS 15.0, *)
struct AboutView_iOS15: View {

        @State private var isDonationViewPresented: Bool = false

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
                                                EnhancedLabel("Website", icon: "globe.asia.australia", symbol: .safari)
                                        }
                                        .contextMenu {
                                                URLCopyButton("https://ososo.io")
                                        }
                                        LinkSafariView(url: URL(string: "https://github.com/yuetyam/jyutping")!) {
                                                EnhancedLabel("Source Code", icon: "chevron.left.forwardslash.chevron.right", symbol: .safari)
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
                                                EnhancedLabel("GitHub Issues", icon: "smallcircle.filled.circle", symbol: .arrowUpForward)
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

                                Section {
                                        Button {
                                                isDonationViewPresented.toggle()
                                        } label: {
                                                Label {
                                                        Text("button.support.author").foregroundColor(.primary)
                                                } icon: {
                                                        Image(systemName: "heart").symbolRenderingMode(.multicolor)
                                                }
                                        }
                                        .sheet(isPresented: $isDonationViewPresented) {
                                                DonationView(isPresented: $isDonationViewPresented)
                                        }
                                }
                        }
                        .navigationTitle("About")
                }
                .navigationViewStyle(.stack)
        }
}


@available(iOS 15.0, *)
struct DonationView: View {

        @Binding var isPresented: Bool

        var body: some View {
                NavigationView {
                        List {
                                Section {
                                        Button {
                                                print("IAP")
                                        } label: {
                                                HStack {
                                                        Spacer()
                                                        Text("Support Author")
                                                        Text(verbatim: "$0.99")
                                                        Spacer()
                                                }
                                        }
                                }
                                Section {
                                        Button {
                                                print("IAP")
                                        } label: {
                                                HStack {
                                                        Spacer()
                                                        Text("Support Author Plus")
                                                        Text(verbatim: "$1.99")
                                                        Spacer()
                                                }
                                        }
                                }
                                Section {
                                        Button {
                                                print("IAP")
                                        } label: {
                                                HStack {
                                                        Spacer()
                                                        Text("Support Author Max")
                                                        Text(verbatim: "$5.99")
                                                        Spacer()
                                                }
                                        }
                                }
                        }
                        .navigationTitle("Thank You")
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                                ToolbarItem(placement: .cancellationAction) {
                                        Button("Cancel") {
                                                isPresented = false
                                        }
                                }
                        }
                }
        }
}
