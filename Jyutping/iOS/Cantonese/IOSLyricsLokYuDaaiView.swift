#if os(iOS)

import SwiftUI
import CommonExtensions
import AppDataSource

struct IOSLyricsLokYuDaaiView: View {

        @State private var entries: [TextRomanization] = AppMaster.lyricsLokYuDaai
        @State private var isEntriesLoaded: Bool = false

        private let rowInsets = EdgeInsets(top: 14, leading: 8, bottom: 14, trailing: 8)

        var body: some View {
                List {
                        Section {
                                ForEach(entries.indices, id: \.self) { index in
                                        let entry = entries[index]
                                        HStack {
                                                RubyStackView(text: entry.text, romanization: entry.romanization)
                                                Spacer()
                                                Speaker(entry.romanization)
                                        }
                                }
                        }
                        .listRowInsets(rowInsets)
                }
                .task {
                        guard isEntriesLoaded.negative else { return }
                        defer { isEntriesLoaded = true }
                        if AppMaster.lyricsLokYuDaai.isEmpty {
                                AppMaster.fetchLokYuDaai()
                                entries = Lyrics.fetchLokYuDaai()
                        } else if entries.isEmpty {
                                entries = AppMaster.lyricsLokYuDaai
                        }
                }
                .navigationTitle("IOSCantoneseTab.NavigationTitle.LyricsLokYuDaai")
                .navigationBarTitleDisplayMode(.inline)
        }
}

#endif
