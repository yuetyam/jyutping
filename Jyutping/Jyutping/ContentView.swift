import SwiftUI

struct ContentView: View {
        @State private var selection: Int = 0
        var body: some View {
                TabView(selection: $selection){
                        if #available(iOS 15.0, *) {
                                HomeView_iOS15().tabItem {
                                        Label("Home", systemImage: "house")
                                }.tag(0)

                                JyutpingView_iOS15().tabItem {
                                        Label("Jyutping", systemImage: "doc.text.magnifyingglass")
                                }.tag(1)

                                AboutView_iOS15().tabItem {
                                        Label("About", systemImage: "info.circle")
                                }.tag(2)
                        } else if #available(iOS 14.0, *) {
                                HomeView_iOS14().tabItem {
                                        Label("Home", systemImage: "house")
                                }.tag(0)

                                JyutpingView().tabItem {
                                        Label("Jyutping", systemImage: "doc.text.magnifyingglass")
                                }.tag(1)

                                AboutView().tabItem {
                                        Label("About", systemImage: "info.circle")
                                }.tag(2)
                        } else {
                                HomeView().tabItem {
                                        Image(systemName: "house")
                                        Text("Home")
                                }.tag(0)

                                JyutpingView().tabItem {
                                        Image(systemName: "doc.text.magnifyingglass")
                                        Text("Jyutping")
                                }.tag(1)

                                AboutView().tabItem {
                                        Image(systemName: "info.circle")
                                        Text("About")
                                }.tag(2)
                        }
                }
        }
}

struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
                ContentView()
        }
}


extension View {
        func fillBackground(cornerRadius: CGFloat = 10) -> some View {
                modifier(BackgroundColorModifier(cornerRadius: cornerRadius))
        }
}
private struct BackgroundColorModifier: ViewModifier {

        @Environment (\.colorScheme) var colorScheme: ColorScheme
        let cornerRadius: CGFloat

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
                return content.background(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous).fill(backgroundColor))
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
