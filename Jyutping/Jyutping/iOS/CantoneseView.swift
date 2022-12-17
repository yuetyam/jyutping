#if os(iOS)

import SwiftUI

struct CantoneseView: View {
        var body: some View {
                NavigationView {
                        List {
                                Section {
                                        NavigationLink(destination: StemsBranchesView()) {
                                                Label("Stems and Branches", systemImage: "timelapse")
                                        }
                                        NavigationLink(destination: ChineseZodiacView()) {
                                                Label("Chinese Zodiac", systemImage: "hare")
                                        }
                                        NavigationLink(destination: SolarTermsView()) {
                                                Label("Solar Terms", systemImage: "cloud.sun")
                                        }
                                } header: {
                                        Text("Materials").textCase(nil)
                                }

                                Section {
                                        ExtendedLinkLabel(title: "冚唪唥粵文", footnote: "hambaanglaang.hk", address: "https://hambaanglaang.hk")
                                        ExtendedLinkLabel(title: "學識 Hok6", footnote: "www.hok6.com", address: "https://www.hok6.com")
                                        ExtendedLinkLabel(title: "迴響", footnote: "resonate.hk", address: "https://resonate.hk")
                                } header: {
                                        Text("Cantonese Resources").textCase(nil)
                                }
                        }
                        .navigationTitle("Cantonese")
                }
                .navigationViewStyle(.stack)
        }
}

#endif
