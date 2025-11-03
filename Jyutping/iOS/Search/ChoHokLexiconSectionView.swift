#if os(iOS)

import SwiftUI
import AppDataSource
import CommonExtensions
import Linguistics

struct ChoHokLexiconSectionView: View {
        let lexicon: ChoHokLexicon
        var body: some View {
                WordTextLabel(word: lexicon.word)
                ForEach(lexicon.units.indices, id: \.self) { index in
                        ChoHokPronunciationUnitView(entry: lexicon.units[index])
                }
        }
}

private struct ChoHokPronunciationUnitView: View {
        let entry: ChoHokUnit
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
                                Text(verbatim: entry.tone)
                                Text(verbatim: entry.faancit)
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
