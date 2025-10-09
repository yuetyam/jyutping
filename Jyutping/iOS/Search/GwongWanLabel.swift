#if os(iOS)

import SwiftUI
import AppDataSource
import CommonExtensions

struct GwongWanLexiconView: View {
        let lexicon: [GwongWanCharacter]
        var body: some View {
                if let firstEntry = lexicon.first {
                        HStack(spacing: 2) {
                                HStack(spacing: 2) {
                                        Text(verbatim: "文字").font(.copilot).shallow()
                                        Text.separator.font(.copilot)
                                        Text(verbatim: firstEntry.word)
                                }
                                if let unicode = firstEntry.word.first?.codePointsText {
                                        Text(verbatim: unicode).font(.footnote.monospaced()).foregroundStyle(Color.secondary)
                                }
                        }
                }
                ForEach(lexicon.indices, id: \.self) { index in
                        GwongWanLabel(entry: lexicon[index])
                }
        }
}

struct GwongWanLabel: View {
        let entry: GwongWanCharacter
        var body: some View {
                VStack(alignment: .leading, spacing: 8) {
                        HStack(spacing: 2) {
                                Text(verbatim: "讀音").shallow()
                                Text.separator
                                HStack(spacing: 16) {
                                        Text(verbatim: entry.faancitText).font(.body)
                                        Text(verbatim: entry.hierarchy).font(.body).minimumScaleFactor(0.5).lineLimit(1)
                                }
                        }
                        HStack(spacing: 2) {
                                Text(verbatim: "釋義").shallow()
                                Text.separator
                                Text(verbatim: entry.interpretation).font(.body)
                        }
                }
                .font(.copilot)
        }
}

#endif
