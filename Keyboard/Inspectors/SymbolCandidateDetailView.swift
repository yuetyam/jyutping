import SwiftUI
import CommonExtensions
import CoreIME

struct SymbolCandidateDetailView: View {
        let candidate: Candidate
        var body: some View {
                ZStack {
                        RoundedRectangle(cornerRadius: PresetConstant.sectionCornerRadius).fill(Material.ultraThick)
                        VStack(alignment: .leading, spacing: 16) {
                                HStack {
                                        Text(verbatim: candidate.text).font(.largeTitle)
                                        Spacer()
                                }
                                HStack(spacing: 2) {
                                        Text(verbatim: "Unicode")
                                        Text.separator
                                        Text(verbatim: candidate.text.map(\.codePointNotation).joined(separator: ", ")).monospaced().textSelection(.enabled)
                                }
                                .font(.footnote)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 16)
                }
                .padding(10)
        }
}
