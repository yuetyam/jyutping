import SwiftUI

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
        func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
                return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
        }
}

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
        var window: UIWindow?
        func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
                if let windowScene = scene as? UIWindowScene {
                        let window = UIWindow(windowScene: windowScene)
                        window.rootViewController = UIHostingController(rootView: ContentView())
                        self.window = window
                        window.makeKeyAndVisible()
                        if #available(iOS 15.0, *) {
                                UITextField.appearance().clearButtonMode = .always
                        }
                }
        }
}


struct AppMaster {
        static func open(appUrl: URL, webUrl: URL) {
                UIApplication.shared.open(appUrl) { success in
                        if !success {
                                UIApplication.shared.open(webUrl)
                        }
                }
        }
}
