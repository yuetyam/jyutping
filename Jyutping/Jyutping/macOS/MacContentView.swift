#if os(macOS)

import SwiftUI

struct VisualEffect: NSViewRepresentable {
        // https://developer.apple.com/forums/thread/694837
        func makeNSView(context: Self.Context) -> NSView {
                let view = NSVisualEffectView()
                view.state = NSVisualEffectView.State.active
                return view
        }
        func updateNSView(_ nsView: NSView, context: Context) { }
}

@available(macOS 13.0, *)
struct MacContentView: View {

        @State private var selection: ViewIdentifier = .search
        private let visualEffect: VisualEffect = VisualEffect()

        var body: some View {
                NavigationSplitView {
                        List(selection: $selection) {
                                Section {
                                        Label("Install Input Method", systemImage: "laptopcomputer.and.arrow.down").tag(ViewIdentifier.installation)
                                        Label("Introductions", systemImage: "book").tag(ViewIdentifier.introductions)
                                        Label("Cantonese Expressions", systemImage: "text.quote").tag(ViewIdentifier.expressions)
                                } header: {
                                        Text("Input Method").textCase(nil)
                                }
                                Section {
                                        Label("Search", systemImage: "magnifyingglass").tag(ViewIdentifier.search)
                                        Label("Initials", systemImage: "rectangle.leadingthird.inset.filled").tag(ViewIdentifier.initials)
                                        Label("Finals", systemImage: "rectangle.trailingthird.inset.filled").tag(ViewIdentifier.finals)
                                        Label("Tones", systemImage: "bell").tag(ViewIdentifier.tones)
                                } header: {
                                        Text("Jyutping").textCase(nil)
                                }
                                Section {
                                        Label("Numbers", systemImage: "number").tag(ViewIdentifier.numbers)
                                        Label("Stems and Branches", systemImage: "timelapse").tag(ViewIdentifier.stemsBranches)
                                        Label("Chinese Zodiac", systemImage: "hare").tag(ViewIdentifier.chineseZodiac)
                                        Label("Solar Terms", systemImage: "cloud.sun").tag(ViewIdentifier.solarTerms)
                                        Label("Resources", systemImage: "globe.asia.australia").tag(ViewIdentifier.resources)
                                } header: {
                                        Text("Materials").textCase(nil)
                                }
                                Section {
                                        Label("About", systemImage: "info.circle").tag(ViewIdentifier.about)
                                } header: {
                                        Text("About").textCase(nil)
                                }
                        }
                        .toolbarBackground(Material.ultraThin, for: .windowToolbar)
                        .navigationTitle("Jyutping")
                } detail: {
                        switch selection {
                        case .installation:
                                MacInputMethodInstallationView().background(visualEffect)
                        case .introductions:
                                MacIntroductionsView().background(visualEffect)
                        case .expressions:
                                MacExpressionsView().background(visualEffect)
                        case .search:
                                MacSearchView().background(visualEffect)
                        case .initials:
                                InitialsTable().background(visualEffect)
                        case .finals:
                                FinalsTable().background(visualEffect)
                        case .tones:
                                TonesTable().background(visualEffect)
                        case .numbers:
                                NumbersView().background(visualEffect)
                        case .stemsBranches:
                                StemsBranchesView().background(visualEffect)
                        case .chineseZodiac:
                                ChineseZodiacView().background(visualEffect)
                        case .solarTerms:
                                SolarTermsView().background(visualEffect)
                        case .resources:
                                MacResourcesView().background(visualEffect)
                        case .about:
                                MacAboutView().background(visualEffect)
                        }
                }
        }
}


private enum ViewIdentifier: Int, Hashable, Identifiable {

        case installation
        case introductions
        case expressions

        case search
        case initials
        case finals
        case tones

        case numbers
        case stemsBranches
        case chineseZodiac
        case solarTerms
        case resources

        case about

        var id: Int {
                return rawValue
        }
}

#endif
