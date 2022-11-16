import SwiftUI

struct MacContentView: View {

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


@available(macOS 13.0, *)
struct MacContentView_macOS13: View {

        @State private var selection: ViewIdentifier = .search

        var body: some View {
                NavigationSplitView {
                        List(selection: $selection) {
                                Section {
                                        Label("Install Input Method", systemImage: "laptopcomputer.and.arrow.down").tag(ViewIdentifier.installation)
                                        Label("Introductions", systemImage: "book").tag(ViewIdentifier.introductions)
                                        Label("Cantonese Expressions", systemImage: "text.quote").tag(ViewIdentifier.expressions)
                                } header: {
                                        Text("Keyboard").textCase(nil)
                                }
                                Section {
                                        Label("Search", systemImage: "magnifyingglass").tag(ViewIdentifier.search)
                                        Label("Initials", systemImage: "rectangle.leadingthird.inset.filled").tag(ViewIdentifier.initials)
                                        Label("Finals", systemImage: "rectangle.trailingthird.inset.filled").tag(ViewIdentifier.finals)
                                        Label("Tones", systemImage: "bell").tag(ViewIdentifier.tones)
                                } header: {
                                        Text("Jyutping").textCase(nil)
                                }
                                Section {
                                        Label("Resources", systemImage: "globe.asia.australia").tag(ViewIdentifier.resources)
                                        Label("About", systemImage: "info.circle").tag(ViewIdentifier.about)
                                } header: {
                                        Text("About").textCase(nil)
                                }
                        }
                        .toolbarBackground(Material.ultraThinMaterial, for: .windowToolbar)
                        .navigationTitle("Jyutping")
                } detail: {
                        switch selection {
                        case .installation:
                                InputMethodInstallationView()
                        case .introductions:
                                MacIntroductionsView()
                        case .expressions:
                                MacExpressionsView()
                        case .search:
                                MacSearchView()
                        case .initials:
                                InitialsTable()
                        case .finals:
                                FinalsTable()
                        case .tones:
                                TonesTable()
                        case .resources:
                                ResourcesView()
                        case .about:
                                MacAboutView()
                        }
                }
        }
}


private enum ViewIdentifier: Int, Hashable, Identifiable {

        case installation
        case introductions
        case expressions

        case search
        case initials
        case finals
        case tones

        case resources
        case about

        var id: Int {
                return rawValue
        }
}

