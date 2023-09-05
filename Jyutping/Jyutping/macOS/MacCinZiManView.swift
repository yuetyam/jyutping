#if os(macOS)

import SwiftUI
import Materials

struct MacCinZiManView: View {

        @State private var lines: [LineUnit] = []
        @State private var isLinesLoaded: Bool = false

        var body: some View {
                ScrollView {
                        LazyVStack(alignment: .leading, spacing: 8) {
                                HeaderTermView(term: Term(name: "千字文", romanization: "cin1 zi6 man4")).block()
                                ForEach(0..<lines.count, id: \.self) { index in
                                        MacLineUnitView(line: lines[index])
                                }
                        }
                        .padding()
                }
                .task {
                        guard !isLinesLoaded else { return }
                        lines = CinZiMan.fetch()
                        isLinesLoaded = true
                }
                .animation(.default, value: lines.count)
                .navigationTitle("Thousand Character Classic")
        }
}

#endif
