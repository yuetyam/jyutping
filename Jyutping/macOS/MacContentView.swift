#if os(macOS)

import SwiftUI

struct VisualEffectView: NSViewRepresentable {
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
        func applyVisualEffect() -> some View {
                return self.background(VisualEffectView())
        }
}

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
                                        Label("MacSidebar.NavigationTitle.CantonMetro", systemImage: "tram.circle").tag(ViewIdentifier.cantonMetro)
                                        Label("MacSidebar.NavigationTitle.FatshanMetro", systemImage: "tram.circle").tag(ViewIdentifier.fatshanMetro)
                                        Label("MacSidebar.NavigationTitle.ShamChunMetro", systemImage: "tram.circle").tag(ViewIdentifier.shamchunMetro)
                                        Label("MacSidebar.NavigationTitle.HongKongMTR", systemImage: "tram.circle").tag(ViewIdentifier.hongkongMTR)
                                } header: {
                                        Text("MacSidebar.SectionHeader.Cantonese").textCase(nil).font(.copilot)
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
                        .toolbarBackground(Material.ultraThin, for: .windowToolbar)
                        .navigationTitle("MacContentView.NavigationTitle.Jyutping")
                } detail: {
                        switch selection {
                        case .installation:
                                MacInputMethodView().applyVisualEffect()
                        case .introductions:
                                MacIntroductionsView().applyVisualEffect()
                        case .expressions:
                                MacExpressionsView().applyVisualEffect()
                        case .confusion:
                                MacConfusionView().applyVisualEffect()
                        case .search:
                                MacSearchView().applyVisualEffect()
                        case .initials:
                                MacJyutpingInitialTable().applyVisualEffect()
                        case .finals:
                                MacJyutpingFinalTable().applyVisualEffect()
                        case .tones:
                                MacJyutpingToneTable().applyVisualEffect()
                        case .numbers:
                                NumbersView().applyVisualEffect()
                        case .stemsBranches:
                                StemsBranchesView().applyVisualEffect()
                        case .chineseZodiac:
                                ChineseZodiacView().applyVisualEffect()
                        case .solarTerms:
                                SolarTermsView().applyVisualEffect()
                        case .surnames:
                                MacHundredFamilySurnamesView().applyVisualEffect()
                        case .cinZiMan:
                                MacThousandCharacterClassicView().applyVisualEffect()
                        case .cantonMetro:
                                MacCantonMetroView().applyVisualEffect()
                        case .fatshanMetro:
                                MacFatshanMetroView().applyVisualEffect()
                        case .shamchunMetro:
                                MacShamChunMetroView().applyVisualEffect()
                        case .hongkongMTR:
                                MacHongKongMTRView().applyVisualEffect()
                        case .resources:
                                MacResourcesView().applyVisualEffect()
                        case .about:
                                MacAboutView().applyVisualEffect()
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
