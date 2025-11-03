#if os(iOS)

import SwiftUI
import AppDataSource
import CommonExtensions
import Linguistics

struct YingWaaLexiconSectionView: View {
        let lexicon: YingWaaLexicon
        var body: some View {
                WordTextLabel(word: lexicon.word)
                ForEach(lexicon.units.indices, id: \.self) { index in
                        YingWaaPronunciationUnitView(entry: lexicon.units[index])
                }
        }
}

private struct YingWaaPronunciationUnitView: View {
        let entry: YingWaaUnit
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
