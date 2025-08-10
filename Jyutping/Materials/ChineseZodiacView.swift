import SwiftUI

struct ChineseZodiacView: View {
        var body: some View {
                #if os(macOS)
                ScrollView {
                        LazyVStack(spacing: 12) {
                                TermView(term: Term(name: "十二生肖", romanization: "sap6 ji6 sang1 ciu3")).block()
                                VStack {
                                        ForEach(terms) {
                                                TermView(term: $0)
                                        }
                                }
                                .block()
                                VStack {
                                        ForEach(altTerms) {
                                                TermView(term: $0)
                                        }
                                }
                                .block()
                                VStack {
                                        ForEach(patchTerms) {
                                                TermView(term: $0)
                                        }
                                }
                                .block()
                        }
                        .padding()
                }
                .navigationTitle("MacSidebar.NavigationTitle.ChineseZodiac")
                #else
                List {
                        Section {
                                TermView(term: Term(name: "十二生肖", romanization: "sap6 ji6 sang1 ciu3"))
                        }
                        Section {
                                ForEach(terms) {
                                        TermView(term: $0)
                                }
                        }
                        Section {
                                ForEach(altTerms) {
                                        TermView(term: $0)
                                }
                        }
                        Section {
                                ForEach(patchTerms) {
                                        TermView(term: $0)
                                }
                        }
                }
                .navigationTitle("IOSCantoneseTab.NavigationTitle.ChineseZodiac")
                .navigationBarTitleDisplayMode(.inline)
                #endif
        }

        private let terms: [Term] = {
                let textBlock: String = """
                鼠,syu2,🐀
                牛,ngau4,🐃
                虎,fu2,🐅
                兔,tou3,🐇
                龍,lung4,🐉
                蛇,se4,🐍
                馬,maa5,🐎
                羊,joeng4,🐑
                猴,hau4,🐒
                雞,gai1,🐓
                狗,gau2,🦮
                豬,zyu1,🐖
                """

                let items: [Term] = Term.array(from: textBlock)
                return items
        }()

        private let altTerms: [Term] = {
                let textBlock: String = """
                子鼠,zi2 syu2,🐀
                丑牛,cau2 ngau4,🐃
                寅虎,jan4 fu2,🐅
                卯兔,maau5 tou3,🐇
                辰龍,san4 lung4,🐉
                巳蛇,zi6 se4,🐍
                午馬,ng5 maa5,🐎
                未羊,mei6 joeng4,🐑
                申猴,san1 hau4,🐒
                酉雞,jau5 gai1,🐓
                戌狗,seot1 gau2,🦮
                亥豬,hoi6 zyu1,🐖
                """

                let items: [Term] = Term.array(from: textBlock)
                return items
        }()

        private let patchTerms: [Term] = {
                let textBlock: String = """
                老鼠,lou5 syu2,🐀
                水牛,seoi2 ngau4,🐃
                老虎,lou5 fu2,🐅
                大蟲,daai6 cung4,🐅
                綿羊,min4 joeng4,🐑
                馬騮,maa5 lau1,🐒
                """

                let items: [Term] = Term.array(from: textBlock)
                return items
        }()
}
