#if os(iOS)

import SwiftUI
import AppDataSource
import CommonExtensions
import Linguistics

struct YingWaaFanWanLexiconView: View {
        let lexicon: [YingWaaFanWan]
        var body: some View {
                if let firstEntry = lexicon.first {
                        HStack(spacing: 16) {
                                HStack(spacing: 2) {
                                        Text(verbatim: "文字").font(.copilot).shallow()
                                        Text.separator
                                        Text(verbatim: firstEntry.word)
                                }
                                if let unicode = firstEntry.word.first?.codePointsText {
                                        Text(verbatim: unicode)
                                                .font(.footnote)
                                                .monospaced()
                                                .foregroundStyle(Color.secondary)
                                }
                        }
                }
                ForEach(lexicon.indices, id: \.self) { index in
                        YingWaaFanWanPronunciationView(entry: lexicon[index])
                }
        }
}

private struct YingWaaFanWanPronunciationView: View {
        let entry: YingWaaFanWan
        var body: some View {
                let homophoneText: String? = entry.homophones.isEmpty ? nil : entry.homophones.joined(separator: String.space)
                let ipaText: String = OldCantonese.IPAText(of: entry.romanization)
                VStack(alignment: .leading) {
                        HStack(spacing: 16) {
                                HStack(spacing: 2) {
                                        Text(verbatim: "讀音").font(.copilot).shallow()
                                        Text.separator
                                        Text(verbatim: entry.pronunciation)
                                }
                                if let pronunciationMark = entry.pronunciationMark {
                                        Text(verbatim: pronunciationMark).font(.footnote).italic()
                                }
                        }
                        HStack(spacing: 16) {
                                HStack(spacing: 2) {
                                        Text(verbatim: "轉寫").font(.copilot).shallow()
                                        Text.separator
                                        Text(verbatim: entry.romanization).monospaced()
                                }
                                Text(verbatim:ipaText).font(.ipa).foregroundStyle(Color.secondary)
                                Spacer()
                                Speaker(entry.romanization).opacity(entry.romanization.isValidJyutpingSyllable ? 1 : 0)
                        }
                        VStack(alignment: .leading, spacing: 8) {
                                if let homophoneText {
                                        HStack(spacing: 2) {
                                                Text(verbatim: "同音").font(.copilot).shallow()
                                                Text.separator
                                                Text(verbatim: homophoneText)
                                        }
                                }
                                if let interpretation = entry.interpretation {
                                        HStack(alignment: .firstTextBaseline, spacing: 2) {
                                                Text(verbatim: "釋義").font(.copilot).shallow()
                                                Text.separator
                                                Text(verbatim: interpretation)
                                        }
                                }
                        }
                }
        }
}

#endif
