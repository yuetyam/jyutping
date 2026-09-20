#if os(iOS)

import SwiftUI
import CommonExtensions
import AppDataSource

struct IOSLyricsSinFaMunYuetLauView: View {

        @State private var entries: [TextRomanization] = AppMaster.lyricsSinFaMunYuetLau
        @State private var isEntriesLoaded: Bool = false

        private let rowInsets = EdgeInsets(top: 12, leading: 4, bottom: 12, trailing: 4)

        var body: some View {
                let part1One = entries.prefix(4)
                let part2Two = entries.dropFirst(4).prefix(4)
                let part3Three = entries.dropFirst(8).prefix(6)
                let part4Four = entries.dropFirst(14).prefix(4)
                let part5Five = entries.suffix(2)
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
                        Section {
                                ForEach(part4Four.indices, id: \.self) { index in
                                        let entry = part4Four[index]
                                        HStack {
                                                RubyStackView(text: entry.text, romanization: entry.romanization)
                                                Spacer()
                                                Speaker(entry.romanization)
                                        }
                                }
                        }
                        .listRowInsets(rowInsets)
                        Section {
                                ForEach(part5Five.indices, id: \.self) { index in
                                        let entry = part5Five[index]
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
                        if AppMaster.lyricsSinFaMunYuetLau.isEmpty {
                                AppMaster.fetchSinFaMunYuetLau()
                                entries = Lyrics.fetchSinFaMunYuetLau()
                        } else if entries.isEmpty {
                                entries = AppMaster.lyricsSinFaMunYuetLau
                        }
                }
                .navigationTitle("IOSCantoneseTab.NavigationTitle.LyricsSinFaMunYuetLau")
                .navigationBarTitleDisplayMode(.inline)
        }
}

#endif
