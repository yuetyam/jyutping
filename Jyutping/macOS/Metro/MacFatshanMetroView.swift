#if os(macOS)

import SwiftUI
import AppDataSource

struct MacFatshanMetroView: View {

        @State private var lines: [Metro.Line] = []
        @State private var expanded: [Bool] = Array(repeating: false, count: 40)

        var body: some View {
                ScrollView {
                        LazyVStack(spacing: 16) {
                                TermView(term: Term(name: "佛山地鐵", romanization: "fat6 saan1 dei6 tit3")).block()
                                ForEach(0..<lines.count, id: \.self) { index in
                                        MacMetroLineView(line: lines[index], isExpanded: $expanded[index])
                                }
                        }
                        .animation(.default, value: expanded)
                        .padding()
                        .task {
                                guard lines.isEmpty else { return }
                                lines = Metro.fatshanMetroLines
                        }
                }
                .navigationTitle("Fatshan Metro")
        }
}

#endif
