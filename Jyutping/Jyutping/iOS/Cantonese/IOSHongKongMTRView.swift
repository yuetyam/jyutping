#if os(iOS)

import SwiftUI
import Materials

struct IOSHongKongMTRView: View {

        @State private var lines: [Metro.Line] = []
        @State private var expanded: [Bool] = Array(repeating: false, count: 40)

        var body: some View {
                List {
                        Section {
                                HeaderTermView(term: Term(name: "港鐵", romanization: "gong2 tit3"))
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
                        lines = Metro.hongkongMTRLines
                }
                .navigationTitle("Hong Kong MTR")
                .navigationBarTitleDisplayMode(.inline)
        }
}

#endif
