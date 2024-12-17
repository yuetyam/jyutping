#if os(iOS)

import SwiftUI
import AppDataSource

struct IOSTungkunRailTransitView: View {

        @State private var lines: [Metro.Line] = []
        @State private var expanded: [Bool] = Array(repeating: false, count: 40)

        var body: some View {
                List {
                        Section {
                                TermView(term: Term(name: "東莞軌道交通", romanization: "dung1 gun2 gwai2 dou6 gaau1 tung1"))
                        }
                        ForEach(lines.indices, id: \.self) { index in
                                Section {
                                        IOSMetroLineView(line: lines[index], isExpanded: $expanded[index])
                                }
                        }
                }
                .animation(.default, value: expanded)
                .textSelection(.enabled)
                .task {
                        guard lines.isEmpty else { return }
                        lines = Metro.tungkunRailTransitLines
                }
                .navigationTitle("IOSCantoneseTab.NavigationTitle.TungkunRailTransit")
                .navigationBarTitleDisplayMode(.inline)
        }
}

#endif
