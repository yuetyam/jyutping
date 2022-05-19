import SwiftUI

struct ResourcesView: View {

        private let searchIcon: String = "doc.text.magnifyingglass"
        private let linkIcon: String = "link.circle"

        var body: some View {
                ScrollView {
                        LazyVStack(spacing: 16) {
                                VStack {
                                        LinkView(icon: searchIcon, title: "粵音資料集叢", url: "https://jyut.net")
                                        LinkView(icon: searchIcon, title: "粵典", url: "https://words.hk")
                                        LinkView(icon: searchIcon, title: "粵語審音配詞字庫", url: "https://humanum.arts.cuhk.edu.hk/Lexis/lexi-can")
                                        LinkView(icon: searchIcon, title: "泛粵大典", url: "https://www.jyutdict.org")
                                        LinkView(icon: searchIcon, title: "羊羊粵語", url: "https://shyyp.net/hant")
                                }
                                .block()

                                VStack {
                                        LinkView(icon: linkIcon, title: "粵拼", url: "https://jyutping.org")
                                        LinkView(icon: linkIcon, title: "粵拼 - LSHK", url: "https://www.lshk.org/jyutping")
                                        LinkView(icon: linkIcon, title: "粵語拼音速遞 - CUHK", url: "https://www.ilc.cuhk.edu.hk/workshop/Chinese/Cantonese/Romanization")
                                }
                                .block()

                                VStack {
                                        LinkView(icon: linkIcon, title: "迴響", url: "https://resonate.hk")
                                        LinkView(icon: linkIcon, title: "冚唪唥粵文", url: "https://hambaanglaang.hk")
                                        LinkView(icon: linkIcon, title: "學識 Hok6", url: "https://www.hok6.com")
                                }
                                .block()
                        }
                        .padding()
                }
                .navigationTitle("Resources")
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
                        Text(verbatim: url)
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                                .font(.subheadline.monospaced())
                                .textSelection(.enabled)
                        Spacer()
                }
        }
}

