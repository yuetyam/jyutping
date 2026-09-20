#if os(macOS)

import SwiftUI
import CommonExtensions
import AppDataSource

struct MacLyricsYuetGwongGwongView: View {

        @State private var entries: [TextRomanization] = AppMaster.lyricsYuetGwongGwong
        @State private var isEntriesLoaded: Bool = false

        var body: some View {
                let part1One = entries.prefix(7)
                let part2Two = entries.dropFirst(7).prefix(7)
                let part3Three = entries.suffix(8)
                ScrollView {
                        LazyVStack(alignment: .leading, spacing: 8) {
                                VStack {
                                        ForEach(part1One.indices, id: \.self) { index in
                                                let entry = part1One[index]
                                                HStack(alignment: .bottom, spacing: 8) {
                                                        Speaker(entry.romanization)
                                                        RubyStackView(text: entry.text, romanization: entry.romanization)
                                                        Spacer()
                                                }
                                        }
                                }
                                .block()
                                VStack {
                                        ForEach(part2Two.indices, id: \.self) { index in
                                                let entry = part2Two[index]
                                                HStack(alignment: .bottom, spacing: 8) {
                                                        Speaker(entry.romanization)
                                                        RubyStackView(text: entry.text, romanization: entry.romanization)
                                                        Spacer()
                                                }
                                        }
                                }
                                .block()
                                VStack {
                                        ForEach(part3Three.indices, id: \.self) { index in
                                                let entry = part3Three[index]
                                                HStack(alignment: .bottom, spacing: 8) {
                                                        Speaker(entry.romanization)
                                                        RubyStackView(text: entry.text, romanization: entry.romanization)
                                                        Spacer()
                                                }
                                        }
                                }
                                .block()
                                .padding(.bottom)
                        }
                        .padding()
                }
                .task {
                        guard isEntriesLoaded.negative else { return }
                        defer { isEntriesLoaded = true }
                        if AppMaster.lyricsYuetGwongGwong.isEmpty {
                                AppMaster.fetchYuetGwongGwong()
                                entries = Lyrics.fetchYuetGwongGwong()
                        } else if entries.isEmpty {
                                entries = AppMaster.lyricsYuetGwongGwong
                        }
                }
                .animation(.default, value: entries.count)
                .navigationTitle("MacSidebar.NavigationTitle.LyricsYuetGwongGwong")
        }
}

#endif
