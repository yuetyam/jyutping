#if os(macOS)

import SwiftUI
import CommonExtensions

struct CantoneseTextView: View {

        init(_ text: String) {
                self.text = text
                self.unicode = text.count == 1 ? text.first?.codePointsText : nil
        }

        private let text: String
        private let unicode: String?

        var body: some View {
                HStack(spacing: 16) {
                        HStack {
                                Text(verbatim: "文字")
                                Text.separator
                                Text(verbatim: text)
                        }
                        if let unicode {
                                Text(verbatim: unicode).font(.fixedWidth).opacity(0.66)
                        }
                        Spacer()
                        Speaker {
                                Speech.speak(text, isRomanization: false)
                        }
                }
        }
}

#endif
