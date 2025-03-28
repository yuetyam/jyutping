#if os(macOS)

import SwiftUI
import AppDataSource
import CommonExtensions

struct GwongWanLexiconView: View {
        let lexicon: [GwongWanCharacter]
        var body: some View {
                VStack(alignment: .leading, spacing: 2) {
                        Text(verbatim: "《大宋重修廣韻》　陳彭年等　北宋")
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
                                        GwongWanView(entry: lexicon[index])
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
                                Text(verbatim: "讀音")
                                Text.separator
                                HStack(spacing: 32) {
                                        Text(verbatim: entry.faancitText)
                                        Text(verbatim: entry.hierarchy)
                                }
                                Spacer()
                        }
                        HStack {
                                Text(verbatim: "釋義")
                                Text.separator
                                Text(verbatim: entry.interpretation)
                                Spacer()
                        }
                }
        }
}

#endif
