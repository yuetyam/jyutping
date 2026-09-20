#if os(macOS)

import SwiftUI
import CommonExtensions
import AppDataSource

struct MacLyricsSinFaMunYuetLauView: View {

        @State private var entries: [TextRomanization] = AppMaster.lyricsSinFaMunYuetLau
        @State private var isEntriesLoaded: Bool = false

        var body: some View {
                let part1One = entries.prefix(4)
                let part2Two = entries.dropFirst(4).prefix(4)
                let part3Three = entries.dropFirst(8).prefix(6)
                let part4Four = entries.dropFirst(14).prefix(4)
                let part5Five = entries.suffix(2)
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
                                VStack {
                                        ForEach(part4Four.indices, id: \.self) { index in
                                                let entry = part4Four[index]
                                                HStack(alignment: .bottom, spacing: 8) {
                                                        Speaker(entry.romanization)
                                                        RubyStackView(text: entry.text, romanization: entry.romanization)
                                                        Spacer()
                                                }
                                        }
                                }
                                .block()
                                VStack {
                                        ForEach(part5Five.indices, id: \.self) { index in
                                                let entry = part5Five[index]
                                                HStack(alignment: .bottom, spacing: 8) {
                                                        Speaker(entry.romanization)
                                                        RubyStackView(text: entry.text, romanization: entry.romanization)
                                                        Spacer()
                                                }
                                        }
                                }
                                .block()

                                VStack(alignment: .leading, spacing: 12) {
                                        Text(verbatim: "作詞：盧國沾")
                                        Text(verbatim: "作曲：顧嘉煇")
                                        Text(verbatim: "演唱：張德蘭")
                                }
                                .font(.copilot)
                                .textSelection(.enabled)
                                .padding(.horizontal, 8)
                                .padding(.vertical)
                        }
                        .padding()
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
                .animation(.default, value: entries.count)
                .navigationTitle("MacSidebar.NavigationTitle.LyricsSinFaMunYuetLau")
        }
}

#endif
