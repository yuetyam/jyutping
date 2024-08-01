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
                                                Label("PreferencesView.NavigationTitle.ToneInput", systemImage: "bell").tag(PreferencesSidebarRow.toneInput)
                                                Label("PreferencesView.NavigationTitle.ReverseLookup", systemImage: "doc.text.magnifyingglass").tag(PreferencesSidebarRow.reverseLookup)
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
                                        GeneralPreferencesView().applyVisualEffect()
                                case .toneInput:
                                        ToneInputView().applyVisualEffect()
                                case .reverseLookup:
                                        ReverseLookupView().applyVisualEffect()
                                case .fonts:
                                        FontPreferencesView().applyVisualEffect()
                                case .hotkeys:
                                        HotkeysView().applyVisualEffect()
                                case .about:
                                        AboutView().applyVisualEffect()
                                }
                        }
                } else {
                        NavigationView {
                                List {
                                        Section {
                                                NavigationLink(destination: GeneralPreferencesView().applyVisualEffect(), isActive: $isGeneralViewActive) {
                                                        Label("PreferencesView.NavigationTitle.General", systemImage: "gear")
                                                }
                                                NavigationLink {
                                                        ToneInputView().applyVisualEffect()
                                                } label: {
                                                        Label("PreferencesView.NavigationTitle.ToneInput", systemImage: "bell")
                                                }
                                                NavigationLink {
                                                        ReverseLookupView().applyVisualEffect()
                                                } label: {
                                                        Label("PreferencesView.NavigationTitle.ReverseLookup", systemImage: "doc.text.magnifyingglass")
                                                }
                                                NavigationLink {
                                                        FontPreferencesView().applyVisualEffect()
                                                } label: {
                                                        Label("PreferencesView.NavigationTitle.Fonts", systemImage: "textformat")
                                                }
                                        } header: {
                                                Text("PreferencesView.SectionHeader.Candidates").textCase(nil)
                                        }

                                        Section {
                                                NavigationLink(destination: HotkeysView().applyVisualEffect(), isActive: $isHotkeysViewActive) {
                                                        Label("PreferencesView.NavigationTitle.Hotkeys", systemImage: "keyboard")
                                                }
                                        } header: {
                                                Text("PreferencesView.SectionHeader.Hotkeys").textCase(nil)
                                        }

                                        Section {
                                                NavigationLink(destination: AboutView().applyVisualEffect(), isActive: $isAboutViewActive) {
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
        case toneInput
        case reverseLookup
        case fonts
        case hotkeys
        case about
        var id: Int {
                return rawValue
        }
}
