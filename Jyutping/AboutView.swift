import SwiftUI
// import MessageUI

struct AboutView: View {

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
                                                EmailFeedbackButton()
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


private struct EmailFeedbackButton: View {

        @State private var isMailOnPhoneUnavailable: Bool = false
        @State private var isMailOnPadUnavailable: Bool = false

        var body: some View {
                Button(action: {
                        UIApplication.shared.open(mailtoUrl) { success in
                                if !success {
                                        if UITraitCollection.current.userInterfaceIdiom == .phone {
                                                self.isMailOnPhoneUnavailable.toggle()
                                                UINotificationFeedbackGenerator().notificationOccurred(.warning)
                                        } else {
                                                self.isMailOnPadUnavailable.toggle()
                                        }
                                }
                        }
                }) {
                        MessageView(icon: "envelope",
                                    text: Text("Email Feedback"),
                                    symbol: Image(systemName: "square.and.pencil"))
                }
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

        private let mailtoUrl: URL = {
                let versionString: String = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? "_error"
                let buildString: String = (Bundle.main.infoDictionary?["CFBundleVersion"] as? String) ?? "_error"
                let version: String = versionString + "(" + buildString + ")"
                let device: String = UIDevice.modelName
                let system: String = UIDevice.current.systemName + " " + UIDevice.current.systemVersion
                let messageBody: String = """

                
                Version: \(version)
                Device: \(device)
                System: \(system)
                """
                let address: String = "bing@ososo.io"
                let subject: String = "User Feedback"
                let scheme: String = "mailto:\(address)?subject=\(subject)&body=\(messageBody)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                return URL(string: scheme)!
        }()
}


private extension UIDevice {

        static let modelName: String = {
                var systemInfo = utsname()
                uname(&systemInfo)
                let machineMirror = Mirror(reflecting: systemInfo.machine)
                let identifier: String = machineMirror.children.reduce("") { identifier, element in
                        guard let value: Int8 = element.value as? Int8, value != 0 else { return identifier }
                        return identifier + String(UnicodeScalar(UInt8(value)))
                }
                switch identifier {
                case "iPod9,1":                     return "iPod touch (7th generation)"
                case "iPhone8,1":                   return "iPhone 6s"
                case "iPhone8,2":                   return "iPhone 6s Plus"
                case "iPhone8,4":                   return "iPhone SE"
                case "iPhone9,1", "iPhone9,3":      return "iPhone 7"
                case "iPhone9,2", "iPhone9,4":      return "iPhone 7 Plus"
                case "iPhone10,1", "iPhone10,4":    return "iPhone 8"
                case "iPhone10,2", "iPhone10,5":    return "iPhone 8 Plus"
                case "iPhone10,3", "iPhone10,6":    return "iPhone X"
                case "iPhone11,2":                  return "iPhone XS"
                case "iPhone11,4", "iPhone11,6":    return "iPhone XS Max"
                case "iPhone11,8":                  return "iPhone XR"
                case "iPhone12,1":                  return "iPhone 11"
                case "iPhone12,3":                  return "iPhone 11 Pro"
                case "iPhone12,5":                  return "iPhone 11 Pro Max"
                case "iPhone12,8":                  return "iPhone SE (2nd generation)"
                case "iPhone13,1":                  return "iPhone 12 mini"
                case "iPhone13,2":                  return "iPhone 12"
                case "iPhone13,3":                  return "iPhone 12 Pro"
                case "iPhone13,4":                  return "iPhone 12 Pro Max"
                case "iPad6,11", "iPad6,12":        return "iPad (5th generation)"
                case "iPad7,5", "iPad7,6":          return "iPad (6th generation)"
                case "iPad7,11", "iPad7,12":        return "iPad (7th generation)"
                case "iPad11,6", "iPad11,7":        return "iPad (8th generation)"
                case "iPad5,3", "iPad5,4":          return "iPad Air 2"
                case "iPad11,3", "iPad11,4":        return "iPad Air (3rd generation)"
                case "iPad13,1", "iPad13,2":        return "iPad Air (4th generation)"
                case "iPad5,1", "iPad5,2":          return "iPad mini 4"
                case "iPad11,1", "iPad11,2":        return "iPad mini (5th generation)"
                case "iPad6,3", "iPad6,4":          return "iPad Pro (9.7-inch)"
                case "iPad7,3", "iPad7,4":          return "iPad Pro (10.5-inch)"
                case "iPad8,1", "iPad8,2",
                     "iPad8,3", "iPad8,4":          return "iPad Pro (11-inch) (1st generation)"
                case "iPad8,9", "iPad8,10":         return "iPad Pro (11-inch) (2nd generation)"
                case "iPad6,7", "iPad6,8":          return "iPad Pro (12.9-inch) (1st generation)"
                case "iPad7,1", "iPad7,2":          return "iPad Pro (12.9-inch) (2nd generation)"
                case "iPad8,5", "iPad8,6",
                     "iPad8,7", "iPad8,8":          return "iPad Pro (12.9-inch) (3rd generation)"
                case "iPad8,11", "iPad8,12":        return "iPad Pro (12.9-inch) (4th generation)"
                default:                            return identifier
                }
        }()
}


/*
private struct MailFeedbackButton: View {
        
        @State private var isPresented: Bool = false
        @State private var isMailOnPhoneUnavailable: Bool = false
        @State private var isMailOnPadUnavailable: Bool = false
        
        let mailComposeDelegate: MailComposeDelegate

        private let mailtoUrl: URL = {
                let scheme: String = "mailto:bing@ososo.io?subject=User%20Feedback&body=Enter%20your%20feedback%20here"
                return URL(string: scheme)!
        }()

        var body: some View {
                Button(action: {
                        if MFMailComposeViewController.canSendMail() {
                                self.isPresented.toggle()
                        } else if UIApplication.shared.canOpenURL(mailtoUrl) {
                                UIApplication.shared.open(mailtoUrl)
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
*/
