import SwiftUI
import AppKit

extension DispatchQueue {
        static let preferences: DispatchQueue = DispatchQueue(label: "org.jyutping.inputmethod.Jyutping.Preferences")
}

final class PreferencesAppDelegate: NSObject, NSApplicationDelegate {
        func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
                return true
        }
}

struct PreferencesView: View {

        @NSApplicationDelegateAdaptor(PreferencesAppDelegate.self) var appDelegate

        @State private var isLayoutsViewActive: Bool = true

        var body: some View {
                NavigationView {
                        List {
                                Section {
                                        NavigationLink(destination: CandidateLayoutPreferencesView(), isActive: $isLayoutsViewActive) {
                                                Label("Layouts", systemImage: "list.number")
                                        }
                                        NavigationLink(destination: CandidateFontPreferencesView()) {
                                                Label("Fonts", systemImage: "textformat")
                                        }
                                } header: {
                                        Text("Candidates").textCase(.none)
                                }

                                Section {
                                        NavigationLink(destination: HotkeysView()) {
                                                Label("Hotkeys", systemImage: "keyboard")
                                        }
                                } header: {
                                        Text("Hotkeys").textCase(.none)
                                }

                                Section {
                                        NavigationLink(destination: AboutView()) {
                                                Label("About", systemImage: "info.circle")
                                        }
                                } header: {
                                        Text("About").textCase(.none)
                                }
                        }
                        .listStyle(.sidebar)
                        .navigationTitle("Preferences")
                }
        }
}


extension View {
        func block() -> some View {
                return self.padding().background(.regularMaterial, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
        }
}

