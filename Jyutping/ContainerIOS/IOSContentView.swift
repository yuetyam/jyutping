import SwiftUI

struct IOSContentView: View {

        @State private var selection: Int = 0

        var body: some View {
                TabView(selection: $selection) {
                        if #available(iOS 15.0, *) {
                                HomeView()
                                        .tabItem {
                                                Label("Home", systemImage: "house").environment(\.symbolVariants, .none)
                                        }
                                        .tag(0)

                                JyutpingView_iOS15()
                                        .tabItem {
                                                Label("Jyutping", systemImage: "doc.text.magnifyingglass").environment(\.symbolVariants, .none)
                                        }
                                        .tag(1)

                                AboutView()
                                        .tabItem {
                                                Label("About", systemImage: "info.circle").environment(\.symbolVariants, .none)
                                        }
                                        .tag(2)

                        } else {
                                HomeView_iOS14()
                                        .tabItem {
                                                Label("Home", systemImage: "house")
                                        }
                                        .tag(0)

                                JyutpingView_iOS14()
                                        .tabItem {
                                                Label("Jyutping", systemImage: "doc.text.magnifyingglass")
                                        }
                                        .tag(1)

                                AboutView()
                                        .tabItem {
                                                Label("About", systemImage: "info.circle")
                                        }
                                        .tag(2)
                        }
                }
        }
}
