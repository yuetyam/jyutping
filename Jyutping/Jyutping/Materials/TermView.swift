import SwiftUI

struct TermView: View {

        let term: Term

        // Longest String of Romanizations
        let placeholder: String

        #if os(macOS)
        private let spacing: CGFloat = 32
        #else
        private let spacing: CGFloat = 24
        #endif

        var body: some View {
                HStack {
                        HStack(spacing: spacing) {
                                Text(verbatim: term.name).font(.master).textSelection(.enabled)
                                ZStack(alignment: .leading) {
                                        Text(verbatim: placeholder).hidden()
                                        Text(verbatim: term.romanization).textSelection(.enabled)
                                }
                                .font(.body.monospaced())
                        }
                        Speaker(term.romanization)
                        if let comment = term.comment {
                                Text(verbatim: comment).font(.subheadline).textSelection(.enabled).foregroundColor(.secondary)
                        }
                        Spacer()
                }
        }
}

struct HeaderTermView: View {

        let term: Term

        var body: some View {
                #if os(macOS)
                HStack {
                        HStack(spacing: 32) {
                                Text(verbatim: term.name).font(.master)
                                Text(verbatim: term.romanization).font(.body.monospaced())
                        }
                        .textSelection(.enabled)
                        Speaker(term.romanization)
                        Spacer()
                }
                #else
                HStack(spacing: 16) {
                        VStack(alignment: .leading, spacing: 8) {
                                Text(verbatim: term.name).font(.master)
                                Text(verbatim: term.romanization).font(.footnote.monospaced())
                        }
                        .textSelection(.enabled)
                        Speaker(term.romanization)
                        Spacer()
                }
                #endif
        }
}
