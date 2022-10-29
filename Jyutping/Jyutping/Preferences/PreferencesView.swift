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
                                                Label("PreferencesView.NavigationTitle.Layouts", systemImage: "list.number")
                                        }
                                        NavigationLink(destination: CandidateFontPreferencesView()) {
                                                Label("PreferencesView.NavigationTitle.Fonts", systemImage: "textformat")
                                        }
                                } header: {
                                        Text("PreferencesView.SectionHeader.Candidates").textCase(nil)
                                }

                                Section {
                                        NavigationLink(destination: HotkeysView()) {
                                                Label("PreferencesView.NavigationTitle.Hotkeys", systemImage: "keyboard")
                                        }
                                } header: {
                                        Text("PreferencesView.SectionHeader.Hotkeys").textCase(nil)
                                }

                                Section {
                                        NavigationLink(destination: AboutView()) {
                                                Label("PreferencesView.NavigationTitle.About", systemImage: "info.circle")
                                        }
                                } header: {
                                        Text("PreferencesView.SectionHeader.About").textCase(nil)
                                }
                        }
                        .listStyle(.sidebar)
                        .navigationTitle("PreferencesView.NavigationTitle.Preferences")
                }
        }
}


extension View {
        func block() -> some View {
                return self.padding().background(.regularMaterial, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
        }
}

