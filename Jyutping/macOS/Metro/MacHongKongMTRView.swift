#if os(macOS)

import SwiftUI
import AppDataSource

struct MacHongKongMTRView: View {

        @State private var lines: [Metro.Line] = []
        @State private var expanded: [Bool] = Array(repeating: false, count: 40)

        var body: some View {
                ScrollView {
                        LazyVStack(spacing: 16) {
                                HeaderTermView(term: Term(name: "港鐵", romanization: "gong2 tit3")).block()
                                ForEach(0..<lines.count, id: \.self) { index in
                                        MacMetroLineView(line: lines[index], isExpanded: $expanded[index])
                                }
                        }
                        .animation(.default, value: expanded)
                        .font(.master)
                        .textSelection(.enabled)
                        .padding()
                        .task {
                                guard lines.isEmpty else { return }
                                lines = Metro.hongkongMTRLines
                        }
                }
                .navigationTitle("Hong Kong MTR")
        }
}

#endif
