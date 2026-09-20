#if os(iOS)

import SwiftUI
import CommonExtensions
import AppDataSource

struct IOSLyricsYuetGwongGwongView: View {

        @State private var entries: [TextRomanization] = AppMaster.lyricsYuetGwongGwong
        @State private var isEntriesLoaded: Bool = false

        private let rowInsets = EdgeInsets(top: 12, leading: 4, bottom: 12, trailing: 4)

        var body: some View {
                let part1One = entries.prefix(7)
                let part2Two = entries.dropFirst(7).prefix(7)
                let part3Three = entries.suffix(8)
                List {
                        Section {
                                ForEach(part1One.indices, id: \.self) { index in
                                        let entry = part1One[index]
                                        HStack {
                                                RubyStackView(text: entry.text, romanization: entry.romanization)
                                                Spacer()
                                                Speaker(entry.romanization)
                                        }
                                }
                        }
                        .listRowInsets(rowInsets)
                        Section {
                                ForEach(part2Two.indices, id: \.self) { index in
                                        let entry = part2Two[index]
                                        HStack {
                                                RubyStackView(text: entry.text, romanization: entry.romanization)
                                                Spacer()
                                                Speaker(entry.romanization)
                                        }
                                }
                        }
                        .listRowInsets(rowInsets)
                        Section {
                                ForEach(part3Three.indices, id: \.self) { index in
                                        let entry = part3Three[index]
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
                        if AppMaster.lyricsYuetGwongGwong.isEmpty {
                                AppMaster.fetchYuetGwongGwong()
                                entries = Lyrics.fetchYuetGwongGwong()
                        } else if entries.isEmpty {
                                entries = AppMaster.lyricsYuetGwongGwong
                        }
                }
                .navigationTitle("IOSCantoneseTab.NavigationTitle.LyricsYuetGwongGwong")
                .navigationBarTitleDisplayMode(.inline)
        }
}

#endif
