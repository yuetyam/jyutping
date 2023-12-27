#if os(iOS)

import SwiftUI

struct JyutpingView: View {

        @State private var animationState: Int = 0
        private let searchIcon: String = "doc.text.magnifyingglass"

        var body: some View {
                NavigationView {
                        List {
                                SearchView(placeholder: "Search Pronunciation", animationState: $animationState)

                                Section {
                                        NavigationLink(destination: InitialTable()) {
                                                Label("Jyutping Initials", systemImage: "rectangle.leadingthird.inset.filled")
                                        }
                                        NavigationLink(destination: FinalTable()) {
                                                Label("Jyutping Finals", systemImage: "rectangle.trailingthird.inset.filled")
                                        }
                                        NavigationLink(destination: IOSToneTableView()) {
                                                Label("Jyutping Tones", systemImage: "bell")
                                        }
                                }

                                Section {
                                        ExtendedLinkLabel(icon: searchIcon, title: "粵音資料集叢", footnote: "jyut.net", address: "https://jyut.net")
                                        ExtendedLinkLabel(icon: searchIcon, title: "粵典", footnote: "words.hk", address: "https://words.hk")
                                        ExtendedLinkLabel(icon: searchIcon, title: "粵語審音配詞字庫", footnote: "humanum.arts.cuhk.edu.hk/Lexis/lexi-can", address: "https://humanum.arts.cuhk.edu.hk/Lexis/lexi-can")
                                        ExtendedLinkLabel(icon: searchIcon, title: "泛粵典", footnote: "www.jyutdict.org", address: "https://www.jyutdict.org")
                                }

                                Section {
                                        ExtendedLinkLabel(title: "粵拼 Jyutping", footnote: "jyutping.org", address: "https://jyutping.org")
                                        ExtendedLinkLabel(title: "粵語拼音速遞 - CUHK", footnote: "ilc.cuhk.edu.hk/workshop/Chinese/Cantonese/Romanization", address: "https://www.ilc.cuhk.edu.hk/workshop/Chinese/Cantonese/Romanization")
                                }
                        }
                        .animation(.default, value: animationState)
                        .navigationTitle("Jyutping")
                }
                .navigationViewStyle(.stack)
        }
}

#endif
