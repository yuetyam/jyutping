#if os(macOS)

import SwiftUI

struct MacResourcesView: View {

        private let searchIcon: String = "doc.text.magnifyingglass"
        private let globeIcon: String = "globe.asia.australia"

        var body: some View {
                ScrollView {
                        LazyVStack(spacing: 16) {
                                VStack {
                                        LinkView(icon: searchIcon, title: "粵音資料集叢", url: "https://jyut.net")
                                        LinkView(icon: searchIcon, title: "粵典", url: "https://words.hk")
                                        LinkView(icon: searchIcon, title: "粵語審音配詞字庫", url: "https://humanum.arts.cuhk.edu.hk/Lexis/lexi-can")
                                        LinkView(icon: searchIcon, title: "羊羊粵語", url: "https://shyyp.net/hant")
                                }
                                .block()

                                VStack {
                                        LinkView(icon: globeIcon, title: "粵拼 Jyutping", url: "https://jyutping.org")
                                        LinkView(icon: globeIcon, title: "粵語拼音速遞 - CUHK", url: "https://www.ilc.cuhk.edu.hk/workshop/Chinese/Cantonese/Romanization")
                                        LinkView(icon: globeIcon, title: "Zidou - 粵拼版 Wordle", url: "https://chaaklau.github.io/zidou")
                                }
                                .block()

                                VStack {
                                        LinkView(icon: globeIcon, title: "懶音診療室 - PolyU", url: "https://www.polyu.edu.hk/cbs/pronunciation")
                                        LinkView(icon: globeIcon, title: "中國古詩文精讀", url: "https://www.classicalchineseliterature.org")
                                        LinkView(icon: globeIcon, title: "冚唪唥粵文", url: "https://hambaanglaang.hk")
                                        LinkView(icon: globeIcon, title: "迴響", url: "https://resonate.hk")
                                }
                                .block()
                        }
                        .padding()
                }
                .navigationTitle("MacSidebar.NavigationTitle.Resources")
        }
}


private struct LinkView: View {

        let icon: String
        let title: String
        let url: String

        var body: some View {
                HStack(spacing: 16) {
                        Link(destination: URL(string: url)!) {
                                HStack(spacing: 16) {
                                        Image(systemName: icon)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 16, height: 16)
                                        Text(verbatim: title)
                                                .font(.master)
                                }
                        }
                        .foregroundStyle(Color.accentColor)
                        Text(verbatim: url)
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                                .font(.subheadline.monospaced())
                                .textSelection(.enabled)
                        Spacer()
                }
        }
}

#endif
