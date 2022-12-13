import SwiftUI

private struct Term: Hashable, Identifiable {

        let name: String
        let romanization: String

        var id: String {
                return name + romanization
        }
}

@available(iOS 15.0, *)
private struct TermView: View {

        let term: Term

        #if os(macOS)
        private let spacing: CGFloat = 32
        #else
        private let spacing: CGFloat = 24
        #endif

        var body: some View {
                HStack {
                        HStack(spacing: spacing) {
                                Text(verbatim: term.name).font(.master).textSelection(.enabled)
                                ZStack(alignment: .leading) {
                                        // { soeng1 gong3 } is the longest
                                        Text(verbatim: "soeng1 gong3").hidden()
                                        Text(verbatim: term.romanization).textSelection(.enabled)
                                }
                                .font(.body.monospaced())
                        }
                        Speaker(term.romanization)
                        Spacer()
                }
        }
}

@available(iOS 15.0, *)
struct SolarTermsView: View {

        var body: some View {
                #if os(macOS)
                ScrollView {
                        LazyVStack(spacing: 16) {
                                ForEach(terms) {
                                        TermView(term: $0)
                                }
                        }
                        .block()
                        .padding()
                }
                .navigationTitle("Solar Terms")
                #else
                List(terms) {
                        TermView(term: $0)
                }
                .navigationTitle("Solar Terms")
                .navigationBarTitleDisplayMode(.inline)
                #endif
        }

        private let terms: [Term] = {
                let textBlock: String = """
                立春,lap6 ceon1
                雨水,jyu5 seoi2
                驚蟄,ging1 zap6
                春分,ceon1 fan1
                清明,cing1 ming4
                穀雨,guk1 jyu5
                立夏,lap6 haa6
                小滿,siu2 mun5
                芒種,mong4 zung3
                夏至,haa6 zi3
                小暑,siu2 syu2
                大暑,daai6 syu2
                立秋,lap6 cau1
                處暑,cyu2 syu2
                白露,baak6 lou6
                秋分,cau1 fan1
                寒露,hon4 lou6
                霜降,soeng1 gong3
                立冬,lap6 dung1
                小雪,siu2 syut3
                大雪,daai6 syut3
                冬至,dung1 zi3
                小寒,siu2 hon4
                大寒,daai6 hon4
                """

                let lines: [String] = textBlock.components(separatedBy: .newlines).map({ $0.trimmed() }).filter({ !$0.isEmpty })
                let termItems: [Term] = lines.map { line -> Term in
                        let parts: [String] = line.components(separatedBy: ",")
                        let name: String = parts.first ?? "?"
                        let romanization: String = parts.last ?? "?"
                        return Term(name: name, romanization: romanization)
                }
                return termItems
        }()
}
