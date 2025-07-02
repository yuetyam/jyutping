#if os(macOS)

import SwiftUI
import CommonExtensions
import AppDataSource

struct MacConfusionView: View {

        @State private var entries: [ConfusionEntry] = AppMaster.confusionEntries
        @State private var isDataSourceLoaded: Bool = false

        var body: some View {
                ScrollView {
                        LazyVStack(alignment: .leading, spacing: 8) {
                                HStack {
                                        Text(verbatim: "簡化字").frame(width: 60)
                                        Text(verbatim: "傳統漢字").frame(width: 96, alignment: .leading).padding(.leading, 32)
                                        Text(verbatim: "備註")
                                        Spacer()
                                }
                                .font(.copilot)
                                .textSelection(.enabled)
                                ForEach(entries.indices, id: \.self) { index in
                                        EntryView(entry: entries[index])
                                }
                        }
                        .padding()
                }
                .task {
                        guard isDataSourceLoaded.negative else { return }
                        defer { isDataSourceLoaded = true }
                        guard entries.isEmpty else { return }
                        if AppMaster.confusionEntries.isEmpty {
                                AppMaster.fetchConfusionEntries()
                                entries = Confusion.fetch()
                        } else {
                                entries = AppMaster.confusionEntries
                        }
                }
                .navigationTitle("MacSidebar.NavigationTitle.SimplifiedCharacterConfusion")
        }
}

private struct EntryView: View {
        let entry: ConfusionEntry
        var body: some View {
                HStack {
                        Text(verbatim: entry.simplified).frame(width: 60)
                        VStack(alignment: .leading, spacing: 4) {
                                ForEach(entry.traditional.indices, id: \.self) { index in
                                        let unit: ConfusionTraditional = entry.traditional[index]
                                        if index != 0 {
                                                Divider()
                                        }
                                        HStack {
                                                HStack {
                                                        Speaker(unit.romanization)
                                                        Text(verbatim: unit.character).minimumScaleFactor(0.5).lineLimit(1)
                                                        Text(verbatim: unit.romanization).minimumScaleFactor(0.5).lineLimit(1)
                                                }
                                                .frame(width: 128, alignment: .leading)
                                                Text(verbatim: unit.note).frame(width: 180, alignment: .leading).minimumScaleFactor(0.5).lineLimit(1)
                                        }
                                }
                        }
                        .fixedSize()
                        Spacer()
                }
                .font(.master)
                .textSelection(.enabled)
                .padding(.vertical, 8)
                .background(Color.textBackgroundColor, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
        }
}

#endif
