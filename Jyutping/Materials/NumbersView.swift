import SwiftUI

struct NumbersView: View {
        var body: some View {
                #if os(macOS)
                ScrollView {
                        LazyVStack(spacing: 16) {
                                TermView(term: Term(name: "數字", romanization: "sou3 zi6")).block()
                                VStack {
                                        ForEach(numbers) {
                                                TermView(term: $0)
                                        }
                                }
                                .block()
                        }
                        .padding()
                }
                .navigationTitle("MacSidebar.NavigationTitle.Numbers")
                #else
                List {
                        Section {
                                TermView(term: Term(name: "數字", romanization: "sou3 zi6"))
                        }
                        Section {
                                ForEach(numbers) {
                                        TermView(term: $0)
                                }
                        }
                }
                .navigationTitle("IOSCantoneseTab.NavigationTitle.Numbers")
                .navigationBarTitleDisplayMode(.inline)
                #endif
        }

        private let numbers: [Term] = {
                let textBlock: String = """
                一,jat1
                二,ji6
                兩,loeng5
                三,saam1
                四,sei3
                五,ng5
                六,luk6
                七,cat1
                八,baat3
                九,gau2
                幾,gei2
                十,sap6
                廿,jaa6
                百,baak3
                千,cin1
                萬,maan6
                億,jik1
                """

                let items: [Term] = Term.array(from: textBlock)
                return items
        }()
}
