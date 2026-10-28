import SwiftUI
import CommonExtensions
import CoreIME

@available(iOS 26.0, *)
@available(iOSApplicationExtension 26.0, *)
struct SymbolCandidateGlassDetailView: View {
        let candidate: Candidate
        var body: some View {
                ZStack {
                        Color.clear.glassEffect(.clear, in: .rect(cornerRadius: PresetConstant.sectionCornerRadius))
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
