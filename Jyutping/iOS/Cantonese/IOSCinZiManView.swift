#if os(iOS)

import SwiftUI
import AppDataSource

struct IOSCinZiManView: View {

        @State private var units: [LineUnit] = AppMaster.cinZiManUnits
        @State private var isUnitsLoaded: Bool = false

        var body: some View {
                List {
                        Section {
                                TermView(term: Term(name: "千字文", romanization: "cin1 zi6 man4"))
                        }
                        ForEach(0..<units.count, id: \.self) { index in
                                Section {
                                        IOSLineUnitView(line: units[index])
                                }
                        }
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
                .textSelection(.enabled)
                .navigationTitle("IOSCantoneseTab.NavigationTitle.ThousandCharacterClassic")
                .navigationBarTitleDisplayMode(.inline)
        }
}

#endif
