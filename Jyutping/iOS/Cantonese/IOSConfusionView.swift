#if os(iOS)

import SwiftUI
import AppDataSource

struct IOSConfusionView: View {

        @State private var entries: [ConfusionEntry] = AppMaster.confusionEntries
        @State private var isDataSourceLoaded: Bool = false

        private let insets: EdgeInsets = EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0)

        var body: some View {
                List {
                        ForEach(entries.indices, id: \.self) { index in
                                Section {
                                        if index == 0 {
                                                HStack {
                                                        Text(verbatim: "簡化字").frame(width: 48)
                                                        Text(verbatim: "傳統漢字").frame(width: 84, alignment: .leading).padding(.leading, 24)
                                                        Text(verbatim: "備註")
                                                }
                                                .font(.footnote)
                                        }
                                        EntryView(entry: entries[index])
                                }
                                .listRowInsets(insets)
                        }
                }
                .textSelection(.enabled)
                .task {
                        guard !isDataSourceLoaded else { return }
                        defer { isDataSourceLoaded = true }
                        guard entries.isEmpty else { return }
                        if AppMaster.confusionEntries.isEmpty {
                                AppMaster.fetchConfusionEntries()
                                entries = Confusion.fetch()
                        } else {
                                entries = AppMaster.confusionEntries
                        }
                }
                .navigationTitle("IOSCantoneseTab.NavigationTitle.SimplifiedCharacterConfusion")
                .navigationBarTitleDisplayMode(.inline)
        }
}

private struct EntryView: View {
        let entry: ConfusionEntry
        var body: some View {
                HStack {
                        Text(verbatim: entry.simplified).frame(width: 32)
                        VStack(alignment: .leading, spacing: 4) {
                                ForEach(entry.traditional.indices, id: \.self) { index in
                                        let unit = entry.traditional[index]
                                        if index != 0 {
                                                Divider()
                                        }
                                        HStack {
                                                HStack {
                                                        Speaker(unit.romanization)
                                                        Text(verbatim: unit.character)
                                                                .minimumScaleFactor(0.4)
                                                                .lineLimit(1)
                                                        Text(verbatim: unit.romanization)
                                                                .minimumScaleFactor(0.4)
                                                                .lineLimit(1)
                                                }
                                                .frame(width: 124, alignment: .leading)
                                                Text(verbatim: unit.note)
                                                        .minimumScaleFactor(0.4)
                                                        .lineLimit(1)
                                        }
                                }
                        }
                }
        }
}

#endif
