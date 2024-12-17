#if os(macOS)

import SwiftUI
import AppDataSource

struct MacMacauMetroView: View {

        @State private var lines: [Metro.Line] = []
        @State private var expanded: [Bool] = Array(repeating: false, count: 40)

        var body: some View {
                ScrollView {
                        LazyVStack(spacing: 12) {
                                TermView(term: Term(name: "澳門輕軌", romanization: "ou3 mun2 hing1 gwai2")).block()
                                ForEach(lines.indices, id: \.self) { index in
                                        MacMetroLineView(line: lines[index], isExpanded: $expanded[index])
                                }
                        }
                        .animation(.default, value: expanded)
                        .padding()
                        .task {
                                guard lines.isEmpty else { return }
                                lines = Metro.macauMetroLines
                        }
                }
                .navigationTitle("MacSidebar.NavigationTitle.MacauMetro")
        }
}

#endif
