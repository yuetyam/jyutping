#if os(iOS)

import SwiftUI
import AppDataSource

struct IOSThousandCharacterClassicView: View {

        @State private var entries: [TextRomanization] = AppMaster.thousandCharacterClassicEntries
        @State private var isEntriesLoaded: Bool = false

        var body: some View {
                List {
                        Section {
                                TermView(term: Term(name: "千字文", romanization: "cin1 zi6 man4"))
                        }
                        ForEach(0..<entries.count, id: \.self) { index in
                                Section {
                                        IOSTextRomanizationLabel(item: entries[index])
                                }
                        }
                }
                .task {
                        guard !isEntriesLoaded else { return }
                        defer { isEntriesLoaded = true }
                        if AppMaster.thousandCharacterClassicEntries.isEmpty {
                                AppMaster.fetchThousandCharacterClassic()
                                entries = ThousandCharacterClassic.fetch()
                        } else {
                                entries = AppMaster.thousandCharacterClassicEntries
                        }
                }
                .textSelection(.enabled)
                .navigationTitle("IOSCantoneseTab.NavigationTitle.ThousandCharacterClassic")
                .navigationBarTitleDisplayMode(.inline)
        }
}

#endif
