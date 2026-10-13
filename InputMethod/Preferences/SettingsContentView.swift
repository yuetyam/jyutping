import SwiftUI
import AppKit

struct SettingsContentView: View {

        @State private var selection: SettingsSidebarRow = AppSettings.selectedSettingsSidebarRow

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
                                        Label("SettingsView.NavigationTitle.General", systemImage: "gear").tag(SettingsSidebarRow.general)
                                        Label("SettingsView.NavigationTitle.Appearance", systemImage: "paintpalette").tag(SettingsSidebarRow.appearance)
                                        Label("SettingsView.NavigationTitle.ReverseLookup", systemImage: "doc.text.magnifyingglass").tag(SettingsSidebarRow.reverseLookup)
                                        Label("SettingsView.NavigationTitle.TonesInput", systemImage: "bell").tag(SettingsSidebarRow.tonesInput)
                                        Label("SettingsView.NavigationTitle.Fonts", systemImage: characterImageName).tag(SettingsSidebarRow.fonts)
                                        Label("SettingsView.NavigationTitle.InputMemory", systemImage: "sparkles.rectangle.stack").tag(SettingsSidebarRow.memory)
                                } header: {
                                        Text("SettingsView.SectionHeader.Candidates").textCase(nil)
                                }
                                Section {
                                        Label("SettingsView.NavigationTitle.Hotkeys", systemImage: "keyboard").tag(SettingsSidebarRow.hotkeys)
                                } header: {
                                        Text("SettingsView.SectionHeader.Hotkeys").textCase(nil)
                                }
                                Section {
                                        Label("SettingsView.NavigationTitle.About", systemImage: "info.circle").tag(SettingsSidebarRow.about)
                                } header: {
                                        Text("SettingsView.SectionHeader.About").textCase(nil)
                                }
                        }
                        .navigationTitle("SettingsView.NavigationTitle.Settings")
                        .toolbarBackground(Material.ultraThin, for: .windowToolbar)
                } detail: {
                        switch selection {
                        case .general:
                                GeneralSettingsView()
                        case .appearance:
                                AppearanceSettingsView()
                        case .tonesInput:
                                TonesInputView()
                        case .reverseLookup:
                                ReverseLookupView()
                        case .fonts:
                                FontSettingsView()
                        case .memory:
                                InputMemorySettingsView()
                        case .hotkeys:
                                HotkeysView()
                        case .about:
                                AboutView()
                        }
                }
                .background(VisualEffectView())
        }
}

enum SettingsSidebarRow: Int, Identifiable {
        case general
        case appearance
        case reverseLookup
        case tonesInput
        case fonts
        case memory
        case hotkeys
        case about
        var id: Int {
                return rawValue
        }
}
