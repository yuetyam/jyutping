#if os(macOS)

import SwiftUI
import AppDataSource
import CommonExtensions

struct GwongWanLexiconView: View {
        let lexicon: GwongWanLexicon
        var body: some View {
                VStack(alignment: .leading, spacing: 2) {
                        Text(verbatim: "《大宋重修廣韻》　陳彭年等　北宋")
                                .font(.copilot)
                                .airy()
                        VStack(alignment: .leading) {
                                WordDisplayLabel(word: lexicon.word)
                                ForEach(lexicon.units.indices, id: \.self) { index in
                                        Divider()
                                        GwongWanView(entry: lexicon.units[index])
                                }
                        }
                        .block()
                }
        }
}

private struct GwongWanView: View {
        let entry: GwongWanCharacter
        var body: some View {
                VStack(alignment: .leading, spacing: 10) {
                        HStack {
                                Text(verbatim: "讀音").shallow()
                                Text.separator
                                HStack(spacing: 32) {
                                        Text(verbatim: entry.faancitText)
                                        Text(verbatim: entry.hierarchy)
                                }
                                Spacer()
                        }
                        HStack(alignment: .firstTextBaseline) {
                                Text(verbatim: "釋義").shallow()
                                Text.separator
                                Text(verbatim: entry.interpretation)
                                Spacer()
                        }
                }
        }
}

#endif
