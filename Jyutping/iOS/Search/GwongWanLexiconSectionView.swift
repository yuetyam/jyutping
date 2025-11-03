#if os(iOS)

import SwiftUI
import AppDataSource
import CommonExtensions

struct GwongWanLexiconSectionView: View {
        let lexicon: GwongWanLexicon
        var body: some View {
                WordTextLabel(word: lexicon.word)
                ForEach(lexicon.units.indices, id: \.self) { index in
                        GwongWanCharacterView(entry: lexicon.units[index])
                }
        }
}

struct GwongWanCharacterView: View {
        let entry: GwongWanCharacter
        var body: some View {
                VStack(alignment: .leading, spacing: 8) {
                        HStack(spacing: 2) {
                                Text(verbatim: "讀音").font(.copilot).shallow()
                                Text.separator
                                HStack(spacing: 16) {
                                        Text(verbatim: entry.faancitText)
                                        Text(verbatim: entry.hierarchy).minimumScaleFactor(0.5).lineLimit(1)
                                }
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
