import SwiftUI

struct CandidateLayoutPreferencesView: View {

        @AppStorage(SettingsKeys.CandidatePageSize) private var pageSize: Int = AppSettings.displayCandidatePageSize

        var body: some View {
                ScrollView {
                        LazyVStack(spacing: 16) {
                                HStack {
                                        Picker("Candidate Count Per Page", selection: $pageSize) {
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
                                .block()
                        }
                        .padding()
                }
                .navigationTitle("Layouts")
        }
}
