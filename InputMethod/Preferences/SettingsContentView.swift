import SwiftUI
import AppKit

struct SettingsContentView: View {

        @State private var selection: PreferencesSidebarRow = AppSettings.selectedPreferencesSidebarRow

        private let characterImageName: String = {
                if #available(macOS 15.0, *) {
                        return "character.square"
                } else {
                        return "character"
                }
        }()

        var body: some View {
                NavigationSplitView {
                        List(selection: $selection) {
                                Section {
                                        Label("PreferencesView.NavigationTitle.General", systemImage: "gear").tag(PreferencesSidebarRow.general)
                                        Label("PreferencesView.NavigationTitle.ReverseLookup", systemImage: "doc.text.magnifyingglass").tag(PreferencesSidebarRow.reverseLookup)
                                        Label("PreferencesView.NavigationTitle.TonesInput", systemImage: "bell").tag(PreferencesSidebarRow.tonesInput)
                                        Label("PreferencesView.NavigationTitle.Fonts", systemImage: characterImageName).tag(PreferencesSidebarRow.fonts)
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
                        .navigationTitle("PreferencesView.NavigationTitle.Preferences")
                        .toolbarBackground(Material.ultraThin, for: .windowToolbar)
                } detail: {
                        switch selection {
                        case .general:
                                GeneralSettingsView()
                        case .tonesInput:
                                TonesInputView()
                        case .reverseLookup:
                                ReverseLookupView()
                        case .fonts:
                                FontSettingsView()
                        case .hotkeys:
                                HotkeysView()
                        case .about:
                                AboutView()
                        }
                }
                .background(VisualEffectView())
        }
}

enum PreferencesSidebarRow: Int, Identifiable {
        case general
        case reverseLookup
        case tonesInput
        case fonts
        case hotkeys
        case about
        var id: Int {
                return rawValue
        }
}
