#if os(iOS)

import SwiftUI
import Materials

struct IOSShamChunMetroView: View {

        @State private var lines: [Metro.Line] = []
        @State private var expanded: [Bool] = Array(repeating: false, count: 40)

        var body: some View {
                List {
                        Section {
                                HeaderTermView(term: Term(name: "深圳地鐵", romanization: "sam1 zan3 dei6 tit3"))
                        }
                        ForEach(0..<lines.count, id: \.self) { index in
                                Section {
                                        IOSMetroLineView(line: lines[index], isExpanded: $expanded[index])
                                }
                        }
                }
                .animation(.default, value: expanded)
                .textSelection(.enabled)
                .task {
                        guard lines.isEmpty else { return }
                        lines = Metro.shamchunMetroLines
                }
                .navigationTitle("Sham Chun Metro")
                .navigationBarTitleDisplayMode(.inline)
        }
}

#endif
