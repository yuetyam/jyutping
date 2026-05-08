#if os(macOS)

import SwiftUI
import AppDataSource

struct MacShamChunMetroView: View {

        @State private var lines: [Metro.Line] = []
        @State private var expanded: [Bool] = Array(repeating: false, count: 50)

        var body: some View {
                ScrollView {
                        LazyVStack(spacing: 8) {
                                ForEach(lines.indices, id: \.self) { index in
                                        MacMetroLineView(line: lines[index], isExpanded: $expanded[index])
                                }
                        }
                        .animation(.default, value: expanded)
                        .padding()
                        .task {
                                guard lines.isEmpty else { return }
                                lines = Metro.shamchunMetroLines
                        }
                }
                .navigationTitle("MacSidebar.NavigationTitle.ShamChunMetro")
        }
}

#endif
