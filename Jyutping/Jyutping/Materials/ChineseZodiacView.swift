import SwiftUI

struct ChineseZodiacView: View {
        var body: some View {
                #if os(macOS)
                ScrollView {
                        LazyVStack(spacing: 16) {
                                HeaderTermView(term: Term(name: "十二生肖", romanization: "sap6 ji6 sang1 ciu3")).block()
                                VStack {
                                        ForEach(terms) {
                                                TermView(term: $0, placeholder: "joeng4")
                                        }
                                }
                                .block()
                                VStack {
                                        ForEach(altTerms) {
                                                TermView(term: $0, placeholder: "daai6 cung4")
                                        }
                                }
                                .block()
                        }
                        .padding()
                }
                .navigationTitle("Chinese Zodiac")
                #else
                List {
                        Section {
                                HeaderTermView(term: Term(name: "十二生肖", romanization: "sap6 ji6 sang1 ciu3"))
                        }
                        Section {
                                ForEach(terms) {
                                        TermView(term: $0, placeholder: "joeng4")
                                }
                        }
                        Section {
                                ForEach(altTerms) {
                                        TermView(term: $0, placeholder: "daai6 cung4")
                                }
                        }
                }
                .navigationTitle("Chinese Zodiac")
                .navigationBarTitleDisplayMode(.inline)
                #endif
        }

        private let terms: [Term] = {
                let textBlock: String = """
                鼠,syu2
                牛,ngau4
                虎,fu2
                兔,tou3
                龍,lung4
                蛇,se4
                馬,maa5
                羊,joeng4
                猴,hau4
                雞,gai1
                狗,gau2
                豬,zyu1
                """

                let items: [Term] = Term.array(from: textBlock)
                return items
        }()

        private let altTerms: [Term] = [
                Term(name: "老鼠", romanization: "lou5 syu2"),
                Term(name: "老虎", romanization: "lou5 fu2"),
                Term(name: "大蟲", romanization: "daai6 cung4", comment: "即老虎"),
                Term(name: "馬騮", romanization: "maa5 lau1", comment: "即猴")
        ]
}
