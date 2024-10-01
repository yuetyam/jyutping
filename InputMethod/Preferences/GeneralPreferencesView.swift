import SwiftUI
import CommonExtensions
import CoreIME

struct GeneralPreferencesView: View {

        @State private var pageSize: Int = AppSettings.displayCandidatePageSize
        @State private var lineSpacing: Int = AppSettings.candidateLineSpacing
        private let pageSizeRange: Range<Int> = AppSettings.candidatePageSizeRange
        private let lineSpacingRange: Range<Int> = AppSettings.candidateLineSpacingRange

        @State private var orientation: CandidatePageOrientation = AppSettings.candidatePageOrientation
        @State private var commentDisplayStyle: CommentDisplayStyle = AppSettings.commentDisplayStyle
        @State private var toneDisplayStyle: ToneDisplayStyle = AppSettings.toneDisplayStyle
        @State private var toneDisplayColor: ToneDisplayColor = AppSettings.toneDisplayColor

        @State private var characterStandard: CharacterStandard = Options.characterStandard
        @State private var isEmojiSuggestionsOn: Bool = Options.isEmojiSuggestionsOn
        @State private var isInputMemoryOn: Bool = AppSettings.isInputMemoryOn

        @State private var isConfirmDialogPresented: Bool = false
        @State private var isPerformingClearUserLexicon: Bool = false
        @State private var clearUserLexiconProgress: Double = 0
        private let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

        var body: some View {
                ScrollView {
                        LazyVStack(spacing: 16) {
                                VStack {
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
                                }
                                .block()
                                HStack {
                                        Picker("GeneralPreferencesView.CandidatePageOrientation", selection: $orientation) {
                                                Text("GeneralPreferencesView.CandidatePageOrientation.Horizontal").tag(CandidatePageOrientation.horizontal)
                                                Text("GeneralPreferencesView.CandidatePageOrientation.Vertical").tag(CandidatePageOrientation.vertical)
                                        }
                                        .scaledToFit()
                                        .onChange(of: orientation) { newOption in
                                                AppSettings.updateCandidatePageOrientation(to: newOption)
                                        }
                                        Spacer()
                                }
                                .block()
                                HStack {
                                        Picker("GeneralPreferencesView.CommentStyle", selection: $commentDisplayStyle) {
                                                Text("GeneralPreferencesView.CommentStyle.Top").tag(CommentDisplayStyle.top)
                                                Text("GeneralPreferencesView.CommentStyle.Bottom").tag(CommentDisplayStyle.bottom)
                                                Text("GeneralPreferencesView.CommentStyle.Right").tag(CommentDisplayStyle.right)
                                                Text("GeneralPreferencesView.CommentStyle.NoComments").tag(CommentDisplayStyle.noComments)
                                        }
                                        .scaledToFit()
                                        .onChange(of: commentDisplayStyle) { newStyle in
                                                AppSettings.updateCommentDisplayStyle(to: newStyle)
                                        }
                                        Spacer()
                                }
                                .block()
                                VStack {
                                        HStack {
                                                Picker("GeneralPreferencesView.CommentToneStyle", selection: $toneDisplayStyle) {
                                                        Text("GeneralPreferencesView.CommentToneStyle.Normal").tag(ToneDisplayStyle.normal)
                                                        Text("GeneralPreferencesView.CommentToneStyle.NoTones").tag(ToneDisplayStyle.noTones)
                                                        Text("GeneralPreferencesView.CommentToneStyle.Superscript").tag(ToneDisplayStyle.superscript)
                                                        Text("GeneralPreferencesView.CommentToneStyle.Subscript").tag(ToneDisplayStyle.subscript)
                                                }
                                                .scaledToFit()
                                                .onChange(of: toneDisplayStyle) { newStyle in
                                                        AppSettings.updateToneDisplayStyle(to: newStyle)
                                                }
                                                Spacer()
                                        }
                                        HStack {
                                                Picker("GeneralPreferencesView.CommentToneColor", selection: $toneDisplayColor) {
                                                        Text("GeneralPreferencesView.CommentToneColor.Normal").tag(ToneDisplayColor.normal)
                                                        Text("GeneralPreferencesView.CommentToneColor.Shallow").tag(ToneDisplayColor.shallow)
                                                }
                                                .scaledToFit()
                                                .onChange(of: toneDisplayColor) { newOption in
                                                        AppSettings.updateToneDisplayColor(to: newOption)
                                                }
                                                Spacer()
                                        }
                                }
                                .block()
                                VStack(spacing: 2) {
                                        HStack {
                                                Picker("GeneralPreferencesView.CharacterStandard.PickerTitleKey", selection: $characterStandard) {
                                                        Text("GeneralPreferencesView.CharacterStandard.PickerOption.Traditional").tag(CharacterStandard.traditional)
                                                        Text("GeneralPreferencesView.CharacterStandard.PickerOption.TraditionalKongKong").tag(CharacterStandard.hongkong)
                                                        Text("GeneralPreferencesView.CharacterStandard.PickerOption.TraditionalTaiwan").tag(CharacterStandard.taiwan)
                                                        Text("GeneralPreferencesView.CharacterStandard.PickerOption.Simplified").tag(CharacterStandard.simplified)
                                                }
                                                .scaledToFit()
                                                .onChange(of: characterStandard) { newStandard in
                                                        Options.updateCharacterStandard(to: newStandard)
                                                }
                                                Spacer()
                                        }
                                        .block()
                                        HStack(spacing: 2) {
                                                Text("GeneralPreferencesView.CharacterStandard.PickerFooter.LeadingText")
                                                Text(verbatim: "Control")
                                                        .padding(.horizontal, 4)
                                                        .padding(.vertical, 2)
                                                        .background(Material.ultraThick, in: RoundedRectangle(cornerRadius: 4, style: .continuous))
                                                Text(verbatim: "+")
                                                Text(verbatim: "Shift")
                                                        .padding(.horizontal, 4)
                                                        .padding(.vertical, 2)
                                                        .background(Material.ultraThick, in: RoundedRectangle(cornerRadius: 4, style: .continuous))
                                                Text(verbatim: "+")
                                                Text(verbatim: "`")
                                                        .font(.body)
                                                        .padding(.horizontal, 6)
                                                        .padding(.vertical, 1)
                                                        .background(Material.ultraThick, in: RoundedRectangle(cornerRadius: 4, style: .continuous))
                                                Text("GeneralPreferencesView.CharacterStandard.PickerFooter.TrailingText").foregroundStyle(Color.secondary)
                                                Spacer()
                                        }
                                        .font(.subheadline)
                                        .padding(.horizontal, 12)
                                }
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
                                VStack(spacing: 2) {
                                        HStack {
                                                Text("GeneralPreferencesView.SectionHeader.UserLexicon")
                                                Spacer()
                                        }
                                        .font(.subheadline)
                                        .padding(.horizontal, 12)
                                        VStack(spacing: 20) {
                                                HStack {
                                                        Toggle("GeneralPreferencesView.Toggle.InputMemory", isOn: $isInputMemoryOn)
                                                                .toggleStyle(.switch)
                                                                .scaledToFit()
                                                                .onChange(of: isInputMemoryOn) { newState in
                                                                        AppSettings.updateInputMemory(to: newState)
                                                                }
                                                        Spacer()
                                                }
                                                HStack {
                                                        VStack(alignment: .leading, spacing: 1) {
                                                                Button(role: .destructive) {
                                                                        isConfirmDialogPresented = true
                                                                } label: {
                                                                        Text("GeneralPreferencesView.Button.ClearUserLexicon")
                                                                }
                                                                .buttonStyle(.plain)
                                                                .padding(.horizontal, 8)
                                                                .padding(.vertical, 4)
                                                                .foregroundStyle(Color.red)
                                                                .background(Material.thick, in: RoundedRectangle(cornerRadius: 6, style: .continuous))
                                                                .confirmationDialog("GeneralPreferencesView.ConfirmationDialog.ClearUserLexicon.Title", isPresented: $isConfirmDialogPresented) {
                                                                        Button("GeneralPreferencesView.ConfirmationDialog.ClearUserLexicon.Confirm", role: .destructive) {
                                                                                clearUserLexiconProgress = 0
                                                                                isPerformingClearUserLexicon = true
                                                                                UserLexicon.deleteAll()
                                                                        }
                                                                        Button("GeneralPreferencesView.ConfirmationDialog.ClearUserLexicon.Cancel", role: .cancel) {
                                                                                isConfirmDialogPresented = false
                                                                        }
                                                                }
                                                                ProgressView(value: clearUserLexiconProgress).opacity(isPerformingClearUserLexicon ? 1 : 0)
                                                        }
                                                        .fixedSize()
                                                        .onReceive(timer) { _ in
                                                                guard isPerformingClearUserLexicon else { return }
                                                                if clearUserLexiconProgress > 1 {
                                                                        isPerformingClearUserLexicon = false
                                                                } else {
                                                                        clearUserLexiconProgress += 0.1
                                                                }
                                                        }
                                                        Spacer()
                                                }
                                        }
                                        .padding(.horizontal, 12)
                                        .padding(.top, 12)
                                        .padding(.bottom, 1)
                                        .background(Color.textBackgroundColor, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
                                }
                        }
                        .textSelection(.enabled)
                        .padding()
                }
                .navigationTitle("GeneralPreferencesView.NavigationTitle.TitleKey")
        }
}
