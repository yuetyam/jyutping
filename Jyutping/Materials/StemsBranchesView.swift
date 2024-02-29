import SwiftUI

struct StemsBranchesView: View {
        var body: some View {
                #if os(macOS)
                ScrollView {
                        LazyVStack(spacing: 16) {
                                TermView(term: Term(name: "天干地支", romanization: "tin1 gon1 dei6 zi1")).block()
                                VStack {
                                        ForEach(stems) {
                                                TermView(term: $0)
                                        }
                                }
                                .block()
                                VStack {
                                        ForEach(branches) {
                                                TermView(term: $0)
                                        }
                                }
                                .block()
                        }
                        .padding()
                }
                .navigationTitle("MacSidebar.NavigationTitle.StemsAndBranches")
                #else
                List {
                        Section {
                                TermView(term: Term(name: "天干地支", romanization: "tin1 gon1 dei6 zi1"))
                        }
                        Section {
                                ForEach(stems) {
                                        TermView(term: $0)
                                }
                        }
                        Section {
                                ForEach(branches) {
                                        TermView(term: $0)
                                }
                        }
                }
                .navigationTitle("Stems and Branches")
                .navigationBarTitleDisplayMode(.inline)
                #endif
        }

        private let stems: [Term] = {
                let textBlock: String = """
                甲,gaap3
                乙,jyut3
                丙,bing2
                丁,ding1
                戊,mou6
                己,gei2
                庚,gang1
                辛,san1
                壬,jam4
                癸,gwai3
                """

                let items: [Term] = Term.array(from: textBlock)
                return items
        }()

        private let branches: [Term] = {
                let textBlock: String = """
                子,zi2
                丑,cau2
                寅,jan4
                卯,maau5
                辰,san4
                巳,zi6
                午,ng5
                未,mei6
                申,san1
                酉,jau5
                戌,seot1
                亥,hoi6
                """

                let items: [Term] = Term.array(from: textBlock)
                return items
        }()
}
