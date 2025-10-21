#if os(iOS)

import SwiftUI

struct JyutpingView: View {

        @State private var animationState: Int = 0
        private let searchIcon: String = "doc.text.magnifyingglass"

        var body: some View {
                NavigationView {
                        List {
                                SearchView(placeholder: "TextField.SearchPronunciation", animationState: $animationState)

                                Section {
                                        NavigationLink(destination: IOSJyutpingInitialTable()) {
                                                Label("IOSJyutpingTab.LabelTitle.JyutpingInitials", systemImage: "rectangle.leadingthird.inset.filled")
                                        }
                                        NavigationLink(destination: IOSJyutpingFinalTable()) {
                                                Label("IOSJyutpingTab.LabelTitle.JyutpingFinals", systemImage: "rectangle.trailingthird.inset.filled")
                                        }
                                        NavigationLink(destination: IOSJyutpingToneTable()) {
                                                Label("IOSJyutpingTab.LabelTitle.JyutpingTones", systemImage: "bell")
                                        }
                                }

                                Section {
                                        ExtendedLinkLabel(icon: searchIcon, title: "粵音資料集叢", footnote: "jyut.net", address: "https://jyut.net")
                                        ExtendedLinkLabel(icon: searchIcon, title: "粵典", footnote: "words.hk", address: "https://words.hk")
                                        ExtendedLinkLabel(icon: searchIcon, title: "粵語審音配詞字庫", footnote: "humanum.arts.cuhk.edu.hk/Lexis/lexi-can", address: "https://humanum.arts.cuhk.edu.hk/Lexis/lexi-can")
                                        ExtendedLinkLabel(icon: searchIcon, title: "羊羊粵語", footnote: "shyyp.net/hant", address: "https://shyyp.net/hant")
                                }

                                Section {
                                        ExtendedLinkLabel(title: "粵拼 Jyutping", footnote: "jyutping.org", address: "https://jyutping.org")
                                        ExtendedLinkLabel(title: "粵語拼音速遞 - CUHK", footnote: "ilc.cuhk.edu.hk/workshop/Chinese/Cantonese/Romanization", address: "https://www.ilc.cuhk.edu.hk/workshop/Chinese/Cantonese/Romanization")
                                        ExtendedLinkLabel(title: "粵語網路課堂 - CUHK", footnote: "ilc.cuhk.edu.hk/workshop/Chinese/Cantonese/OnlineTutorial", address: "https://www.ilc.cuhk.edu.hk/workshop/Chinese/Cantonese/OnlineTutorial")
                                        ExtendedLinkLabel(title: "翻轉粵語教室 - PolyU", footnote: "polyu.edu.hk/clc/cantonese/home", address: "https://www.polyu.edu.hk/clc/cantonese/home")
                                        ExtendedLinkLabel(title: "Zidou - 粵拼版 Wordle", footnote: "chaaklau.github.io/zidou", address: "https://chaaklau.github.io/zidou")
                                        ExtendedLinkLabel(title: "六合 | 粵拼版 Wordle", footnote: "lukhap.jonathanl.dev", address: "https://lukhap.jonathanl.dev")
                                }
                        }
                        .animation(.default, value: animationState)
                        .navigationTitle("IOSTabView.NavigationTitle.Jyutping")
                }
                .navigationViewStyle(.stack)
        }
}

#endif
