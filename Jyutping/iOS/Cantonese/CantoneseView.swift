#if os(iOS)

import SwiftUI

struct CantoneseView: View {

        @State private var animationState: Int = 0

        private let characterImageName: String = {
                if #available(iOS 18.0, *) {
                        return "character.square"
                } else {
                        return "character"
                }
        }()

        var body: some View {
                NavigationView {
                        List {
                                SearchView(placeholder: "TextField.SearchPronunciation", animationState: $animationState)

                                Section {
                                        NavigationLink(destination: IOSExpressionsView()) {
                                                Label("IOSCantoneseTab.LabelTitle.CantoneseExpressions", systemImage: "checkmark.seal")
                                        }
                                        NavigationLink(destination: IOSConfusionView()) {
                                                Label("IOSCantoneseTab.LabelTitle.SimplifiedCharacterConfusion", systemImage: characterImageName)
                                        }
                                }

                                Section {
                                        NavigationLink(destination: NumbersView()) {
                                                Label("IOSCantoneseTab.LabelTitle.Numbers", systemImage: "number")
                                        }
                                        NavigationLink(destination: StemsBranchesView()) {
                                                Label("IOSCantoneseTab.LabelTitle.StemsAndBranches", systemImage: "timelapse")
                                        }
                                        NavigationLink(destination: ChineseZodiacView()) {
                                                Label("IOSCantoneseTab.LabelTitle.ChineseZodiac", systemImage: "hare")
                                        }
                                        NavigationLink(destination: SolarTermsView()) {
                                                Label("IOSCantoneseTab.LabelTitle.SolarTerms", systemImage: "cloud.sun")
                                        }
                                        NavigationLink(destination: IOSHundredFamilySurnamesView()) {
                                                Label("IOSCantoneseTab.LabelTitle.HundredFamilySurnames", systemImage: "person")
                                        }
                                        NavigationLink(destination: IOSThousandCharacterClassicView()) {
                                                Label("IOSCantoneseTab.LabelTitle.ThousandCharacterClassic", systemImage: characterImageName)
                                        }
                                }
                                Section {
                                        NavigationLink(destination: IOSCantonMetroView()) {
                                                Label("IOSCantoneseTab.LabelTitle.CantonMetro", systemImage: "tram.circle")
                                        }
                                        NavigationLink(destination: IOSFatshanMetroView()) {
                                                Label("IOSCantoneseTab.LabelTitle.FatshanMetro", systemImage: "tram.circle")
                                        }
                                        NavigationLink(destination: IOSMacauMetroView()) {
                                                Label("IOSCantoneseTab.LabelTitle.MacauMetro", systemImage: "tram.circle")
                                        }
                                        NavigationLink(destination: IOSTungkunRailTransitView()) {
                                                Label("IOSCantoneseTab.LabelTitle.TungkunRailTransit", systemImage: "tram.circle")
                                        }
                                        NavigationLink(destination: IOSShamChunMetroView()) {
                                                Label("IOSCantoneseTab.LabelTitle.ShamChunMetro", systemImage: "tram.circle")
                                        }
                                        NavigationLink(destination: IOSHongKongMTRView()) {
                                                Label("IOSCantoneseTab.LabelTitle.HongKongMTR", systemImage: "tram.circle")
                                        }
                                }

                                Section {
                                        ExtendedLinkLabel(title: "懶音診療室 - PolyU", footnote: "polyu.edu.hk/cbs/pronunciation", address: "https://www.polyu.edu.hk/cbs/pronunciation")
                                        ExtendedLinkLabel(title: "粵語語氣詞", footnote: "jyutping.org/blog/particles", address: "https://jyutping.org/blog/particles")
                                        ExtendedLinkLabel(title: "CANTONESE.com.hk", footnote: "cantonese.com.hk", address: "https://www.cantonese.com.hk")
                                        ExtendedLinkLabel(title: "中國古詩文精讀", footnote: "classicalchineseliterature.org", address: "https://www.classicalchineseliterature.org")
                                        ExtendedLinkLabel(title: "冚唪唥粵文", footnote: "hambaanglaang.hk", address: "https://hambaanglaang.hk")
                                        ExtendedLinkLabel(title: "迴響", footnote: "resonate.hk", address: "https://resonate.hk")
                                }
                        }
                        .animation(.default, value: animationState)
                        .navigationTitle("IOSTabView.NavigationTitle.Cantonese")
                }
                .navigationViewStyle(.stack)
        }
}

#endif
