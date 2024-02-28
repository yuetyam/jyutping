import SwiftUI
import AppKit

extension DispatchQueue {
        static let preferences: DispatchQueue = DispatchQueue(label: "org.jyutping.inputmethod.Jyutping.Preferences")
}

final class PreferencesViewAppDelegate: NSObject, NSApplicationDelegate {
        func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
                return true
        }
        func applicationWillFinishLaunching(_ notification: Notification) {
                NSWindow.allowsAutomaticWindowTabbing = false
        }
        func applicationDidFinishLaunching(_ notification: Notification) {
                _ = NSApp.windows.map({ $0.tabbingMode = .disallowed })
        }
}

struct PreferencesView: View {

        @NSApplicationDelegateAdaptor(PreferencesViewAppDelegate.self) var appDelegate

        // macOS 13.0+
        @State private var selection: PreferencesSidebarRow = AppSettings.selectedPreferencesSidebarRow

        // macOS 12
        @State private var isGeneralViewActive: Bool = AppSettings.selectedPreferencesSidebarRow == .general
        @State private var isHotkeysViewActive: Bool = AppSettings.selectedPreferencesSidebarRow == .hotkeys
        @State private var isAboutViewActive: Bool = AppSettings.selectedPreferencesSidebarRow == .about

        var body: some View {
                if #available(macOS 13.0, *) {
                        NavigationSplitView {
                                List(selection: $selection) {
                                        Section {
                                                Label("PreferencesView.NavigationTitle.General", systemImage: "gear").tag(PreferencesSidebarRow.general)
                                                Label("PreferencesView.NavigationTitle.Fonts", systemImage: "textformat").tag(PreferencesSidebarRow.fonts)
                                        } header: {
                                                Text("PreferencesView.SectionHeader.Candidates").textCase(nil)
                                        }
                                        Section {
                                                Label("PreferencesView.NavigationTitle.Hotkeys", systemImage: "keyboard").tag(PreferencesSidebarRow.hotkeys)
                                        } header: {
                                                Text("PreferencesView.SectionHeader.Hotkeys").textCase(nil)
                                        }
                                        Section {
                                                Label("PreferencesView.NavigationTitle.About", systemImage: "info.circle").tag(PreferencesSidebarRow.about)
                                        } header: {
                                                Text("PreferencesView.SectionHeader.About").textCase(nil)
                                        }
                                }
                                .toolbarBackground(Material.bar, for: .windowToolbar)
                                .navigationTitle("PreferencesView.NavigationTitle.Preferences")
                        } detail: {
                                switch selection {
                                case .general:
                                        GeneralPreferencesView().visualEffect()
                                case .fonts:
                                        FontPreferencesView().visualEffect()
                                case .hotkeys:
                                        HotkeysView().visualEffect()
                                case .about:
                                        AboutView().visualEffect()
                                }
                        }
                } else {
                        NavigationView {
                                List {
                                        Section {
                                                NavigationLink(destination: GeneralPreferencesView().visualEffect(), isActive: $isGeneralViewActive) {
                                                        Label("PreferencesView.NavigationTitle.General", systemImage: "gear")
                                                }
                                                NavigationLink {
                                                        FontPreferencesView().visualEffect()
                                                } label: {
                                                        Label("PreferencesView.NavigationTitle.Fonts", systemImage: "textformat")
                                                }
                                        } header: {
                                                Text("PreferencesView.SectionHeader.Candidates").textCase(nil)
                                        }

                                        Section {
                                                NavigationLink(destination: HotkeysView().visualEffect(), isActive: $isHotkeysViewActive) {
                                                        Label("PreferencesView.NavigationTitle.Hotkeys", systemImage: "keyboard")
                                                }
                                        } header: {
                                                Text("PreferencesView.SectionHeader.Hotkeys").textCase(nil)
                                        }

                                        Section {
                                                NavigationLink(destination: AboutView().visualEffect(), isActive: $isAboutViewActive) {
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
}

enum PreferencesSidebarRow: Int, Identifiable {
        case general
        case fonts
        case hotkeys
        case about
        var id: Int {
                return rawValue
        }
}
