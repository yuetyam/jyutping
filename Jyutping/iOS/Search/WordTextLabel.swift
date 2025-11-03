#if os(iOS)

import SwiftUI
import CommonExtensions

struct WordTextLabel: View {
        let word: String
        var body: some View {
                HStack(spacing: 16) {
                        HStack(spacing: 2) {
                                Text(verbatim: "文字").font(.copilot).shallow()
                                Text.separator
                                Text(verbatim: word)
                        }
                        if let unicode = word.first?.codePointsText {
                                Text(verbatim: unicode)
                                        .font(.footnote)
                                        .monospaced()
                                        .foregroundStyle(Color.secondary)
                        }
                }
        }
}

#endif
