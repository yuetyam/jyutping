import SwiftUI

struct GeneralPreferencesView: View {

        @State private var isEmojiSuggestionsOn: Bool = Options.isEmojiSuggestionsOn

        @AppStorage(SettingsKey.CandidatePageSize) private var pageSize: Int = AppSettings.displayCandidatePageSize
        @AppStorage(SettingsKey.CandidateLineSpacing) private var lineSpacing: Int = AppSettings.candidateLineSpacing
        @AppStorage(SettingsKey.ToneDisplayStyle) private var toneDisplayStyle: Int = AppSettings.toneDisplayStyle.rawValue
        @AppStorage(SettingsKey.ToneDisplayColor) private var toneDisplayColor: Int = AppSettings.toneDisplayColor.rawValue

        private let pageSizeRange: Range<Int> = AppSettings.candidatePageSizeRange
        private let lineSpacingRange: Range<Int> = AppSettings.candidateLineSpacingRange

        var body: some View {
                ScrollView {
                        LazyVStack(spacing: 16) {
                                HStack {
                                        Toggle("GeneralPreferencesView.EmojiSuggestions", isOn: $isEmojiSuggestionsOn)
                                                .toggleStyle(.switch)
                                                .scaledToFit()
                                                .onChange(of: isEmojiSuggestionsOn) { newState in
                                                        Options.updateEmojiSuggestions(to: newState)
                                                }
                                        Spacer()
                                }
                                .block()
                                HStack {
                                        Picker("GeneralPreferencesView.CandidateCountPerPage", selection: $pageSize) {
                                                ForEach(pageSizeRange, id: \.self) {
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
                                        Picker("GeneralPreferencesView.CandidateLineSpacing", selection: $lineSpacing) {
                                                ForEach(lineSpacingRange, id: \.self) {
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
                                        Picker("GeneralPreferencesView.CommentToneStyle", selection: $toneDisplayStyle) {
                                                Text("GeneralPreferencesView.CommentToneStyle.Normal").tag(1)
                                                Text("GeneralPreferencesView.CommentToneStyle.NoTones").tag(2)
                                                Text("GeneralPreferencesView.CommentToneStyle.Superscript").tag(3)
                                                Text("GeneralPreferencesView.CommentToneStyle.Subscript").tag(4)
                                        }
                                        .scaledToFit()
                                        .pickerStyle(.radioGroup)
                                        .onChange(of: toneDisplayStyle) { newValue in
                                                AppSettings.updateToneDisplayStyle(to: newValue)
                                        }
                                        Spacer()
                                }
                                .block()
                                HStack {
                                        Picker("GeneralPreferencesView.CommentToneColor", selection: $toneDisplayColor) {
                                                Text("GeneralPreferencesView.CommentToneColor.Normal").tag(1)
                                                Text("GeneralPreferencesView.CommentToneColor.Shallow").tag(2)
                                        }
                                        .scaledToFit()
                                        .pickerStyle(.radioGroup)
                                        .onChange(of: toneDisplayColor) { newValue in
                                                AppSettings.updateToneDisplayColor(to: newValue)
                                        }
                                        Spacer()
                                }
                                .block()
                        }
                        .textSelection(.enabled)
                        .padding()
                }
                .navigationTitle("PreferencesView.NavigationTitle.General")
        }
}
