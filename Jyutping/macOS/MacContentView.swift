#if os(macOS)

import SwiftUI

struct VisualEffect: NSViewRepresentable {
        func makeNSView(context: Self.Context) -> NSView {
                let view = NSVisualEffectView()
                view.material = .sidebar
                view.blendingMode = .behindWindow
                view.state = .active
                return view
        }
        func updateNSView(_ nsView: NSView, context: Context) { }
}
extension View {
        func visualEffect() -> some View {
                return self.background(VisualEffect())
        }
}

@available(macOS 13.0, *)
struct MacContentView: View {

        @State private var selection: ViewIdentifier = .search

        var body: some View {
                NavigationSplitView {
                        List(selection: $selection) {
                                Section {
                                        Label("MacSidebar.NavigationTitle.InstallInputMethod", systemImage: "laptopcomputer.and.arrow.down").tag(ViewIdentifier.installation)
                                        Label("MacSidebar.NavigationTitle.Introductions", systemImage: "book").tag(ViewIdentifier.introductions)
                                        Label("MacSidebar.NavigationTitle.CantoneseExpressions", systemImage: "checkmark.seal").tag(ViewIdentifier.expressions)
                                        Label("MacSidebar.NavigationTitle.SimplifiedCharacterConfusion", systemImage: "character").tag(ViewIdentifier.confusion)
                                } header: {
                                        Text("MacSidebar.SectionHeader.InputMethod").textCase(nil)
                                }
                                Section {
                                        Label("MacSidebar.NavigationTitle.Search", systemImage: "magnifyingglass").tag(ViewIdentifier.search)
                                        Label("MacSidebar.NavigationTitle.JyutpingInitials", systemImage: "rectangle.leadingthird.inset.filled").tag(ViewIdentifier.initials)
                                        Label("MacSidebar.NavigationTitle.JyutpingFinals", systemImage: "rectangle.trailingthird.inset.filled").tag(ViewIdentifier.finals)
                                        Label("MacSidebar.NavigationTitle.JyutpingTones", systemImage: "bell").tag(ViewIdentifier.tones)
                                } header: {
                                        Text("MacSidebar.SectionHeader.Jyutping").textCase(nil)
                                }
                                Section {
                                        Label("MacSidebar.NavigationTitle.Numbers", systemImage: "number").tag(ViewIdentifier.numbers)
                                        Label("MacSidebar.NavigationTitle.StemsAndBranches", systemImage: "timelapse").tag(ViewIdentifier.stemsBranches)
                                        Label("MacSidebar.NavigationTitle.ChineseZodiac", systemImage: "hare").tag(ViewIdentifier.chineseZodiac)
                                        Label("MacSidebar.NavigationTitle.SolarTerms", systemImage: "cloud.sun").tag(ViewIdentifier.solarTerms)
                                        Label("MacSidebar.NavigationTitle.HundredFamilySurnames", systemImage: "person").tag(ViewIdentifier.surnames)
                                        Label("MacSidebar.NavigationTitle.ThousandCharacterClassic", systemImage: "character").tag(ViewIdentifier.cinZiMan)
                                        Label("MacSidebar.NavigationTitle.CantonMetro", systemImage: "tram.circle").tag(ViewIdentifier.cantonMetro)
                                        Label("MacSidebar.NavigationTitle.FatshanMetro", systemImage: "tram.circle").tag(ViewIdentifier.fatshanMetro)
                                        Label("MacSidebar.NavigationTitle.ShamChunMetro", systemImage: "tram.circle").tag(ViewIdentifier.shamchunMetro)
                                        Label("MacSidebar.NavigationTitle.HongKongMTR", systemImage: "tram.circle").tag(ViewIdentifier.hongkongMTR)
                                } header: {
                                        Text("MacSidebar.SectionHeader.Cantonese").textCase(nil)
                                }
                                Section {
                                        Label("MacSidebar.NavigationTitle.Resources", systemImage: "globe.asia.australia").tag(ViewIdentifier.resources)
                                        Label("MacSidebar.NavigationTitle.About", systemImage: "info.circle").tag(ViewIdentifier.about)
                                } header: {
                                        Text("MacSidebar.SectionHeader.About").textCase(nil)
                                }
                        }
                        .toolbarBackground(Material.ultraThin, for: .windowToolbar)
                        .navigationTitle("MacContentView.NavigationTitle.Jyutping")
                } detail: {
                        switch selection {
                        case .installation:
                                MacInputMethodInstallationView().visualEffect()
                        case .introductions:
                                MacIntroductionsView().visualEffect()
                        case .expressions:
                                MacExpressionsView().visualEffect()
                        case .confusion:
                                MacConfusionView().visualEffect()
                        case .search:
                                MacSearchView().visualEffect()
                        case .initials:
                                InitialTable().visualEffect()
                        case .finals:
                                FinalTable().visualEffect()
                        case .tones:
                                MacToneTableView().visualEffect()
                        case .numbers:
                                NumbersView().visualEffect()
                        case .stemsBranches:
                                StemsBranchesView().visualEffect()
                        case .chineseZodiac:
                                ChineseZodiacView().visualEffect()
                        case .solarTerms:
                                SolarTermsView().visualEffect()
                        case .surnames:
                                MacSurnamesView().visualEffect()
                        case .cinZiMan:
                                MacCinZiManView().visualEffect()
                        case .cantonMetro:
                                MacCantonMetroView().visualEffect()
                        case .fatshanMetro:
                                MacFatshanMetroView().visualEffect()
                        case .shamchunMetro:
                                MacShamChunMetroView().visualEffect()
                        case .hongkongMTR:
                                MacHongKongMTRView().visualEffect()
                        case .resources:
                                MacResourcesView().visualEffect()
                        case .about:
                                MacAboutView().visualEffect()
                        }
                }
        }
}

private enum ViewIdentifier: Int, Hashable, Identifiable {

        case installation
        case introductions
        case expressions
        case confusion

        case search
        case initials
        case finals
        case tones

        case numbers
        case stemsBranches
        case chineseZodiac
        case solarTerms
        case surnames
        case cinZiMan
        case cantonMetro
        case fatshanMetro
        case shamchunMetro
        case hongkongMTR

        case resources
        case about

        var id: Int {
                return rawValue
        }
}

#endif
