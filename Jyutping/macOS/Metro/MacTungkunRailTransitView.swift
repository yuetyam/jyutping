#if os(macOS)

import SwiftUI
import AppDataSource

struct MacTungkunRailTransitView: View {

        @State private var lines: [Metro.Line] = []
        @State private var expanded: [Bool] = Array(repeating: false, count: 40)

        var body: some View {
                ScrollView {
                        LazyVStack(spacing: 12) {
                                TermView(term: Term(name: "東莞軌道交通", romanization: "dung1 gun2 gwai2 dou6 gaau1 tung1")).block()
                                ForEach(lines.indices, id: \.self) { index in
                                        MacMetroLineView(line: lines[index], isExpanded: $expanded[index])
                                }
                        }
                        .animation(.default, value: expanded)
                        .padding()
                        .task {
                                guard lines.isEmpty else { return }
                                lines = Metro.tungkunRailTransitLines
                        }
                }
                .navigationTitle("MacSidebar.NavigationTitle.TungkunRailTransit")
        }
}

#endif
