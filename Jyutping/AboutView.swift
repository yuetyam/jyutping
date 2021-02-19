import SwiftUI
import MessageUI

struct AboutView: View {
        
        private let mailComposeDelegate: MailComposeDelegate = MailComposeDelegate()
        
        var body: some View {
                NavigationView {
                        ZStack {
                                GlobalBackgroundColor().edgesIgnoringSafeArea(.all)
                                ScrollView {
                                        
                                        // MARK: - Version
                                        
                                        VersionLabel()
                                                .fillBackground()
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
                                                
                                                LinkButton(url: URL(string: "https://yuetyam.github.io/jyutping/privacy/privacy-policy-ios")!,
                                                           content: MessageView(icon: "lock.circle", text: Text("Privacy Policy"), symbol: Image(systemName: "safari")))
                                                        .padding(.bottom)
                                        }
                                        .fillBackground()
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
                                                }.padding(.top)
                                                Divider()
                                                
                                                Button(action: {
                                                        // GitHub App supports Universal Links
                                                        let githubUrl: URL = URL(string: "https://github.com/yuetyam/jyutping/issues")!
                                                        UIApplication.shared.open(githubUrl)
                                                }) {
                                                        MessageView(icon: "info.circle", text: Text("GitHub Issues"), symbol: Image(systemName: "arrow.up.right"))
                                                }
                                                Divider()
                                                
                                                MailFeedbackButton(mailComposeDelegate: mailComposeDelegate)
                                                        .padding(.bottom)
                                        }
                                        .fillBackground()
                                        .padding()
                                        
                                        // MARK: - Review & Share
                                        
                                        VStack {
                                                Button(action: {
                                                        if let appStoreUrl: URL = URL(string: "itms-apps://apple.com/app/id1509367629") {
                                                                UIApplication.shared.open(appStoreUrl)
                                                        }
                                                }) {
                                                        MessageView(icon: "heart", text: Text("Review in App Store"), symbol: Image(systemName: "arrow.up.right"))
                                                }.padding(.top)
                                                
                                                Divider()
                                                
                                                ShareSheetView(content: MessageView(icon: "square.and.arrow.up", text: Text("Share this App")),
                                                               activityItems: [URL(string: "https://apps.apple.com/app/id1509367629")!])
                                                        .padding(.bottom)
                                        }
                                        .fillBackground()
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

private struct MailFeedbackButton: View {
        
        @State private var isPresented: Bool = false
        @State private var isMailOnPhoneUnavailable: Bool = false
        @State private var isMailOnPadUnavailable: Bool = false
        
        let mailComposeDelegate: MailComposeDelegate
        
        var body: some View {
                Button(action: {
                        if MFMailComposeViewController.canSendMail() {
                                self.isPresented.toggle()
                        } else if UITraitCollection.current.userInterfaceIdiom == .phone {
                                self.isMailOnPhoneUnavailable.toggle()
                                UINotificationFeedbackGenerator().notificationOccurred(.warning)
                        } else {
                                self.isMailOnPadUnavailable.toggle()
                        }
                }) {
                        MessageView(icon: "envelope",
                                    text: Text("Email Feedback"),
                                    symbol: Image(systemName: "square.and.pencil"))
                }
                .sheet(isPresented: $isPresented) { ComposeMailView(mailComposeDelegate: self.mailComposeDelegate) }
                .actionSheet(isPresented: $isMailOnPhoneUnavailable) {
                        ActionSheet(title: Text("Unable to compose mail"),
                                    message: Text("Mail Unavailable"),
                                    buttons: [.cancel(Text("OK"))])
                }
                .alert(isPresented: $isMailOnPadUnavailable) {
                        Alert(title: Text("Unable to compose mail"),
                              message: Text("Mail Unavailable"),
                              dismissButton: .cancel(Text("OK"))
                        )
                }
        }
}
private struct ComposeMailView: UIViewControllerRepresentable {
        typealias UIViewControllerType = MFMailComposeViewController
        let mailComposeDelegate: MailComposeDelegate
        
        func makeUIViewController(context: Context) -> MFMailComposeViewController {
                let mailCompose = MFMailComposeViewController()
                mailCompose.title = "User Feedback"
                mailCompose.setSubject("User Feedback")
                mailCompose.setToRecipients(["bing@ososo.io"])
                
                let deviceIdentifier: String = {
                        var systemInfo = utsname()
                        uname(&systemInfo)
                        let machineMirror = Mirror(reflecting: systemInfo.machine)
                        let modelIdentifier: String = machineMirror.children.reduce("") { identifier, element in
                                guard let value: Int8 = element.value as? Int8, value != 0 else { return identifier }
                                return identifier + String(UnicodeScalar(UInt8(value)))
                        }
                        return modelIdentifier
                }()
                let system: String = UIDevice.current.systemName + " " + UIDevice.current.systemVersion
                let version: String = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? "_error"
                let build: String = (Bundle.main.infoDictionary?["CFBundleVersion"] as? String) ?? "_error"
                let messageBody: String = """
                [ Enter your feedback here. ]
                
                
                App version: \(version), build: \(build)
                Platform: \(deviceIdentifier) - \(system)
                
                """
                mailCompose.setMessageBody(messageBody, isHTML: false)
                
                mailCompose.mailComposeDelegate = mailComposeDelegate
                return mailCompose
        }
        func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) { }
}
private final class MailComposeDelegate: NSObject, MFMailComposeViewControllerDelegate {
        func mailComposeController(_ controller: MFMailComposeViewController,
                                   didFinishWith result: MFMailComposeResult,
                                   error: Error?) {
                controller.dismiss(animated: true, completion: nil)
        }
}
