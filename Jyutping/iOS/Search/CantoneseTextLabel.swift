#if os(iOS)

import SwiftUI
import CommonExtensions

struct CantoneseTextLabel: View {

        init(_ text: String) {
                self.text = text
                self.unicode = (text.count == 1) ? text.first!.codePointsText : nil
        }

        private let text: String
        private let unicode: String?

        var body: some View {
                HStack(spacing: 16) {
                        HStack {
                                Text(verbatim: "文字").font(.copilot)
                                Text.separator.font(.copilot)
                                Text(verbatim: text)
                        }
                        if let unicode {
                                Text(verbatim: unicode).font(.footnote.monospaced()).foregroundStyle(Color.secondary)
                        }
                        Spacer()
                        Speaker {
                                Speech.speak(text, isRomanization: false)
                        }
                }
        }
}

#endif
