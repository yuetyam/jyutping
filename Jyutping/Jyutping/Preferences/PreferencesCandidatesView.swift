import SwiftUI

struct PreferencesCandidatesView: View {

        @State private var pageSize: Int = AppSettings.displayCandidatePageSize
        @State private var candidateFontSize: Int = Int(AppSettings.candidateFontSize)

        var body: some View {
                ScrollView {
                        LazyVStack {
                                HStack {
                                        Picker("Candidate count per page", selection: $pageSize) {
                                                ForEach(5..<11, id: \.self) {
                                                        Text(verbatim: "\($0)").tag($0)
                                                }
                                        }
                                        .scaledToFit()
                                        .onChange(of: pageSize) { newPageSize in
                                                AppSettings.updateDisplayCandidatePageSize(to: newPageSize)
                                        }
                                        Spacer()
                                }
                                HStack {
                                        Picker("Candidate font size", selection: $candidateFontSize) {
                                                // FIXME: - Should be 14-24
                                                ForEach(14..<18, id: \.self) {
                                                        Text(verbatim: "\($0)").tag($0)
                                                }
                                        }
                                        .scaledToFit()
                                        .onChange(of: candidateFontSize) { newFontSize in
                                                AppSettings.updateCandidateFontSize(to: newFontSize)
                                        }
                                        Spacer()
                                }
                        }
                        .padding()
                }
                .navigationTitle("Candidates")
        }
}
