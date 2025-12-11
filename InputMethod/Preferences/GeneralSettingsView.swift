import SwiftUI
import Combine
import CoreIME
import CommonExtensions

struct GeneralSettingsView: View {

        @State private var pageSize: Int = AppSettings.displayCandidatePageSize
        @State private var lineSpacing: Int = AppSettings.candidateLineSpacing
        @State private var pageCornerRadius: Int = AppSettings.pageCornerRadius
        @State private var contentInsets: Int = AppSettings.contentInsets
        @State private var innerCornerRadius: Int = AppSettings.innerCornerRadius
        private let pageSizeRange: ClosedRange<Int> = AppSettings.candidatePageSizeRange
        private let lineSpacingRange: ClosedRange<Int> = AppSettings.candidateLineSpacingRange
        private let cornerRadiusRange: ClosedRange<Int> = AppSettings.cornerRadiusRange

        @State private var orientation: CandidatePageOrientation = AppSettings.candidatePageOrientation
        @State private var commentDisplayStyle: CommentDisplayStyle = AppSettings.commentDisplayStyle
        @State private var toneDisplayStyle: ToneDisplayStyle = AppSettings.toneDisplayStyle
        @State private var toneDisplayColor: ToneDisplayColor = AppSettings.toneDisplayColor
        @State private var labelSet: LabelSet = AppSettings.labelSet
        @State private var isLabelLastZero: Bool = AppSettings.isLabelLastZero

        @State private var legacyCharacterStandard: CharacterStandard = Options.legacyCharacterStandard
        @State private var traditionalCharacterStandard: CharacterStandard = Options.traditionalCharacterStandard
        @State private var isEmojiSuggestionsOn: Bool = AppSettings.isEmojiSuggestionsOn
        @State private var isTextReplacementsOn: Bool = AppSettings.isTextReplacementsOn
        @State private var isCompatibleModeOn: Bool = AppSettings.isCompatibleModeOn
        @State private var isInputMemoryOn: Bool = AppSettings.isInputMemoryOn

        @State private var isClearInputMemoryConfirmDialogPresented: Bool = false
        @State private var isPerformingClearInputMemory: Bool = false
        @State private var clearInputMemoryProgress: Double = 0
        private let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

        var body: some View {
                ScrollView {
                        LazyVStack(alignment: .leading) {
                                Form {
                                        Section {
                                                Picker("GeneralPreferencesView.CandidateCountPerPage", selection: $pageSize) {
                                                        ForEach(pageSizeRange, id: \.self) {
                                                                Text(verbatim: "\($0)").tag($0)
                                                        }
                                                }
                                                .pickerStyle(.menu)
                                                .onChange(of: pageSize) { newPageSize in
                                                        AppSettings.updateDisplayCandidatePageSize(to: newPageSize)
                                                }
                                                Picker("GeneralPreferencesView.CandidateLineSpacing", selection: $lineSpacing) {
                                                        ForEach(lineSpacingRange, id: \.self) {
                                                                Text(verbatim: "\($0) pt").tag($0)
                                                        }
                                                }
                                                .pickerStyle(.menu)
                                                .onChange(of: lineSpacing) { newLineSpacing in
                                                        AppSettings.updateCandidateLineSpacing(to: newLineSpacing)
                                                }
                                                Picker("GeneralPreferencesView.CandidatePageCornerRadius", selection: $pageCornerRadius) {
                                                        ForEach(cornerRadiusRange, id: \.self) {
                                                                Text(verbatim: "\($0) pt").tag($0)
                                                        }
                                                }
                                                .pickerStyle(.menu)
                                                .onChange(of: pageCornerRadius) { newValue in
                                                        AppSettings.updatePageCornerRadius(to: newValue)
                                                }
                                                Picker("GeneralPreferencesView.CandidatePageInsets", selection: $contentInsets) {
                                                        ForEach(cornerRadiusRange, id: \.self) {
                                                                Text(verbatim: "\($0) pt").tag($0)
                                                        }
                                                }
                                                .pickerStyle(.menu)
                                                .onChange(of: contentInsets) { newValue in
                                                        AppSettings.updateContentInsets(to: newValue)
                                                }
                                                Picker("GeneralPreferencesView.CandidateCornerRadius", selection: $innerCornerRadius) {
                                                        ForEach(cornerRadiusRange, id: \.self) {
                                                                Text(verbatim: "\($0) pt").tag($0)
                                                        }
                                                }
                                                .pickerStyle(.menu)
                                                .onChange(of: innerCornerRadius) { newValue in
                                                        AppSettings.updateInnerCornerRadius(to: newValue)
                                                }
                                        }
                                        Section {
                                                Picker("GeneralPreferencesView.CandidatePageOrientation", selection: $orientation) {
                                                        Text("GeneralPreferencesView.CandidatePageOrientation.Horizontal").tag(CandidatePageOrientation.horizontal)
                                                        Text("GeneralPreferencesView.CandidatePageOrientation.Vertical").tag(CandidatePageOrientation.vertical)
                                                }
                                                .pickerStyle(.menu)
                                                .onChange(of: orientation) { newOption in
                                                        AppSettings.updateCandidatePageOrientation(to: newOption)
                                                }
                                        }
                                        Section {
                                                Picker("GeneralPreferencesView.CommentStyle", selection: $commentDisplayStyle) {
                                                        Text("GeneralPreferencesView.CommentStyle.Top").tag(CommentDisplayStyle.top)
                                                        Text("GeneralPreferencesView.CommentStyle.Bottom").tag(CommentDisplayStyle.bottom)
                                                        Text("GeneralPreferencesView.CommentStyle.Right").tag(CommentDisplayStyle.right)
                                                        Text("GeneralPreferencesView.CommentStyle.NoComments").tag(CommentDisplayStyle.noComments)
                                                }
                                                .pickerStyle(.menu)
                                                .onChange(of: commentDisplayStyle) { newStyle in
                                                        AppSettings.updateCommentDisplayStyle(to: newStyle)
                                                }
                                                Picker("GeneralPreferencesView.CommentToneStyle", selection: $toneDisplayStyle) {
                                                        Text("GeneralPreferencesView.CommentToneStyle.Normal").tag(ToneDisplayStyle.normal)
                                                        Text("GeneralPreferencesView.CommentToneStyle.NoTones").tag(ToneDisplayStyle.noTones)
                                                        Text("GeneralPreferencesView.CommentToneStyle.Superscript").tag(ToneDisplayStyle.superscript)
                                                        Text("GeneralPreferencesView.CommentToneStyle.Subscript").tag(ToneDisplayStyle.subscript)
                                                }
                                                .pickerStyle(.menu)
                                                .onChange(of: toneDisplayStyle) { newStyle in
                                                        AppSettings.updateToneDisplayStyle(to: newStyle)
                                                }
                                                Picker("GeneralPreferencesView.CommentToneColor", selection: $toneDisplayColor) {
                                                        Text("GeneralPreferencesView.CommentToneColor.Normal").tag(ToneDisplayColor.normal)
                                                        Text("GeneralPreferencesView.CommentToneColor.Shallow").tag(ToneDisplayColor.shallow)
                                                }
                                                .pickerStyle(.menu)
                                                .onChange(of: toneDisplayColor) { newOption in
                                                        AppSettings.updateToneDisplayColor(to: newOption)
                                                }
                                        }
                                        Section {
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
                                                        Text("GeneralPreferencesView.LabelSet.Stems").tag(LabelSet.stems)
                                                        Text("GeneralPreferencesView.LabelSet.Branches").tag(LabelSet.branches)
                                                }
                                                .pickerStyle(.menu)
                                                .onChange(of: labelSet) { newOption in
                                                        AppSettings.updateLabelSet(to: newOption)
                                                }
                                                Toggle("GeneralPreferencesView.LabelLastZero.ToggleTitle", isOn: $isLabelLastZero)
                                                        .toggleStyle(.switch)
                                                        .onChange(of: isLabelLastZero) { newState in
                                                                AppSettings.updateLabelLastState(to: newState)
                                                        }
                                        }
                                        Section {
                                                Picker("GeneralPreferencesView.CharacterStandard.PickerTitle", selection: $legacyCharacterStandard) {
                                                        Text("GeneralPreferencesView.CharacterStandard.Traditional").tag(CharacterStandard.preset)
                                                        Text("GeneralPreferencesView.CharacterStandard.TraditionalKongKong").tag(CharacterStandard.hongkong)
                                                        Text("GeneralPreferencesView.CharacterStandard.TraditionalTaiwan").tag(CharacterStandard.taiwan)
                                                        Text("GeneralPreferencesView.CharacterStandard.Simplified").tag(CharacterStandard.mutilated)
                                                }
                                                .pickerStyle(.menu)
                                                .onChange(of: legacyCharacterStandard) { newStandard in
                                                        Options.updateLegacyCharacterStandard(to: newStandard)
                                                }
                                                Picker("GeneralPreferencesView.TraditionalCharacterStandard.PickerTitle", selection: $traditionalCharacterStandard) {
                                                        Text("GeneralPreferencesView.TraditionalCharacterStandard.Option1.Preset").tag(CharacterStandard.preset)
                                                        #if DEBUG
                                                        Text("GeneralPreferencesView.TraditionalCharacterStandard.Option3.Inherited").tag(CharacterStandard.inherited)
                                                        #endif
                                                        Text("GeneralPreferencesView.TraditionalCharacterStandard.Option6.HongKong").tag(CharacterStandard.hongkong)
                                                        Text("GeneralPreferencesView.TraditionalCharacterStandard.Option7.Taiwan").tag(CharacterStandard.taiwan)
                                                        Text("GeneralPreferencesView.TraditionalCharacterStandard.Option8.PRCGeneral").tag(CharacterStandard.prcGeneral)
                                                        Text("GeneralPreferencesView.TraditionalCharacterStandard.Option9.AncientBooksPublishing").tag(CharacterStandard.ancientBooksPublishing)
                                                }
                                                .pickerStyle(.menu)
                                                .onChange(of: traditionalCharacterStandard) { newStandard in
                                                        Options.updateTraditionalCharacterStandard(to: newStandard)
                                                }
                                                Toggle("GeneralPreferencesView.EmojiSuggestions.ToggleTitle", isOn: $isEmojiSuggestionsOn)
                                                        .toggleStyle(.switch)
                                                        .onChange(of: isEmojiSuggestionsOn) { newState in
                                                                AppSettings.updateEmojiSuggestions(to: newState)
                                                        }
                                                Toggle("GeneralPreferencesView.SystemLexicon.ToggleTitle", isOn: $isTextReplacementsOn)
                                                        .toggleStyle(.switch)
                                                        .onChange(of: isTextReplacementsOn) { newState in
                                                                AppSettings.updateTextReplacementsState(to: newState)
                                                        }
                                                Toggle("GeneralPreferencesView.SchemeRules.CompatibleMode.ToggleTitle", isOn: $isCompatibleModeOn)
                                                        .toggleStyle(.switch)
                                                        .onChange(of: isCompatibleModeOn) { newState in
                                                                AppSettings.updateCompatibleMode(to: newState)
                                                        }
                                        } footer: {
                                                Text("GeneralPreferencesView.SchemeRules.CompatibleMode.SectionFooter").textCase(nil)
                                        }
                                        Section {
                                                Toggle("GeneralPreferencesView.InputMemory.ToggleTitle", isOn: $isInputMemoryOn)
                                                        .toggleStyle(.switch)
                                                        .onChange(of: isInputMemoryOn) { newState in
                                                                AppSettings.updateInputMemoryState(to: newState)
                                                        }
                                                HStack {
                                                        Button(role: .destructive) {
                                                                isClearInputMemoryConfirmDialogPresented = true
                                                        } label: {
                                                                Text("GeneralPreferencesView.InputMemory.Clear.ButtonTitle").foregroundStyle(Color.red)
                                                        }
                                                        .confirmationDialog("GeneralPreferencesView.InputMemory.Clear.ConfirmationDialog.Title", isPresented: $isClearInputMemoryConfirmDialogPresented) {
                                                                Button("GeneralPreferencesView.InputMemory.Clear.ConfirmationDialog.Confirm", role: .destructive) {
                                                                        clearInputMemoryProgress = 0
                                                                        isPerformingClearInputMemory = true
                                                                        InputMemory.deleteAll()
                                                                }
                                                                Button("GeneralPreferencesView.InputMemory.Clear.ConfirmationDialog.Cancel", role: .cancel) {
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
                                                        ProgressView(value: clearInputMemoryProgress)
                                                                .progressViewStyle(.linear)
                                                                .opacity(isPerformingClearInputMemory ? 1 : 0)
                                                }
                                        }
                                }
                                .formStyle(.grouped)
                                .scrollContentBackground(.hidden)
                                .stack(cornerRadius: 16)
                                .frame(maxWidth: 480)
                        }
                        .padding(8)
                }
                .navigationTitle("GeneralPreferencesView.NavigationTitle.TitleKey")
        }
}
