#if os(iOS)

import SwiftUI
import AppDataSource

struct IOSMacauMetroView: View {

        @State private var lines: [Metro.Line] = []
        @State private var expanded: [Bool] = Array(repeating: false, count: 40)

        var body: some View {
                List {
                        Section {
                                TermView(term: Term(name: "澳門輕軌", romanization: "ou3 mun2 hing1 gwai2"))
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
                        lines = Metro.macauMetroLines
                }
                .navigationTitle("IOSCantoneseTab.NavigationTitle.MacauMetro")
                .navigationBarTitleDisplayMode(.inline)
        }
}

#endif
