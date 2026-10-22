#if canImport(UIKit)

import SwiftUI
import AppDataSource

struct IOSShamChunMetroView: View {

        @State private var lines: [Metro.Line] = []
        @State private var expanded: [Bool] = Array(repeating: false, count: 40)

        var body: some View {
                List {
                        ForEach(lines.indices, id: \.self) { index in
                                Section {
                                        IOSMetroLineView(line: lines[index], isExpanded: $expanded[index])
                                }
                        }
                }
                .listSectionSpacing(.compact)
                .animation(.default, value: expanded)
                .task {
                        guard lines.isEmpty else { return }
                        lines = Metro.shamchunMetroLines
                }
                .navigationTitle("IOSCantoneseTab.NavigationTitle.ShamChunMetro")
                .navigationBarTitleDisplayMode(.inline)
        }
}

#endif
