#if os(macOS)

import SwiftUI
import CommonExtensions
import AppDataSource

struct MacLyricsLokYuDaaiView: View {

        @State private var entries: [TextRomanization] = AppMaster.lyricsLokYuDaai
        @State private var isEntriesLoaded: Bool = false

        var body: some View {
                ScrollView {
                        LazyVStack(alignment: .leading, spacing: 8) {
                                VStack {
                                        ForEach(entries.indices, id: \.self) { index in
                                                let entry = entries[index]
                                                HStack(alignment: .bottom, spacing: 8) {
                                                        Speaker(entry.romanization)
                                                        RubyStackView(text: entry.text, romanization: entry.romanization)
                                                        Spacer()
                                                }
                                        }
                                }
                                .block()
                        }
                        .padding()
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
                .animation(.default, value: entries.count)
                .navigationTitle("MacSidebar.NavigationTitle.LyricsLokYuDaai")
        }
}

#endif
