#if os(macOS)

import SwiftUI
import AppDataSource
import CommonExtensions
import Linguistics

struct FanWanLexiconView: View {
        let lexicon: FanWanLexicon
        var body: some View {
                VStack(alignment: .leading, spacing: 2) {
                        Text(verbatim: "《分韻撮要》　佚名　廣州府　清初")
                                .font(.copilot)
                                .airy()
                        VStack(alignment: .leading) {
                                WordDisplayLabel(word: lexicon.word)
                                ForEach(lexicon.units.indices, id: \.self) { index in
                                        Divider()
                                        FanWanView(entry: lexicon.units[index])
                                }
                        }
                        .block()
                }
        }
}

private struct FanWanView: View {
        let entry: FanWanUnit
        var body: some View {
                let abstract: String = "\(entry.initial)母　\(entry.final)韻　\(entry.yamyeung)\(entry.tone)　\(entry.rhyme)小韻"
                let homophoneText: String? = entry.homophones.isEmpty ? nil : entry.homophones.joined(separator: String.space)
                let ipaText: String = OldCantonese.IPAText(of: entry.romanization)
                VStack(alignment: .leading) {
                        HStack {
                                Text(verbatim: "讀音").shallow()
                                Text.separator
                                Text(verbatim: abstract)
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
                                HStack(alignment: .firstTextBaseline) {
                                        Text(verbatim: "釋義").shallow()
                                        Text.separator
                                        Text(verbatim: entry.interpretation)
                                }
                        }
                }
        }
}

#endif
