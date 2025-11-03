#if os(macOS)

import SwiftUI
import AppDataSource
import CommonExtensions
import Linguistics

struct ChoHokLexiconView: View {
        let lexicon: ChoHokLexicon
        var body: some View {
                VStack(alignment: .leading, spacing: 2) {
                        Text(verbatim: "《初學粵音切要》　湛約翰（John Chalmers）　香港　1855")
                                .font(.copilot)
                                .airy()
                        VStack(alignment: .leading) {
                                WordDisplayLabel(word: lexicon.word)
                                ForEach(lexicon.units.indices, id: \.self) { index in
                                        Divider()
                                        ChoHokView(entry: lexicon.units[index])
                                }
                        }
                        .block()
                }
        }
}

private struct ChoHokView: View {
        let entry: ChoHokUnit
        var body: some View {
                let homophoneText: String? = entry.homophones.isEmpty ? nil : entry.homophones.joined(separator: String.space)
                let ipaText: String = OldCantonese.IPAText(of: entry.romanization)
                VStack(alignment: .leading) {
                        HStack(spacing: 16) {
                                HStack {
                                        Text(verbatim: "讀音").shallow()
                                        Text.separator
                                        Text(verbatim: entry.pronunciation).font(.title3)
                                }
                                Text(verbatim: entry.tone)
                                Text(verbatim: entry.faancit)
                        }
                        HStack(spacing: 16) {
                                HStack {
                                        Text(verbatim: "轉寫").shallow()
                                        Text.separator
                                        Text(verbatim: entry.romanization).font(.title3).monospaced()
                                }
                                Text(verbatim: ipaText).font(.ipa).airy()
                                Spacer()
                                Speaker(entry.romanization).opacity(entry.romanization.isValidJyutpingSyllable ? 1 : 0)
                        }
                        if let homophoneText {
                                HStack {
                                        Text(verbatim: "同音").shallow()
                                        Text.separator
                                        Text(verbatim: homophoneText)
                                }
                        }
                }
        }
}

#endif
