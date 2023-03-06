import SwiftUI

struct TermView: View {

        let term: Term

        // Longest String of Romanizations
        let placeholder: String

        var body: some View {
                #if os(macOS)
                HStack(spacing: 32) {
                        Text(verbatim: term.name).font(.master)
                        ZStack(alignment: .leading) {
                                Text(verbatim: placeholder).hidden()
                                Text(verbatim: term.romanization)
                        }
                        .font(.fixedWidth)
                        Speaker(term.romanization)
                        if let emoji = term.emoji {
                                Text(verbatim: emoji).font(.title3)
                        }
                        if let comment = term.comment {
                                Text(verbatim: comment).font(.copilot).foregroundColor(.secondary)
                        }
                        Spacer()
                }
                .textSelection(.enabled)
                #else
                HStack(spacing: 20) {
                        Text(verbatim: term.name)
                        HStack {
                                ZStack(alignment: .leading) {
                                        Text(verbatim: placeholder).hidden()
                                        Text(verbatim: term.romanization)
                                }
                                .font(.fixedWidth)
                                Speaker(term.romanization)
                        }
                        if let emoji = term.emoji {
                                Text(verbatim: emoji)
                        }
                        if let comment = term.comment {
                                Text(verbatim: comment).font(.copilot).foregroundColor(.secondary)
                        }
                        Spacer()
                }
                .textSelection(.enabled)
                #endif
        }
}

struct HeaderTermView: View {

        let term: Term

        var body: some View {
                #if os(macOS)
                HStack {
                        HStack(spacing: 32) {
                                Text(verbatim: term.name).font(.master)
                                Text(verbatim: term.romanization).font(.fixedWidth)
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
                        Spacer()
                        Speaker(term.romanization)
                }
                #endif
        }
}
