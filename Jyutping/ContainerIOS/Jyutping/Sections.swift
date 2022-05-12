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
        var body: some View {
                LinkSafariView(url: URL(string: "https://jyut.net")!) {
                        FootnoteLabelView(icon: "doc.text.magnifyingglass", title: Text(verbatim: "粵音資料集叢"), footnote: "jyut.net")
                }
                LinkSafariView(url: URL(string: "https://words.hk")!) {
                        FootnoteLabelView(icon: "doc.text.magnifyingglass", title: Text(verbatim: "粵典"), footnote: "words.hk")
                }
                LinkSafariView(url: URL(string: "https://humanum.arts.cuhk.edu.hk/Lexis/lexi-can")!) {
                        FootnoteLabelView(icon: "doc.text.magnifyingglass", title: Text(verbatim: "粵語審音配詞字庫"), footnote: "humanum.arts.cuhk.edu.hk/Lexis/lexi-can")
                }
                LinkSafariView(url: URL(string: "https://www.jyutdict.org")!) {
                        FootnoteLabelView(icon: "doc.text.magnifyingglass", title: Text(verbatim: "泛粵大典"), footnote: "www.jyutdict.org")
                }
                LinkSafariView(url: URL(string: "https://shyyp.net/hant")!) {
                        FootnoteLabelView(icon: "doc.text.magnifyingglass", title: Text(verbatim: "羊羊粵語"), footnote: "shyyp.net/hant")
                }
        }
}

struct JyutpingResourcesLinksView: View {
        var body: some View {
                LinkSafariView(url: URL(string: "https://jyutping.org")!) {
                        FootnoteLabelView(title: Text("Jyutping"), footnote: "jyutping.org")
                }
                LinkSafariView(url: URL(string: "https://www.lshk.org/jyutping")!) {
                        FootnoteLabelView(title: Text("Jyutping - LSHK"), footnote: "www.lshk.org/jyutping")
                }
                LinkSafariView(url: URL(string: "https://www.ilc.cuhk.edu.hk/workshop/Chinese/Cantonese/Romanization")!) {
                        FootnoteLabelView(title: Text(verbatim: "粵語拼音速遞 - CUHK"), footnote: "www.ilc.cuhk.edu.hk/workshop/Chinese/Cantonese/Romanization")
                }
                LinkSafariView(url: URL(string: "https://www.youtube.com/channel/UCcmAegX-cgcOOconZIwqynw")!) {
                        FootnoteLabelView(title: Text("Learn Jyutping"), footnote: "youtube.com/channel/UCcmAegX-cgcOOconZIwqynw")
                }
        }
}

struct CantoneseResourcesLinksView: View {
        var body: some View {
                LinkSafariView(url: URL(string: "https://resonate.hk")!) {
                        FootnoteLabelView(title: Text(verbatim: "迴響"), footnote: "resonate.hk")
                }
                LinkSafariView(url: URL(string: "https://hambaanglaang.hk")!) {
                        FootnoteLabelView(title: Text(verbatim: "冚唪唥粵文"), footnote: "hambaanglaang.hk")
                }
                LinkSafariView(url: URL(string: "https://www.hok6.com")!) {
                        FootnoteLabelView(title: Text(verbatim: "學識 Hok6"), footnote: "www.hok6.com")
                }
        }
}
