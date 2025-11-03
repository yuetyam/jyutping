#if os(macOS)

import SwiftUI
import AppDataSource
import CommonExtensions
import Linguistics

struct YingWaaLexiconView: View {
        let lexicon: YingWaaLexicon
        var body: some View {
                VStack(alignment: .leading, spacing: 2) {
                        Text(verbatim: "《英華分韻撮要》　衛三畏（Samuel Wells Williams）　廣州　1856")
                                .font(.copilot)
                                .airy()
                        VStack(alignment: .leading) {
                                WordDisplayLabel(word: lexicon.word)
                                ForEach(lexicon.units.indices, id: \.self) { index in
                                        Divider()
                                        YingWaaView(entry: lexicon.units[index])
                                }
                        }
                        .block()
                }
        }
}

private struct YingWaaView: View {
        let entry: YingWaaUnit
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
                                if let pronunciationMark = entry.pronunciationMark {
                                        Text(verbatim: pronunciationMark).font(.body).italic()
                                }
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
                        VStack(alignment: .leading, spacing: 8) {
                                if let homophoneText {
                                        HStack {
                                                Text(verbatim: "同音").shallow()
                                                Text.separator
                                                Text(verbatim: homophoneText)
                                        }
                                }
                                if let interpretation = entry.interpretation {
                                        HStack(alignment: .firstTextBaseline) {
                                                Text(verbatim: "釋義").shallow()
                                                Text.separator
                                                Text(verbatim: interpretation)
                                        }
                                }
                        }
                }
        }
}

#endif
