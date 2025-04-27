#if os(macOS)

import SwiftUI
import AppDataSource
import CommonExtensions
import Linguistics

struct ChoHokLexiconView: View {
        let lexicon: [ChoHokYuetYamCitYiu]
        var body: some View {
                VStack(alignment: .leading, spacing: 2) {
                        Text(verbatim: "《初學粵音切要》　湛約翰（John Chalmers）　香港　1855")
                                .font(.copilot)
                                .opacity(0.66)
                        VStack(alignment: .leading) {
                                if let word = lexicon.first?.word {
                                        HStack(spacing: 16) {
                                                HStack {
                                                        Text(verbatim: "文字")
                                                        Text.separator
                                                        Text(verbatim: word)
                                                }
                                                if let unicode = word.first?.codePointsText {
                                                        Text(verbatim: unicode).font(.fixedWidth).opacity(0.66)
                                                }
                                        }
                                }
                                ForEach(lexicon.indices, id: \.self) { index in
                                        Divider()
                                        ChoHokYuetYamCitYiuView(entry: lexicon[index])
                                }
                        }
                        .block()
                }
        }
}

private struct ChoHokYuetYamCitYiuView: View {
        let entry: ChoHokYuetYamCitYiu
        var body: some View {
                let homophoneText: String? = entry.homophones.isEmpty ? nil : entry.homophones.joined(separator: String.space)
                let ipaText: String = OldCantonese.IPAText(of: entry.romanization)
                VStack(alignment: .leading) {
                        HStack(spacing: 16) {
                                HStack {
                                        Text(verbatim: "讀音")
                                        Text.separator
                                        Text(verbatim: entry.pronunciation).font(.title3)
                                }
                                Text(verbatim: entry.tone)
                                Text(verbatim: entry.faancit)
                        }
                        HStack(spacing: 16) {
                                HStack {
                                        Text(verbatim: "轉寫")
                                        Text.separator
                                        Text(verbatim: entry.romanization).font(.title3.monospaced())
                                }
                                Text(verbatim: ipaText).font(.ipa).opacity(0.66)
                                Spacer()
                                Speaker(entry.romanization).opacity(entry.romanization.isValidJyutpingSyllable ? 1 : 0)
                        }
                        if let homophoneText {
                                HStack {
                                        Text(verbatim: "同音")
                                        Text.separator
                                        Text(verbatim: homophoneText)
                                }
                        }
                }
        }
}

#endif
