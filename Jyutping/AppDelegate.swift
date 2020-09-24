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

extension View {
        func fillBackground() -> some View {
                modifier(FillBackgroundColor())
        }
}
private struct FillBackgroundColor: ViewModifier {
        @Environment (\.colorScheme) var colorScheme: ColorScheme
        func body(content: Content) -> some View {
                let backgroundColor: Color = {
                        switch colorScheme {
                        case .light:
                                return Color(UIColor.systemBackground)
                        case .dark:
                                return Color(UIColor.secondarySystemBackground)
                        @unknown default:
                                return Color(UIColor.systemBackground)
                        }
                }()
                return content.background(RoundedRectangle(cornerRadius: 7).fill(backgroundColor))
        }
}

struct GlobalBackgroundColor: View {
        @Environment (\.colorScheme) var colorScheme: ColorScheme
        var body: some View {
                switch colorScheme {
                case .light:
                        return Color(UIColor.secondarySystemBackground)
                case .dark:
                        return Color(UIColor.systemBackground)
                @unknown default:
                        return Color(UIColor.secondarySystemBackground)
                }
        }
}
