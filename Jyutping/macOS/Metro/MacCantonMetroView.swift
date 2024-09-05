#if os(macOS)

import SwiftUI
import AppDataSource

struct MacCantonMetroView: View {

        @State private var lines: [Metro.Line] = []
        @State private var expanded: [Bool] = Array(repeating: false, count: 40)

        var body: some View {
                ScrollView {
                        LazyVStack(spacing: 12) {
                                TermView(term: Term(name: "廣州地鐵", romanization: "gwong2 zau1 dei6 tit3")).block()
                                ForEach(lines.indices, id: \.self) { index in
                                        MacMetroLineView(line: lines[index], isExpanded: $expanded[index])
                                }
                        }
                        .animation(.default, value: expanded)
                        .padding()
                        .task {
                                guard lines.isEmpty else { return }
                                lines = Metro.cantonMetroLines
                        }
                }
                .navigationTitle("MacSidebar.NavigationTitle.CantonMetro")
        }
}

#endif
