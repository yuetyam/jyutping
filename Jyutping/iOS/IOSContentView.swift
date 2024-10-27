#if os(iOS)

import SwiftUI

@available(iOS 18.0, *)
struct IOS18ContentView: View {

        init() {
                UITextField.appearance().clearButtonMode = .always
        }

        var body: some View {
                TabView {
                        Tab {
                                HomeView()
                        } label: {
                                Label("IOSTabView.NavigationTitle.Home", systemImage: "house").environment(\.symbolVariants, .none)
                        }
                        Tab {
                                JyutpingView()
                        } label: {
                                Label("IOSTabView.NavigationTitle.Jyutping", systemImage: "doc.text.magnifyingglass").environment(\.symbolVariants, .none)
                        }
                        Tab {
                                CantoneseView()
                        } label: {
                                Label("IOSTabView.NavigationTitle.Cantonese", systemImage: "globe.asia.australia").environment(\.symbolVariants, .none)
                        }
                        Tab {
                                AboutView()
                        } label: {
                                Label("IOSTabView.NavigationTitle.About", systemImage: "info.circle").environment(\.symbolVariants, .none)
                        }
                }
        }
}

struct IOSContentView: View {

        init() {
                UITextField.appearance().clearButtonMode = .always
        }

        @State private var selection: Int = 0

        var body: some View {
                TabView(selection: $selection) {
                        HomeView()
                                .tabItem {
                                        Label("IOSTabView.NavigationTitle.Home", systemImage: "house").environment(\.symbolVariants, .none)
                                }
                                .tag(0)

                        JyutpingView()
                                .tabItem {
                                        Label("IOSTabView.NavigationTitle.Jyutping", systemImage: "doc.text.magnifyingglass").environment(\.symbolVariants, .none)
                                }
                                .tag(1)

                        CantoneseView()
                                .tabItem {
                                        Label("IOSTabView.NavigationTitle.Cantonese", systemImage: "globe.asia.australia").environment(\.symbolVariants, .none)
                                }
                                .tag(2)

                        AboutView()
                                .tabItem {
                                        Label("IOSTabView.NavigationTitle.About", systemImage: "info.circle").environment(\.symbolVariants, .none)
                                }
                                .tag(3)
                }
        }
}

#endif
