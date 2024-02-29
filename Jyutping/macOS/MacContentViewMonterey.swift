#if os(macOS)

import SwiftUI

@available(macOS, deprecated: 13, message: "Use MacContentView instead")
struct MacContentViewMonterey: View {

        @State private var isMacSearchViewActive: Bool = true

        var body: some View {
                NavigationView {
                        List {
                                Section {
                                        NavigationLink {
                                                MacInputMethodInstallationView().visualEffect()
                                        } label: {
                                                Label("MacSidebar.NavigationTitle.InstallInputMethod", systemImage: "laptopcomputer.and.arrow.down")
                                        }
                                        NavigationLink {
                                                MacIntroductionsView().visualEffect()
                                        } label: {
                                                Label("MacSidebar.NavigationTitle.Introductions", systemImage: "book")
                                        }
                                        NavigationLink {
                                                MacExpressionsView().visualEffect()
                                        } label: {
                                                Label("MacSidebar.NavigationTitle.CantoneseExpressions", systemImage: "checkmark.seal")
                                        }
                                        NavigationLink {
                                                MacConfusionView().visualEffect()
                                        } label: {
                                                Label("MacSidebar.NavigationTitle.SimplifiedCharacterConfusion", systemImage: "character")
                                        }
                                } header: {
                                        Text("MacSidebar.SectionHeader.InputMethod").textCase(nil)
                                }
                                Section {
                                        NavigationLink(destination: MacSearchView().visualEffect(), isActive: $isMacSearchViewActive) {
                                                Label("MacSidebar.NavigationTitle.Search", systemImage: "magnifyingglass")
                                        }
                                        NavigationLink {
                                                InitialTable().visualEffect()
                                        } label: {
                                                Label("MacSidebar.NavigationTitle.JyutpingInitials", systemImage: "rectangle.leadingthird.inset.filled")
                                        }
                                        NavigationLink {
                                                FinalTable().visualEffect()
                                        } label: {
                                                Label("MacSidebar.NavigationTitle.JyutpingFinals", systemImage: "rectangle.trailingthird.inset.filled")
                                        }
                                        NavigationLink {
                                                MacToneTableView().visualEffect()
                                        } label: {
                                                Label("MacSidebar.NavigationTitle.JyutpingTones", systemImage: "bell")
                                        }
                                } header: {
                                        Text("MacSidebar.SectionHeader.Jyutping").textCase(nil)
                                }
                                Section {
                                        NavigationLink {
                                                NumbersView().visualEffect()
                                        } label: {
                                                Label("MacSidebar.NavigationTitle.Numbers", systemImage: "number")
                                        }
                                        NavigationLink {
                                                StemsBranchesView().visualEffect()
                                        } label: {
                                                Label("MacSidebar.NavigationTitle.StemsAndBranches", systemImage: "timelapse")
                                        }
                                        NavigationLink {
                                                ChineseZodiacView().visualEffect()
                                        } label: {
                                                Label("MacSidebar.NavigationTitle.ChineseZodiac", systemImage: "hare")
                                        }
                                        NavigationLink {
                                                SolarTermsView().visualEffect()
                                        } label: {
                                                Label("MacSidebar.NavigationTitle.SolarTerms", systemImage: "cloud.sun")
                                        }
                                        NavigationLink {
                                                MacSurnamesView().visualEffect()
                                        } label: {
                                                Label("MacSidebar.NavigationTitle.HundredFamilySurnames", systemImage: "person")
                                        }
                                        NavigationLink {
                                                MacCinZiManView().visualEffect()
                                        } label: {
                                                Label("MacSidebar.NavigationTitle.ThousandCharacterClassic", systemImage: "character")
                                        }
                                        NavigationLink {
                                                MacCantonMetroView().visualEffect()
                                        } label: {
                                                Label("MacSidebar.NavigationTitle.CantonMetro", systemImage: "tram.circle")
                                        }
                                        NavigationLink {
                                                MacFatshanMetroView().visualEffect()
                                        } label: {
                                                Label("MacSidebar.NavigationTitle.FatshanMetro", systemImage: "tram.circle")
                                        }
                                        NavigationLink {
                                                MacShamChunMetroView().visualEffect()
                                        } label: {
                                                Label("MacSidebar.NavigationTitle.ShamChunMetro", systemImage: "tram.circle")
                                        }
                                        NavigationLink {
                                                MacHongKongMTRView().visualEffect()
                                        } label: {
                                                Label("MacSidebar.NavigationTitle.HongKongMTR", systemImage: "tram.circle")
                                        }
                                } header: {
                                        Text("MacSidebar.SectionHeader.Cantonese").textCase(nil)
                                }
                                Section {
                                        NavigationLink {
                                                MacResourcesView().visualEffect()
                                        } label: {
                                                Label("MacSidebar.NavigationTitle.Resources", systemImage: "globe.asia.australia")
                                        }
                                        NavigationLink {
                                                MacAboutView().visualEffect()
                                        } label: {
                                                Label("MacSidebar.NavigationTitle.About", systemImage: "info.circle")
                                        }
                                } header: {
                                        Text("MacSidebar.SectionHeader.About").textCase(nil)
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
                        .navigationTitle("MacContentView.NavigationTitle.Jyutping")
                }
        }
}

#endif
