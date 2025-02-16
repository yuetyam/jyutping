#if os(iOS)

import SwiftUI
import AppDataSource
import CommonExtensions
import Linguistics

struct ChoHokYuetYamCitYiuLexiconView: View {
        let lexicon: [ChoHokYuetYamCitYiu]
        var body: some View {
                if let firstEntry = lexicon.first {
                        HStack {
                                Text(verbatim: "文字").font(.copilot)
                                Text.separator.font(.copilot)
                                Text(verbatim: firstEntry.word)
                                if let unicode = firstEntry.word.first?.codePointsText {
                                        Text(verbatim: unicode).font(.footnote.monospaced()).foregroundStyle(Color.secondary)
                                }
                        }
                }
                ForEach(lexicon.indices, id: \.self) { index in
                        ChoHokYuetYamCitYiuPronunciationView(entry: lexicon[index])
                }
        }
}

private struct ChoHokYuetYamCitYiuPronunciationView: View {
        let entry: ChoHokYuetYamCitYiu
        var body: some View {
                let homophoneText: String? = entry.homophones.isEmpty ? nil : entry.homophones.joined(separator: String.space)
                let ipaText: String = OldCantonese.IPAText(of: entry.romanization)
                VStack(alignment: .leading) {
                        HStack(spacing: 16) {
                                HStack {
                                        Text(verbatim: "讀音")
                                        Text.separator
                                        Text(verbatim: entry.pronunciation).font(.body)
                                }
                                Text(verbatim: entry.tone)
                                Text(verbatim: entry.faancit)
                        }
                        HStack(spacing: 16) {
                                HStack {
                                        Text(verbatim: "轉寫")
                                        Text.separator
                                        Text(verbatim: entry.romanization).font(.fixedWidth)
                                }
                                Text(verbatim: ipaText).font(.body).foregroundStyle(Color.secondary)
                                Spacer()
                                Speaker(entry.romanization).opacity(entry.romanization.isValidJyutpingSyllable ? 1 : 0)
                        }
                        if let homophoneText {
                                HStack {
                                        Text(verbatim: "同音")
                                        Text.separator
                                        Text(verbatim: homophoneText).font(.body)
                                }
                        }
                }
                .font(.copilot)
        }
}

#endif
