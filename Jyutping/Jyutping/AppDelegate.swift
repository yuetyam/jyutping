import SwiftUI

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {

        func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
                return true
        }

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
                }
        }
}
