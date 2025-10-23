#if os(iOS)

import SwiftUI
import AppDataSource
import CommonExtensions
import Linguistics

struct ChoHokYuetYamCitYiuLexiconView: View {
        let lexicon: [ChoHokYuetYamCitYiu]
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
                                HStack(spacing: 2) {
                                        Text(verbatim: "讀音").font(.copilot).shallow()
                                        Text.separator
                                        Text(verbatim: entry.pronunciation)
                                }
                                HStack(spacing: 8) {
                                        Text(verbatim: entry.tone)
                                        Text(verbatim: entry.faancit)
                                }
                        }
                        HStack(spacing: 16) {
                                HStack(spacing: 2) {
                                        Text(verbatim: "轉寫").font(.copilot).shallow()
                                        Text.separator
                                        Text(verbatim: entry.romanization).monospaced()
                                }
                                Text(verbatim: ipaText).font(.ipa).foregroundStyle(Color.secondary)
                                Spacer()
                                Speaker(entry.romanization).opacity(entry.romanization.isValidJyutpingSyllable ? 1 : 0)
                        }
                        if let homophoneText {
                                HStack(spacing: 2) {
                                        Text(verbatim: "同音").font(.copilot).shallow()
                                        Text.separator
                                        Text(verbatim: homophoneText)
                                }
                        }
                }
        }
}

#endif
