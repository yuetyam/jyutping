import SwiftUI

struct TermView: View {
        let term: Term
        var body: some View {
                HStack(spacing: 18) {
                        TextPronunciationView(text: term.name, romanization: term.romanization)
                        Speaker(term.romanization)
                        if let emoji = term.emoji {
                                Text(verbatim: emoji)
                                        .font(.title3)
                                        .textSelection(.enabled)
                        }
                        if let comment = term.comment {
                                Text(verbatim: comment)
                                        .font(.copilot)
                                        .foregroundStyle(Color.secondary)
                                        .textSelection(.enabled)
                        }
                        Spacer()
                }
        }
}
