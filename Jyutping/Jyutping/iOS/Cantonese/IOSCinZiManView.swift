#if os(iOS)

import SwiftUI
import Materials

struct IOSCinZiManView: View {

        @State private var lines: [LineUnit] = []
        @State private var isLinesLoaded: Bool = false

        var body: some View {
                List {
                        Section {
                                HeaderTermView(term: Term(name: "千字文", romanization: "cin1 zi6 man4"))
                        }
                        ForEach(0..<lines.count, id: \.self) { index in
                                Section {
                                        IOSLineUnitView(line: lines[index])
                                }
                        }
                }
                .task {
                        guard !isLinesLoaded else { return }
                        lines = CinZiMan.fetch()
                        isLinesLoaded = true
                }
                .textSelection(.enabled)
                .navigationTitle("title.characters")
                .navigationBarTitleDisplayMode(.inline)
        }
}

#endif
