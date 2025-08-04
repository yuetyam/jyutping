import SwiftUI
import AppKit

struct SettingsContentView: View {
        var body: some View {
                if #available(macOS 13.0, *) {
                        SettingsSplitView().background(VisualEffectView())
                } else {
                        PreferencesView().background(VisualEffectView())
                }
        }
}

@available(macOS 13.0, *)
struct SettingsSplitView: View {

        @State private var selection: PreferencesSidebarRow = AppSettings.selectedPreferencesSidebarRow

        private let characterImageName: String = {
                if #available(macOS 15.0, *) {
                        return "character.square.zh"
                } else {
                        return "character.zh"
                }
        }()

        var body: some View {
                NavigationSplitView {
                        List(selection: $selection) {
                                Section {
                                        Label("PreferencesView.NavigationTitle.General", systemImage: "gear").tag(PreferencesSidebarRow.general)
                                        Label("PreferencesView.NavigationTitle.ToneInput", systemImage: "bell").tag(PreferencesSidebarRow.toneInput)
                                        Label("PreferencesView.NavigationTitle.ReverseLookup", systemImage: "doc.text.magnifyingglass").tag(PreferencesSidebarRow.reverseLookup)
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
                        case .toneInput:
                                ToneInputView()
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
        }
}

@available(macOS, introduced: 12.0, deprecated: 13.0, message: "Use SettingsSplitView instead")
struct PreferencesView: View {

        @State private var isGeneralViewActive: Bool = AppSettings.selectedPreferencesSidebarRow == .general
        @State private var isHotkeysViewActive: Bool = AppSettings.selectedPreferencesSidebarRow == .hotkeys
        @State private var isAboutViewActive: Bool = AppSettings.selectedPreferencesSidebarRow == .about

        var body: some View {
                NavigationView {
                        List {
                                Section {
                                        NavigationLink(destination: GeneralPreferencesView(), isActive: $isGeneralViewActive) {
                                                Label("PreferencesView.NavigationTitle.General", systemImage: "gear")
                                        }
                                        NavigationLink {
                                                ToneInputView()
                                        } label: {
                                                Label("PreferencesView.NavigationTitle.ToneInput", systemImage: "bell")
                                        }
                                        NavigationLink {
                                                ReverseLookupView()
                                        } label: {
                                                Label("PreferencesView.NavigationTitle.ReverseLookup", systemImage: "doc.text.magnifyingglass")
                                        }
                                        NavigationLink {
                                                FontPreferencesView()
                                        } label: {
                                                Label("PreferencesView.NavigationTitle.Fonts", systemImage: "character.zh")
                                        }
                                } header: {
                                        Text("PreferencesView.SectionHeader.Candidates").textCase(nil)
                                }

                                Section {
                                        NavigationLink(destination: HotkeysView(), isActive: $isHotkeysViewActive) {
                                                Label("PreferencesView.NavigationTitle.Hotkeys", systemImage: "keyboard")
                                        }
                                } header: {
                                        Text("PreferencesView.SectionHeader.Hotkeys").textCase(nil)
                                }

                                Section {
                                        NavigationLink(destination: AboutView(), isActive: $isAboutViewActive) {
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

enum PreferencesSidebarRow: Int, Identifiable {
        case general
        case toneInput
        case reverseLookup
        case fonts
        case hotkeys
        case about
        var id: Int {
                return rawValue
        }
}
