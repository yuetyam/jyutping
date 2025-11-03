#if os(macOS)

import SwiftUI
import CommonExtensions

struct WordDisplayLabel: View {
        let word: String
        var body: some View {
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
}

#endif
