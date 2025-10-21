#if os(macOS)

import SwiftUI
import AppDataSource
import CommonExtensions
import Linguistics

struct FanWanLexiconView: View {
        let lexicon: [FanWanCuetYiu]
        var body: some View {
                VStack(alignment: .leading, spacing: 2) {
                        Text(verbatim: "《分韻撮要》　佚名　廣州府　清初")
                                .font(.copilot)
                                .airy()
                        VStack(alignment: .leading) {
                                if let word = lexicon.first?.word {
                                        HStack(spacing: 16) {
                                                HStack {
                                                        Text(verbatim: "文字").shallow()
                                                        Text.separator
                                                        Text(verbatim: word).font(.display)
                                                }
                                                if let unicode = word.first?.codePointsText {
                                                        Text(verbatim: unicode).font(.fixedWidth).airy()
                                                }
                                        }
                                }
                                ForEach(lexicon.indices, id: \.self) { index in
                                        Divider()
                                        FanWanCuetYiuView(entry: lexicon[index])
                                }
                        }
                        .block()
                }
        }
}

private struct FanWanCuetYiuView: View {
        let entry: FanWanCuetYiu
        var body: some View {
                let homophoneText: String? = entry.homophones.isEmpty ? nil : entry.homophones.joined(separator: String.space)
                let ipaText: String = OldCantonese.IPAText(of: entry.romanization)
                VStack(alignment: .leading) {
                        HStack {
                                Text(verbatim: "讀音").shallow()
                                Text.separator
                                Text(verbatim: entry.abstract)
                        }
                        HStack(spacing: 16) {
                                HStack {
                                        Text(verbatim: "轉寫").shallow()
                                        Text.separator
                                        Text(verbatim: entry.romanization).font(.title3.monospaced())
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
                                .padding(.bottom, 1)
                        }
                        HStack {
                                Text(verbatim: "釋義").shallow()
                                Text.separator
                                Text(verbatim: entry.interpretation)
                        }
                }
        }
}

#endif
