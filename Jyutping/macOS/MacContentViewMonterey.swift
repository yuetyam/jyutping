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
                                                Label("Install Input Method", systemImage: "laptopcomputer.and.arrow.down")
                                        }
                                        NavigationLink {
                                                MacIntroductionsView().visualEffect()
                                        } label: {
                                                Label("Introductions", systemImage: "book")
                                        }
                                        NavigationLink {
                                                MacExpressionsView().visualEffect()
                                        } label: {
                                                Label("Cantonese Expressions", systemImage: "checkmark.seal")
                                        }
                                        NavigationLink {
                                                MacConfusionView().visualEffect()
                                        } label: {
                                                Label("Simplified Character Confusion", systemImage: "character")
                                        }
                                } header: {
                                        Text("Input Method").textCase(nil)
                                }
                                Section {
                                        NavigationLink(destination: MacSearchView().visualEffect(), isActive: $isMacSearchViewActive) {
                                                Label("Search", systemImage: "magnifyingglass")
                                        }
                                        NavigationLink {
                                                InitialTable().visualEffect()
                                        } label: {
                                                Label("Initials", systemImage: "rectangle.leadingthird.inset.filled")
                                        }
                                        NavigationLink {
                                                FinalTable().visualEffect()
                                        } label: {
                                                Label("Finals", systemImage: "rectangle.trailingthird.inset.filled")
                                        }
                                        NavigationLink {
                                                MacToneTableView().visualEffect()
                                        } label: {
                                                Label("Tones", systemImage: "bell")
                                        }
                                } header: {
                                        Text("MacSidebar.Header.Jyutping").textCase(nil)
                                }
                                Section {
                                        NavigationLink {
                                                NumbersView().visualEffect()
                                        } label: {
                                                Label("Numbers", systemImage: "number")
                                        }
                                        NavigationLink {
                                                StemsBranchesView().visualEffect()
                                        } label: {
                                                Label("Stems and Branches", systemImage: "timelapse")
                                        }
                                        NavigationLink {
                                                ChineseZodiacView().visualEffect()
                                        } label: {
                                                Label("Chinese Zodiac", systemImage: "hare")
                                        }
                                        NavigationLink {
                                                SolarTermsView().visualEffect()
                                        } label: {
                                                Label("Solar Terms", systemImage: "cloud.sun")
                                        }
                                        NavigationLink {
                                                MacSurnamesView().visualEffect()
                                        } label: {
                                                Label("title.surnames", systemImage: "person")
                                        }
                                        NavigationLink {
                                                MacCinZiManView().visualEffect()
                                        } label: {
                                                Label("title.characters", systemImage: "character")
                                        }
                                        NavigationLink {
                                                MacCantonMetroView().visualEffect()
                                        } label: {
                                                Label("Canton Metro", systemImage: "tram.circle")
                                        }
                                        NavigationLink {
                                                MacFatshanMetroView().visualEffect()
                                        } label: {
                                                Label("Fatshan Metro", systemImage: "tram.circle")
                                        }
                                        NavigationLink {
                                                MacShamChunMetroView().visualEffect()
                                        } label: {
                                                Label("Sham Chun Metro", systemImage: "tram.circle")
                                        }
                                        NavigationLink {
                                                MacHongKongMTRView().visualEffect()
                                        } label: {
                                                Label("Hong Kong MTR", systemImage: "tram.circle")
                                        }
                                } header: {
                                        Text("MacSidebar.Header.Cantonese").textCase(nil)
                                }
                                Section {
                                        NavigationLink {
                                                MacResourcesView().visualEffect()
                                        } label: {
                                                Label("Resources", systemImage: "globe.asia.australia")
                                        }
                                        NavigationLink {
                                                MacAboutView().visualEffect()
                                        } label: {
                                                Label("MacAboutView.NavigationTitle.About", systemImage: "info.circle")
                                        }
                                } header: {
                                        Text("MacSidebar.Header.About").textCase(nil)
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
