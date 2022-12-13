import SwiftUI

@available(iOS 15.0, *)
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
                        Spacer()
                }
        }
}
