#if os(macOS)

import SwiftUI

@available(macOS 13.0, *)
struct MacContentView: View {

        @State private var selection: ViewIdentifier = .search

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
                                        Label("MacSidebar.NavigationTitle.InstallInputMethod", systemImage: "sparkles").tag(ViewIdentifier.installation)
                                        Label("MacSidebar.NavigationTitle.Introductions", systemImage: "book").tag(ViewIdentifier.introductions)
                                        Label("MacSidebar.NavigationTitle.CantoneseExpressions", systemImage: "checkmark.seal").tag(ViewIdentifier.expressions)
                                        Label("MacSidebar.NavigationTitle.SimplifiedCharacterConfusion", systemImage: characterImageName).tag(ViewIdentifier.confusion)
                                } header: {
                                        Text("MacSidebar.SectionHeader.InputMethod").textCase(nil).font(.copilot)
                                }
                                .font(.master)
                                Section {
                                        Label("MacSidebar.NavigationTitle.Search", systemImage: "magnifyingglass").tag(ViewIdentifier.search)
                                        Label("MacSidebar.NavigationTitle.JyutpingInitials", systemImage: "rectangle.leadingthird.inset.filled").tag(ViewIdentifier.initials)
                                        Label("MacSidebar.NavigationTitle.JyutpingFinals", systemImage: "rectangle.trailingthird.inset.filled").tag(ViewIdentifier.finals)
                                        Label("MacSidebar.NavigationTitle.JyutpingTones", systemImage: "bell").tag(ViewIdentifier.tones)
                                } header: {
                                        Text("MacSidebar.SectionHeader.Jyutping").textCase(nil).font(.copilot)
                                }
                                .font(.master)
                                Section {
                                        Label("MacSidebar.NavigationTitle.Numbers", systemImage: "number").tag(ViewIdentifier.numbers)
                                        Label("MacSidebar.NavigationTitle.StemsAndBranches", systemImage: "timelapse").tag(ViewIdentifier.stemsBranches)
                                        Label("MacSidebar.NavigationTitle.ChineseZodiac", systemImage: "hare").tag(ViewIdentifier.chineseZodiac)
                                        Label("MacSidebar.NavigationTitle.SolarTerms", systemImage: "cloud.sun").tag(ViewIdentifier.solarTerms)
                                        Label("MacSidebar.NavigationTitle.HundredFamilySurnames", systemImage: "person").tag(ViewIdentifier.surnames)
                                        Label("MacSidebar.NavigationTitle.ThousandCharacterClassic", systemImage: characterImageName).tag(ViewIdentifier.cinZiMan)
                                } header: {
                                        Text("MacSidebar.SectionHeader.Cantonese").textCase(nil).font(.copilot)
                                }
                                .font(.master)
                                Section {
                                        Label("MacSidebar.NavigationTitle.CantonMetro", systemImage: "tram.circle").tag(ViewIdentifier.cantonMetro)
                                        Label("MacSidebar.NavigationTitle.FatshanMetro", systemImage: "tram.circle").tag(ViewIdentifier.fatshanMetro)
                                        Label("MacSidebar.NavigationTitle.MacauMetro", systemImage: "tram.circle").tag(ViewIdentifier.macauMetro)
                                        Label("MacSidebar.NavigationTitle.TungkunRailTransit", systemImage: "tram.circle").tag(ViewIdentifier.tungkunRailTransit)
                                        Label("MacSidebar.NavigationTitle.ShamChunMetro", systemImage: "tram.circle").tag(ViewIdentifier.shamchunMetro)
                                        Label("MacSidebar.NavigationTitle.HongKongMTR", systemImage: "tram.circle").tag(ViewIdentifier.hongkongMTR)
                                } header: {
                                        Text("MacSidebar.SectionHeader.Metro").textCase(nil).font(.copilot)
                                }
                                .font(.master)
                                Section {
                                        Label("MacSidebar.NavigationTitle.Resources", systemImage: "globe.asia.australia").tag(ViewIdentifier.resources)
                                        Label("MacSidebar.NavigationTitle.About", systemImage: "info.circle").tag(ViewIdentifier.about)
                                } header: {
                                        Text("MacSidebar.SectionHeader.About").textCase(nil).font(.copilot)
                                }
                                .font(.master)
                        }
                        .navigationTitle("MacContentView.NavigationTitle.Jyutping")
                        .toolbarBackground(Material.ultraThin, for: .windowToolbar)
                        .onReceive(NotificationCenter.default.publisher(for: .focusSearch)) { _ in
                                selection = .search
                        }
                        .onReceive(NotificationCenter.default.publisher(for: .openAbout)) { _ in
                                selection = .about
                        }
                } detail: {
                        switch selection {
                        case .installation:
                                MacInputMethodView()
                        case .introductions:
                                MacIntroductionsView()
                        case .expressions:
                                MacExpressionsView()
                        case .confusion:
                                MacConfusionView()
                        case .search:
                                MacSearchView()
                        case .initials:
                                MacJyutpingInitialTable()
                        case .finals:
                                MacJyutpingFinalTable()
                        case .tones:
                                MacJyutpingToneTable()
                        case .numbers:
                                NumbersView()
                        case .stemsBranches:
                                StemsBranchesView()
                        case .chineseZodiac:
                                ChineseZodiacView()
                        case .solarTerms:
                                SolarTermsView()
                        case .surnames:
                                MacHundredFamilySurnamesView()
                        case .cinZiMan:
                                MacThousandCharacterClassicView()
                        case .cantonMetro:
                                MacCantonMetroView()
                        case .fatshanMetro:
                                MacFatshanMetroView()
                        case .macauMetro:
                                MacMacauMetroView()
                        case .tungkunRailTransit:
                                MacTungkunRailTransitView()
                        case .shamchunMetro:
                                MacShamChunMetroView()
                        case .hongkongMTR:
                                MacHongKongMTRView()
                        case .resources:
                                MacResourcesView()
                        case .about:
                                MacAboutView()
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
        case macauMetro
        case tungkunRailTransit
        case shamchunMetro
        case hongkongMTR

        case resources
        case about

        var id: Int {
                return rawValue
        }
}

#endif
