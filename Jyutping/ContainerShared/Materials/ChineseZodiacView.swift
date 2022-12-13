import SwiftUI

@available(iOS 15.0, *)
struct ChineseZodiacView: View {
        var body: some View {
                #if os(macOS)
                ScrollView {
                        LazyVStack(spacing: 16) {
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

                let lines: [String] = textBlock.components(separatedBy: .newlines).map({ $0.trimmed() }).filter({ !$0.isEmpty })
                let items: [Term] = lines.map { line -> Term in
                        let parts: [String] = line.components(separatedBy: ",")
                        let name: String = parts.first ?? "?"
                        let romanization: String = parts.last ?? "?"
                        return Term(name: name, romanization: romanization)
                }
                return items
        }()

        private let altTerms: [Term] = [Term(name: "大蟲", romanization: "daai6 cung4"), Term(name: "馬騮", romanization: "maa5 lau1")]
}
