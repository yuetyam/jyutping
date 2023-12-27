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

        // macOS 13.0+
        @State private var selection: PreferencesRow = Options.selectedPreferencesRow

        // macOS 12
        @State private var isLayoutsViewActive: Bool = Options.selectedPreferencesRow == .layouts
        @State private var isHotkeysViewActive: Bool = Options.selectedPreferencesRow == .hotkeys
        @State private var isAboutViewActive: Bool = Options.selectedPreferencesRow == .about

        var body: some View {
                if #available(macOS 13.0, *) {
                        NavigationSplitView {
                                List(selection: $selection) {
                                        Section {
                                                Label("PreferencesView.NavigationTitle.Layouts", systemImage: "list.number").tag(PreferencesRow.layouts)
                                                Label("PreferencesView.NavigationTitle.Fonts", systemImage: "textformat").tag(PreferencesRow.fonts)
                                        } header: {
                                                Text("PreferencesView.SectionHeader.Candidates").textCase(nil)
                                        }
                                        Section {
                                                Label("PreferencesView.NavigationTitle.Hotkeys", systemImage: "keyboard").tag(PreferencesRow.hotkeys)
                                        } header: {
                                                Text("PreferencesView.SectionHeader.Hotkeys").textCase(nil)
                                        }
                                        Section {
                                                Label("PreferencesView.NavigationTitle.About", systemImage: "info.circle").tag(PreferencesRow.about)
                                        } header: {
                                                Text("PreferencesView.SectionHeader.About").textCase(nil)
                                        }
                                }
                                .toolbarBackground(Material.bar, for: .windowToolbar)
                                .navigationTitle("PreferencesView.NavigationTitle.Preferences")
                        } detail: {
                                switch selection {
                                case .layouts:
                                        CandidateLayoutPreferencesView().visualEffect()
                                case .fonts:
                                        CandidateFontPreferencesView().visualEffect()
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
                                                NavigationLink(destination: CandidateLayoutPreferencesView().visualEffect(), isActive: $isLayoutsViewActive) {
                                                        Label("PreferencesView.NavigationTitle.Layouts", systemImage: "list.number")
                                                }
                                                NavigationLink {
                                                        CandidateFontPreferencesView().visualEffect()
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

enum PreferencesRow: Int, Hashable, Identifiable {

        case layouts
        case fonts
        case hotkeys
        case about

        var id: Int {
                return rawValue
        }
}
