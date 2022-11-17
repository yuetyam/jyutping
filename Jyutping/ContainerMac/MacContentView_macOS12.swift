import SwiftUI

struct MacContentView_macOS12: View {

        @State private var isMacSearchViewActive: Bool = true

        var body: some View {
                NavigationView {
                        List {
                                Section {
                                        NavigationLink(destination: InputMethodInstallationView()) {
                                                Label("Install Input Method", systemImage: "laptopcomputer.and.arrow.down")
                                        }
                                        NavigationLink(destination: MacIntroductionsView()) {
                                                Label("Introductions", systemImage: "book")
                                        }
                                        NavigationLink(destination: MacExpressionsView().textSelection(.enabled)) {
                                                Label("Cantonese Expressions", systemImage: "text.quote")
                                        }
                                } header: {
                                        Text("Keyboard").textCase(nil)
                                }
                                Section {
                                        NavigationLink(destination: MacSearchView(), isActive: $isMacSearchViewActive) {
                                                Label("Search", systemImage: "magnifyingglass")
                                        }
                                        NavigationLink(destination: InitialsTable()) {
                                                Label("Initials", systemImage: "rectangle.leadingthird.inset.filled")
                                        }
                                        NavigationLink(destination: FinalsTable()) {
                                                Label("Finals", systemImage: "rectangle.trailingthird.inset.filled")
                                        }
                                        NavigationLink(destination: TonesTable()) {
                                                Label("Tones", systemImage: "bell")
                                        }
                                } header: {
                                        Text("Jyutping").textCase(nil)
                                }
                                Section {
                                        NavigationLink(destination: ResourcesView()) {
                                                Label("Resources", systemImage: "globe.asia.australia")
                                        }
                                        NavigationLink(destination: MacAboutView()) {
                                                Label("About", systemImage: "info.circle")
                                        }
                                } header: {
                                        Text("About").textCase(nil)
                                }
                        }
                        .toolbar {
                                ToolbarItem(placement: .navigation) {
                                        Button {
                                                NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
                                        } label: {
                                                Image(systemName: "sidebar.leading")
                                        }
                                }
                        }
                        .listStyle(.sidebar)
                        .navigationTitle("Jyutping")
                }
        }
}
