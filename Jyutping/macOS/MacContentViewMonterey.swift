#if os(macOS)

import SwiftUI

@available(macOS, deprecated: 13, message: "Use MacContentView instead")
struct MacContentViewMonterey: View {

        @State private var isMacSearchViewActive: Bool = true
        @State private var isMacAboutViewActive: Bool = false

        var body: some View {
                NavigationView {
                        List {
                                Section {
                                        NavigationLink {
                                                MacInputMethodView()
                                        } label: {
                                                Label("MacSidebar.NavigationTitle.InstallInputMethod", systemImage: "sparkles")
                                        }
                                        NavigationLink {
                                                MacIntroductionsView()
                                        } label: {
                                                Label("MacSidebar.NavigationTitle.Introductions", systemImage: "book")
                                        }
                                        NavigationLink {
                                                MacExpressionsView()
                                        } label: {
                                                Label("MacSidebar.NavigationTitle.CantoneseExpressions", systemImage: "checkmark.seal")
                                        }
                                        NavigationLink {
                                                MacConfusionView()
                                        } label: {
                                                Label("MacSidebar.NavigationTitle.SimplifiedCharacterConfusion", systemImage: "character.zh")
                                        }
                                } header: {
                                        Text("MacSidebar.SectionHeader.InputMethod").textCase(nil).font(.copilot)
                                }
                                .font(.master)
                                Section {
                                        NavigationLink(destination: MacSearchView(), isActive: $isMacSearchViewActive) {
                                                Label("MacSidebar.NavigationTitle.Search", systemImage: "magnifyingglass")
                                        }
                                        NavigationLink {
                                                MacJyutpingInitialTable()
                                        } label: {
                                                Label("MacSidebar.NavigationTitle.JyutpingInitials", systemImage: "rectangle.leadingthird.inset.filled")
                                        }
                                        NavigationLink {
                                                MacJyutpingFinalTable()
                                        } label: {
                                                Label("MacSidebar.NavigationTitle.JyutpingFinals", systemImage: "rectangle.trailingthird.inset.filled")
                                        }
                                        NavigationLink {
                                                MacJyutpingToneTable()
                                        } label: {
                                                Label("MacSidebar.NavigationTitle.JyutpingTones", systemImage: "bell")
                                        }
                                } header: {
                                        Text("MacSidebar.SectionHeader.Jyutping").textCase(nil).font(.copilot)
                                }
                                .font(.master)
                                Section {
                                        NavigationLink {
                                                NumbersView()
                                        } label: {
                                                Label("MacSidebar.NavigationTitle.Numbers", systemImage: "number")
                                        }
                                        NavigationLink {
                                                StemsBranchesView()
                                        } label: {
                                                Label("MacSidebar.NavigationTitle.StemsAndBranches", systemImage: "timelapse")
                                        }
                                        NavigationLink {
                                                ChineseZodiacView()
                                        } label: {
                                                Label("MacSidebar.NavigationTitle.ChineseZodiac", systemImage: "hare")
                                        }
                                        NavigationLink {
                                                SolarTermsView()
                                        } label: {
                                                Label("MacSidebar.NavigationTitle.SolarTerms", systemImage: "cloud.sun")
                                        }
                                        NavigationLink {
                                                MacHundredFamilySurnamesView()
                                        } label: {
                                                Label("MacSidebar.NavigationTitle.HundredFamilySurnames", systemImage: "person")
                                        }
                                        NavigationLink {
                                                MacThousandCharacterClassicView()
                                        } label: {
                                                Label("MacSidebar.NavigationTitle.ThousandCharacterClassic", systemImage: "character.zh")
                                        }
                                } header: {
                                        Text("MacSidebar.SectionHeader.Cantonese").textCase(nil).font(.copilot)
                                }
                                .font(.master)
                                Section {
                                        NavigationLink {
                                                MacCantonMetroView()
                                        } label: {
                                                Label("MacSidebar.NavigationTitle.CantonMetro", systemImage: "tram.circle")
                                        }
                                        NavigationLink {
                                                MacFatshanMetroView()
                                        } label: {
                                                Label("MacSidebar.NavigationTitle.FatshanMetro", systemImage: "tram.circle")
                                        }
                                        NavigationLink {
                                                MacMacauMetroView()
                                        } label: {
                                                Label("MacSidebar.NavigationTitle.MacauMetro", systemImage: "tram.circle")
                                        }
                                        NavigationLink {
                                                MacTungkunRailTransitView()
                                        } label: {
                                                Label("MacSidebar.NavigationTitle.TungkunRailTransit", systemImage: "tram.circle")
                                        }
                                        NavigationLink {
                                                MacShamChunMetroView()
                                        } label: {
                                                Label("MacSidebar.NavigationTitle.ShamChunMetro", systemImage: "tram.circle")
                                        }
                                        NavigationLink {
                                                MacHongKongMTRView()
                                        } label: {
                                                Label("MacSidebar.NavigationTitle.HongKongMTR", systemImage: "tram.circle")
                                        }
                                } header: {
                                        Text("MacSidebar.SectionHeader.Metro").textCase(nil).font(.copilot)
                                }
                                .font(.master)
                                Section {
                                        NavigationLink {
                                                MacResourcesView()
                                        } label: {
                                                Label("MacSidebar.NavigationTitle.Resources", systemImage: "globe.asia.australia")
                                        }
                                        NavigationLink(destination: MacAboutView(), isActive: $isMacAboutViewActive) {
                                                Label("MacSidebar.NavigationTitle.About", systemImage: "info.circle")
                                        }
                                } header: {
                                        Text("MacSidebar.SectionHeader.About").textCase(nil).font(.copilot)
                                }
                                .font(.master)
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
                        .navigationTitle("MacContentView.NavigationTitle.Jyutping")
                        .onReceive(NotificationCenter.default.publisher(for: .focusSearch)) { _ in
                                isMacSearchViewActive = true
                                isMacAboutViewActive = false
                        }
                        .onReceive(NotificationCenter.default.publisher(for: .openAbout)) { _ in
                                isMacSearchViewActive = false
                                isMacAboutViewActive = true
                        }
                }
        }
}

#endif
