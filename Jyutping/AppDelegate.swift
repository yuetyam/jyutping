import SwiftUI

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {}

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
        var window: UIWindow?
        func scene(_ scene: UIScene,  willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
                if let windowScene = scene as? UIWindowScene {
                        let window = UIWindow(windowScene: windowScene)
                        window.rootViewController = UIHostingController(rootView: ContentView())
                        self.window = window
                        window.makeKeyAndVisible()
                }
        }
}

struct ContentView: View {
        @State private var selection = 0
        var body: some View {
                TabView(selection: $selection){
                        HomeView()
                        JyutpingView()
                        AboutView()
                }
        }
}

struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
                ContentView()
        }
}
