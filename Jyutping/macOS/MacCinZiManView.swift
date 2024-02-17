#if os(macOS)

import SwiftUI
import AppDataSource

struct MacCinZiManView: View {

        @State private var units: [LineUnit] = AppMaster.cinZiManUnits
        @State private var isUnitsLoaded: Bool = false

        var body: some View {
                ScrollView {
                        LazyVStack(alignment: .leading, spacing: 8) {
                                TermView(term: Term(name: "千字文", romanization: "cin1 zi6 man4")).block()
                                ForEach(0..<units.count, id: \.self) { index in
                                        MacLineUnitView(line: units[index])
                                }
                        }
                        .padding()
                }
                .task {
                        guard !isUnitsLoaded else { return }
                        defer { isUnitsLoaded = true }
                        if AppMaster.cinZiManUnits.isEmpty {
                                AppMaster.fetchCinZiManUnits()
                                units = CinZiMan.fetch()
                        } else {
                                units = AppMaster.cinZiManUnits
                        }
                }
                .animation(.default, value: units.count)
                .navigationTitle("Thousand Character Classic")
        }
}

#endif
