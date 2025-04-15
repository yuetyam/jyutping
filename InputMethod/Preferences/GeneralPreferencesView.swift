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
        @State private var labelSet: LabelSet = AppSettings.labelSet
        @State private var isLabelLastZero: Bool = AppSettings.isLabelLastZero

        @State private var characterStandard: CharacterStandard = Options.characterStandard
        @State private var isEmojiSuggestionsOn: Bool = Options.isEmojiSuggestionsOn
        @State private var isCompatibleModeOn: Bool = AppSettings.isCompatibleModeOn
        @State private var isInputMemoryOn: Bool = AppSettings.isInputMemoryOn

        @State private var isClearInputMemoryConfirmDialogPresented: Bool = false
        @State private var isPerformingClearInputMemory: Bool = false
        @State private var clearInputMemoryProgress: Double = 0
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
                                                .fixedSize()
                                                .onChange(of: pageSize) { newPageSize in
                                                        AppSettings.updateDisplayCandidatePageSize(to: newPageSize)
                                                }
                                                Spacer()
                                        }
                                        HStack {
                                                Picker("GeneralPreferencesView.CandidateLineSpacing", selection: $lineSpacing) {
                                                        ForEach(lineSpacingRange, id: \.self) {
                                                                Text(verbatim: "\($0) pt").tag($0)
                                                        }
                                                }
                                                .fixedSize()
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
                                        .fixedSize()
                                        .onChange(of: orientation) { newOption in
                                                AppSettings.updateCandidatePageOrientation(to: newOption)
                                        }
                                        Spacer()
                                }
                                .block()
                                VStack {
                                        HStack {
                                                Picker("GeneralPreferencesView.CommentStyle", selection: $commentDisplayStyle) {
                                                        Text("GeneralPreferencesView.CommentStyle.Top").tag(CommentDisplayStyle.top)
                                                        Text("GeneralPreferencesView.CommentStyle.Bottom").tag(CommentDisplayStyle.bottom)
                                                        Text("GeneralPreferencesView.CommentStyle.Right").tag(CommentDisplayStyle.right)
                                                        Text("GeneralPreferencesView.CommentStyle.NoComments").tag(CommentDisplayStyle.noComments)
                                                }
                                                .fixedSize()
                                                .onChange(of: commentDisplayStyle) { newStyle in
                                                        AppSettings.updateCommentDisplayStyle(to: newStyle)
                                                }
                                                Spacer()
                                        }
                                        HStack {
                                                Picker("GeneralPreferencesView.CommentToneStyle", selection: $toneDisplayStyle) {
                                                        Text("GeneralPreferencesView.CommentToneStyle.Normal").tag(ToneDisplayStyle.normal)
                                                        Text("GeneralPreferencesView.CommentToneStyle.NoTones").tag(ToneDisplayStyle.noTones)
                                                        Text("GeneralPreferencesView.CommentToneStyle.Superscript").tag(ToneDisplayStyle.superscript)
                                                        Text("GeneralPreferencesView.CommentToneStyle.Subscript").tag(ToneDisplayStyle.subscript)
                                                }
                                                .fixedSize()
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
                                                .fixedSize()
                                                .onChange(of: toneDisplayColor) { newOption in
                                                        AppSettings.updateToneDisplayColor(to: newOption)
                                                }
                                                Spacer()
                                        }
                                }
                                .block()
                                VStack {
                                        HStack {
                                                Picker("GeneralPreferencesView.LabelSet", selection: $labelSet) {
                                                        Text("GeneralPreferencesView.LabelSet.Arabic").tag(LabelSet.arabic)
                                                        Text("GeneralPreferencesView.LabelSet.FullWidthArabic").tag(LabelSet.fullWidthArabic)
                                                        Text("GeneralPreferencesView.LabelSet.Chinese").tag(LabelSet.chinese)
                                                        Text("GeneralPreferencesView.LabelSet.CapitalizedChinese").tag(LabelSet.capitalizedChinese)
                                                        Text("GeneralPreferencesView.LabelSet.VerticalCountingRods").tag(LabelSet.verticalCountingRods)
                                                        Text("GeneralPreferencesView.LabelSet.HorizontalCountingRods").tag(LabelSet.horizontalCountingRods)
                                                        Text("GeneralPreferencesView.LabelSet.Soochow").tag(LabelSet.soochow)
                                                        Text("GeneralPreferencesView.LabelSet.Mahjong").tag(LabelSet.mahjong)
                                                        Text("GeneralPreferencesView.LabelSet.Roman").tag(LabelSet.roman)
                                                        Text("GeneralPreferencesView.LabelSet.SmallRoman").tag(LabelSet.smallRoman)
                                                }
                                                .fixedSize()
                                                .onChange(of: labelSet) { newOption in
                                                        AppSettings.updateLabelSet(to: newOption)
                                                }
                                                Spacer()
                                        }
                                        HStack {
                                                Toggle("GeneralPreferencesView.Toggle.LabelLastZero", isOn: $isLabelLastZero)
                                                        .toggleStyle(.switch)
                                                        .fixedSize()
                                                        .onChange(of: isLabelLastZero) { newState in
                                                                AppSettings.updateLabelLastState(to: newState)
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
                                                .fixedSize()
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
                                        .padding(.horizontal, 8)
                                }
                                HStack {
                                        Toggle("GeneralPreferencesView.EmojiSuggestions", isOn: $isEmojiSuggestionsOn)
                                                .toggleStyle(.switch)
                                                .fixedSize()
                                                .onChange(of: isEmojiSuggestionsOn) { newState in
                                                        Options.updateEmojiSuggestions(to: newState)
                                                }
                                        Spacer()
                                }
                                .block()
                                HStack {
                                        Toggle("GeneralPreferencesView.SchemeRules.CompatibleMode", isOn: $isCompatibleModeOn)
                                                .toggleStyle(.switch)
                                                .fixedSize()
                                                .onChange(of: isCompatibleModeOn) { newState in
                                                        AppSettings.updateCompatibleMode(to: newState)
                                                }
                                        Spacer()
                                }
                                .block()
                                VStack(alignment: .leading, spacing: 2) {
                                        HStack {
                                                Toggle("GeneralPreferencesView.Toggle.InputMemory", isOn: $isInputMemoryOn)
                                                        .toggleStyle(.switch)
                                                        .fixedSize()
                                                        .onChange(of: isInputMemoryOn) { newState in
                                                                AppSettings.updateInputMemoryState(to: newState)
                                                        }
                                                Spacer()
                                        }
                                        VStack(alignment: .leading, spacing: 2) {
                                                ProgressView(value: clearInputMemoryProgress).opacity(isPerformingClearInputMemory ? 1 : 0)
                                                Button(role: .destructive) {
                                                        isClearInputMemoryConfirmDialogPresented = true
                                                } label: {
                                                        Text("GeneralPreferencesView.Button.ClearInputMemory")
                                                }
                                                .buttonStyle(.plain)
                                                .padding(.horizontal, 8)
                                                .padding(.vertical, 4)
                                                .foregroundStyle(Color.red)
                                                .background(Material.thick, in: RoundedRectangle(cornerRadius: 6, style: .continuous))
                                                .confirmationDialog("GeneralPreferencesView.ConfirmationDialog.ClearInputMemory.Title", isPresented: $isClearInputMemoryConfirmDialogPresented) {
                                                        Button("GeneralPreferencesView.ConfirmationDialog.ClearInputMemory.Confirm", role: .destructive) {
                                                                clearInputMemoryProgress = 0
                                                                isPerformingClearInputMemory = true
                                                                UserLexicon.deleteAll()
                                                        }
                                                        Button("GeneralPreferencesView.ConfirmationDialog.ClearInputMemory.Cancel", role: .cancel) {
                                                                isClearInputMemoryConfirmDialogPresented = false
                                                        }
                                                }
                                                .onReceive(timer) { _ in
                                                        guard isPerformingClearInputMemory else { return }
                                                        if clearInputMemoryProgress > 1 {
                                                                isPerformingClearInputMemory = false
                                                        } else {
                                                                clearInputMemoryProgress += 0.1
                                                        }
                                                }
                                        }
                                        .fixedSize()
                                }
                                .block()
                        }
                        .textSelection(.enabled)
                        .padding()
                }
                .navigationTitle("GeneralPreferencesView.NavigationTitle.TitleKey")
        }
}
