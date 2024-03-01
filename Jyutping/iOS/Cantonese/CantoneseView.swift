#if os(iOS)

import SwiftUI

struct CantoneseView: View {

        @State private var animationState: Int = 0

        var body: some View {
                NavigationView {
                        List {
                                SearchView(placeholder: "TextField.SearchPronunciation", animationState: $animationState)

                                Section {
                                        NavigationLink(destination: IOSExpressionsView()) {
                                                Label("IOSCantoneseTab.LabelTitle.CantoneseExpressions", systemImage: "checkmark.seal")
                                        }
                                        NavigationLink(destination: IOSConfusionView()) {
                                                Label("IOSCantoneseTab.LabelTitle.SimplifiedCharacterConfusion", systemImage: "character")
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
                                        NavigationLink(destination: IOSSurnamesView()) {
                                                Label("IOSCantoneseTab.LabelTitle.HundredFamilySurnames", systemImage: "person")
                                        }
                                        NavigationLink(destination: IOSCinZiManView()) {
                                                Label("IOSCantoneseTab.LabelTitle.ThousandCharacterClassic", systemImage: "character")
                                        }
                                }
                                Section {
                                        NavigationLink(destination: IOSCantonMetroView()) {
                                                Label("IOSCantoneseTab.LabelTitle.CantonMetro", systemImage: "tram.circle")
                                        }
                                        NavigationLink(destination: IOSFatshanMetroView()) {
                                                Label("IOSCantoneseTab.LabelTitle.FatshanMetro", systemImage: "tram.circle")
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
