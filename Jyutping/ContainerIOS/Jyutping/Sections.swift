import SwiftUI

struct TableLinksView: View {
        var body: some View {
                NavigationLink {
                        if #available(iOS 15.0, *) {
                                InitialsTable().textSelection(.enabled)
                        } else {
                                InitialsTable()
                        }
                } label: {
                        Label("Jyutping Initials", systemImage: "tablecells")
                }

                NavigationLink {
                        if #available(iOS 15.0, *) {
                                FinalsTable().textSelection(.enabled)
                        } else {
                                FinalsTable()
                        }
                } label: {
                        Label("Jyutping Finals", systemImage: "tablecells")
                }

                NavigationLink {
                        if #available(iOS 15.0, *) {
                                TonesTable().textSelection(.enabled)
                        } else {
                                TonesTable()
                        }
                } label: {
                        Label("Jyutping Tones", systemImage: "tablecells")
                }
        }
}

struct SearchLinksView: View {
        private let icon: String = "doc.text.magnifyingglass"
        var body: some View {
                ExtendedLinkLabel(icon: icon, title: "粵音資料集叢", footnote: "jyut.net", address: "https://jyut.net")
                ExtendedLinkLabel(icon: icon, title: "粵典", footnote: "words.hk", address: "https://words.hk")
                ExtendedLinkLabel(icon: icon, title: "粵語審音配詞字庫", footnote: "humanum.arts.cuhk.edu.hk/Lexis/lexi-can", address: "https://humanum.arts.cuhk.edu.hk/Lexis/lexi-can")
                ExtendedLinkLabel(icon: icon, title: "泛粵大典", footnote: "www.jyutdict.org", address: "https://www.jyutdict.org")
                ExtendedLinkLabel(icon: icon, title: "羊羊粵語", footnote: "shyyp.net/hant", address: "https://shyyp.net/hant")
        }
}

struct JyutpingResourcesLinksView: View {
        var body: some View {
                ExtendedLinkLabel(text: Text("Jyutping"), footnote: "jyutping.org", address: "https://jyutping.org")
                ExtendedLinkLabel(text: Text("Jyutping - LSHK"), footnote: "www.lshk.org/jyutping", address: "https://www.lshk.org/jyutping")
                ExtendedLinkLabel(title: "粵語拼音速遞 - CUHK", footnote: "ilc.cuhk.edu.hk/workshop/Chinese/Cantonese/Romanization", address: "https://www.ilc.cuhk.edu.hk/workshop/Chinese/Cantonese/Romanization")
        }
}

struct CantoneseResourcesLinksView: View {
        var body: some View {
                ExtendedLinkLabel(title: "冚唪唥粵文", footnote: "hambaanglaang.hk", address: "https://hambaanglaang.hk")
                ExtendedLinkLabel(title: "學識 Hok6", footnote: "www.hok6.com", address: "https://www.hok6.com")
                ExtendedLinkLabel(title: "迴響", footnote: "resonate.hk", address: "https://resonate.hk")
        }
}
