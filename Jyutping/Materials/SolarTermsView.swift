import SwiftUI

struct SolarTermsView: View {

        var body: some View {
                #if os(macOS)
                ScrollView {
                        LazyVStack(spacing: 16) {
                                TermView(term: Term(name: "二十四節氣", romanization: "ji6 sap6 sei3 zit3 hei3")).block()
                                VStack {
                                        ForEach(terms) {
                                                TermView(term: $0)
                                        }
                                }
                                .block()
                        }
                        .padding()
                }
                .navigationTitle("MacSidebar.NavigationTitle.SolarTerms")
                #else
                List {
                        Section {
                                TermView(term: Term(name: "二十四節氣", romanization: "ji6 sap6 sei3 zit3 hei3"))
                        }
                        Section {
                                ForEach(terms) {
                                        TermView(term: $0)
                                }
                        }
                }
                .navigationTitle("IOSCantoneseTab.NavigationTitle.SolarTerms")
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

                let items: [Term] = Term.array(from: textBlock)
                return items
        }()
}
