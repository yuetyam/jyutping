#if os(iOS)

import SwiftUI

struct CantoneseView: View {

        @State private var animationState: Int = 0

        var body: some View {
                NavigationView {
                        List {
                                SearchView(placeholder: "Search Pronunciation", animationState: $animationState)

                                Section {
                                        NavigationLink(destination: IOSExpressionsView()) {
                                                Label("Cantonese Expressions", systemImage: "checkmark.seal")
                                        }
                                        NavigationLink(destination: IOSConfusionView()) {
                                                Label("Simplified Character Confusion", systemImage: "character")
                                        }
                                }

                                Section {
                                        NavigationLink(destination: NumbersView()) {
                                                Label("Numbers", systemImage: "number")
                                        }
                                        NavigationLink(destination: StemsBranchesView()) {
                                                Label("Stems and Branches", systemImage: "timelapse")
                                        }
                                        NavigationLink(destination: ChineseZodiacView()) {
                                                Label("Chinese Zodiac", systemImage: "hare")
                                        }
                                        NavigationLink(destination: SolarTermsView()) {
                                                Label("Solar Terms", systemImage: "cloud.sun")
                                        }
                                        NavigationLink(destination: IOSSurnamesView()) {
                                                Label("Hundred Family Surnames", systemImage: "person")
                                        }
                                        NavigationLink(destination: IOSCinZiManView()) {
                                                Label("Thousand Character Classic", systemImage: "character")
                                        }
                                }
                                Section {
                                        NavigationLink(destination: IOSCantonMetroView()) {
                                                Label("Canton Metro", systemImage: "tram.circle")
                                        }
                                        NavigationLink(destination: IOSFatshanMetroView()) {
                                                Label("Fatshan Metro", systemImage: "tram.circle")
                                        }
                                        NavigationLink(destination: IOSShamChunMetroView()) {
                                                Label("Sham Chun Metro", systemImage: "tram.circle")
                                        }
                                        NavigationLink(destination: IOSHongKongMTRView()) {
                                                Label("Hong Kong MTR", systemImage: "tram.circle")
                                        }
                                }

                                Section {
                                        ExtendedLinkLabel(title: "懶音診療室 - PolyU", footnote: "polyu.edu.hk/cbs/pronunciation", address: "https://www.polyu.edu.hk/cbs/pronunciation")
                                        ExtendedLinkLabel(title: "冚唪唥粵文", footnote: "hambaanglaang.hk", address: "https://hambaanglaang.hk")
                                        ExtendedLinkLabel(title: "迴響", footnote: "resonate.hk", address: "https://resonate.hk")
                                }
                        }
                        .animation(.default, value: animationState)
                        .navigationTitle("Cantonese")
                }
                .navigationViewStyle(.stack)
        }
}

#endif
