#if os(macOS)

import SwiftUI
import CommonExtensions
import AppDataSource

struct MacThousandCharacterClassicView: View {

        @State private var entries: [TextRomanization] = AppMaster.thousandCharacterClassicEntries
        @State private var isEntriesLoaded: Bool = false

        var body: some View {
                ScrollView {
                        LazyVStack(alignment: .leading, spacing: 8) {
                                TermView(term: Term(name: "千字文", romanization: "cin1 zi6 man4")).block()
                                ForEach(entries.indices, id: \.self) { index in
                                        MacTextRomanizationLabel(item: entries[index])
                                }
                        }
                        .padding()
                }
                .task {
                        guard isEntriesLoaded.negative else { return }
                        defer { isEntriesLoaded = true }
                        if AppMaster.thousandCharacterClassicEntries.isEmpty {
                                AppMaster.fetchThousandCharacterClassic()
                                entries = ThousandCharacterClassic.fetch()
                        } else {
                                entries = AppMaster.thousandCharacterClassicEntries
                        }
                }
                .animation(.default, value: entries.count)
                .navigationTitle("MacSidebar.NavigationTitle.ThousandCharacterClassic")
        }
}

#endif
