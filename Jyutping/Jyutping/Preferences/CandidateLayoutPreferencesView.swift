import SwiftUI

struct CandidateLayoutPreferencesView: View {

        @AppStorage(SettingsKeys.CandidatePageSize) private var pageSize: Int = AppSettings.displayCandidatePageSize
        @AppStorage(SettingsKeys.CandidateLineSpacing) private var lineSpacing: Int = AppSettings.candidateLineSpacing
        @AppStorage(SettingsKeys.ToneDisplayStyle) private var toneDisplayStyle: Int = AppSettings.toneDisplayStyle.rawValue

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
                                HStack {
                                        Picker("Candidate Line Spacing", selection: $lineSpacing) {
                                                ForEach(2..<13, id: \.self) {
                                                        Text(verbatim: "\($0)").tag($0)
                                                }
                                        }
                                        .scaledToFit()
                                        .onChange(of: lineSpacing) { newLineSpacing in
                                                AppSettings.updateCandidateLineSpacing(to: newLineSpacing)
                                        }
                                        Spacer()
                                }
                                .block()
                                HStack {
                                        Picker("Comment(Jyutping) Tones Display", selection: $toneDisplayStyle) {
                                                Text("Normal").tag(1)
                                                Text("No Tones").tag(2)
                                                Text("Superscript").tag(3)
                                                Text("Subscript").tag(4)
                                        }
                                        .scaledToFit()
                                        .pickerStyle(.radioGroup)
                                        .onChange(of: toneDisplayStyle) { newValue in
                                                AppSettings.updateToneDisplayStyle(to: newValue)
                                        }
                                        Spacer()
                                }
                                .block()
                        }
                        .textSelection(.enabled)
                        .padding()
                }
                .navigationTitle("PreferencesView.NavigationTitle.Layouts")
        }
}
