import SwiftUI
import AppKit

final class PreferencesAppDelegate: NSObject, NSApplicationDelegate {
        func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
                return true
        }
}

struct PreferencesView: View {

        @NSApplicationDelegateAdaptor(PreferencesAppDelegate.self) var appDelegate

        var body: some View {
                NavigationView {
                        List {
                                Section {
                                        NavigationLink(destination: PreferencesCandidatesView()) {
                                                Label("Candidates", systemImage: "list.number")
                                        }
                                        NavigationLink(destination: HotkeysView()) {
                                                Label("Hotkeys", systemImage: "keyboard")
                                        }
                                } header: {
                                        Text("General").textCase(.none)
                                }
                                Section {
                                        NavigationLink(destination: AboutView()) {
                                                Label("About", systemImage: "info.circle")
                                        }
                                } header: {
                                        Text("About").textCase(.none)
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
                        .navigationTitle("Preferences")
                }
        }
}

struct AboutView: View {
        var body: some View {
                ScrollView {
                        LazyVStack {
                                Text(verbatim: "About")
                        }
                }
                .navigationTitle("About")
        }
}
