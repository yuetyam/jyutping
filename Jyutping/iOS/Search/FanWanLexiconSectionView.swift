#if os(iOS)

import SwiftUI
import AppDataSource
import CommonExtensions
import Linguistics

struct FanWanLexiconSectionView: View {
        let lexicon: FanWanLexicon
        var body: some View {
                WordTextLabel(word: lexicon.word)
                ForEach(lexicon.units.indices, id: \.self) { index in
                        FanWanPronunciationUnitView(entry: lexicon.units[index])
                }
        }
}

struct FanWanPronunciationUnitView: View {
        let entry: FanWanUnit
        var body: some View {
                let abstract: String = "\(entry.initial)母　\(entry.final)韻　\(entry.yamyeung)\(entry.tone)　\(entry.rhyme)小韻"
                let homophoneText: String? = entry.homophones.isEmpty ? nil : entry.homophones.joined(separator: String.space)
                let ipaText: String = OldCantonese.IPAText(of: entry.romanization)
                VStack(alignment: .leading) {
                        HStack(spacing: 2) {
                                Text(verbatim: "讀音").font(.copilot).shallow()
                                Text.separator
                                Text(verbatim: abstract).minimumScaleFactor(0.5).lineLimit(1)
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
                                .padding(.bottom, 4)
                        }
                        HStack(alignment: .firstTextBaseline, spacing: 2) {
                                Text(verbatim: "釋義").font(.copilot).shallow()
                                Text.separator
                                Text(verbatim: entry.interpretation)
                        }
                }
        }
}

#endif
