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
                                                MacInstallInputMethodView().applyVisualEffect()
                                        } label: {
                                                Label("MacSidebar.NavigationTitle.InstallInputMethod", systemImage: "laptopcomputer.and.arrow.down")
                                        }
                                        NavigationLink {
                                                MacIntroductionsView().applyVisualEffect()
                                        } label: {
                                                Label("MacSidebar.NavigationTitle.Introductions", systemImage: "book")
                                        }
                                        NavigationLink {
                                                MacExpressionsView().applyVisualEffect()
                                        } label: {
                                                Label("MacSidebar.NavigationTitle.CantoneseExpressions", systemImage: "checkmark.seal")
                                        }
                                        NavigationLink {
                                                MacConfusionView().applyVisualEffect()
                                        } label: {
                                                Label("MacSidebar.NavigationTitle.SimplifiedCharacterConfusion", systemImage: "character")
                                        }
                                } header: {
                                        Text("MacSidebar.SectionHeader.InputMethod").textCase(nil)
                                }
                                Section {
                                        NavigationLink(destination: MacSearchView().applyVisualEffect(), isActive: $isMacSearchViewActive) {
                                                Label("MacSidebar.NavigationTitle.Search", systemImage: "magnifyingglass")
                                        }
                                        NavigationLink {
                                                InitialTable().applyVisualEffect()
                                        } label: {
                                                Label("MacSidebar.NavigationTitle.JyutpingInitials", systemImage: "rectangle.leadingthird.inset.filled")
                                        }
                                        NavigationLink {
                                                FinalTable().applyVisualEffect()
                                        } label: {
                                                Label("MacSidebar.NavigationTitle.JyutpingFinals", systemImage: "rectangle.trailingthird.inset.filled")
                                        }
                                        NavigationLink {
                                                MacToneTableView().applyVisualEffect()
                                        } label: {
                                                Label("MacSidebar.NavigationTitle.JyutpingTones", systemImage: "bell")
                                        }
                                } header: {
                                        Text("MacSidebar.SectionHeader.Jyutping").textCase(nil)
                                }
                                Section {
                                        NavigationLink {
                                                NumbersView().applyVisualEffect()
                                        } label: {
                                                Label("MacSidebar.NavigationTitle.Numbers", systemImage: "number")
                                        }
                                        NavigationLink {
                                                StemsBranchesView().applyVisualEffect()
                                        } label: {
                                                Label("MacSidebar.NavigationTitle.StemsAndBranches", systemImage: "timelapse")
                                        }
                                        NavigationLink {
                                                ChineseZodiacView().applyVisualEffect()
                                        } label: {
                                                Label("MacSidebar.NavigationTitle.ChineseZodiac", systemImage: "hare")
                                        }
                                        NavigationLink {
                                                SolarTermsView().applyVisualEffect()
                                        } label: {
                                                Label("MacSidebar.NavigationTitle.SolarTerms", systemImage: "cloud.sun")
                                        }
                                        NavigationLink {
                                                MacSurnamesView().applyVisualEffect()
                                        } label: {
                                                Label("MacSidebar.NavigationTitle.HundredFamilySurnames", systemImage: "person")
                                        }
                                        NavigationLink {
                                                MacCinZiManView().applyVisualEffect()
                                        } label: {
                                                Label("MacSidebar.NavigationTitle.ThousandCharacterClassic", systemImage: "character")
                                        }
                                        NavigationLink {
                                                MacCantonMetroView().applyVisualEffect()
                                        } label: {
                                                Label("MacSidebar.NavigationTitle.CantonMetro", systemImage: "tram.circle")
                                        }
                                        NavigationLink {
                                                MacFatshanMetroView().applyVisualEffect()
                                        } label: {
                                                Label("MacSidebar.NavigationTitle.FatshanMetro", systemImage: "tram.circle")
                                        }
                                        NavigationLink {
                                                MacShamChunMetroView().applyVisualEffect()
                                        } label: {
                                                Label("MacSidebar.NavigationTitle.ShamChunMetro", systemImage: "tram.circle")
                                        }
                                        NavigationLink {
                                                MacHongKongMTRView().applyVisualEffect()
                                        } label: {
                                                Label("MacSidebar.NavigationTitle.HongKongMTR", systemImage: "tram.circle")
                                        }
                                } header: {
                                        Text("MacSidebar.SectionHeader.Cantonese").textCase(nil)
                                }
                                Section {
                                        NavigationLink {
                                                MacResourcesView().applyVisualEffect()
                                        } label: {
                                                Label("MacSidebar.NavigationTitle.Resources", systemImage: "globe.asia.australia")
                                        }
                                        NavigationLink {
                                                MacAboutView().applyVisualEffect()
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
