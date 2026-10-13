import SwiftUI
import CoreIME
import CommonExtensions

struct GeneralSettingsView: View {

        @State private var pageSize: Int = AppSettings.displayCandidatePageSize
        private let pageSizeRange: ClosedRange<Int> = AppSettings.candidatePageSizeRange

        @State private var orientation: CandidatePageOrientation = AppSettings.candidatePageOrientation
        @State private var commentDisplayScene: CommentDisplayScene = AppSettings.commentDisplayScene
        @State private var commentDisplayStyle: CommentDisplayStyle = AppSettings.commentDisplayStyle
        @State private var toneDisplayStyle: ToneDisplayStyle = AppSettings.toneDisplayStyle
        @State private var toneDisplayColor: ToneDisplayColor = AppSettings.toneDisplayColor
        @State private var labelSet: LabelSet = AppSettings.labelSet
        @State private var isLabelLastZero: Bool = AppSettings.isLabelLastZero

        @State private var legacyCharacterStandard: CharacterStandard = Options.legacyCharacterStandard
        @State private var traditionalCharacterStandard: CharacterStandard = Options.traditionalCharacterStandard
        @State private var isEmojiSuggestionsOn: Bool = AppSettings.isEmojiSuggestionsOn
        @State private var isEnglishSuggestionsOn: Bool = AppSettings.isEnglishSuggestionsOn
        @State private var isTextReplacementsOn: Bool = AppSettings.isTextReplacementsOn
        @State private var isCompatibleModeOn: Bool = AppSettings.isCompatibleModeOn

        var body: some View {
                ScrollView {
                        LazyVStack(alignment: .leading) {
                                Form {
                                        Section {
                                                Picker("GeneralSettingsView.CandidateCountPerPage", selection: $pageSize) {
                                                        ForEach(pageSizeRange, id: \.self) {
                                                                Text(verbatim: "\($0)").tag($0)
                                                        }
                                                }
                                                .pickerStyle(.menu)
                                                .onChange(of: pageSize) { newPageSize in
                                                        AppSettings.updateDisplayCandidatePageSize(to: newPageSize)
                                                }
                                                Picker("GeneralSettingsView.CandidatePageOrientation", selection: $orientation) {
                                                        Text("GeneralSettingsView.CandidatePageOrientation.Horizontal").tag(CandidatePageOrientation.horizontal)
                                                        Text("GeneralSettingsView.CandidatePageOrientation.Vertical").tag(CandidatePageOrientation.vertical)
                                                }
                                                .pickerStyle(.menu)
                                                .onChange(of: orientation) { newOption in
                                                        AppSettings.updateCandidatePageOrientation(to: newOption)
                                                }
                                        }
                                        Section {
                                                Picker("GeneralSettingsView.CommentScene", selection: $commentDisplayScene) {
                                                        Text("GeneralSettingsView.CommentScene.All").tag(CommentDisplayScene.all)
                                                        Text("GeneralSettingsView.CommentScene.Lookup").tag(CommentDisplayScene.reverseLookup)
                                                        Text("GeneralSettingsView.CommentScene.None").tag(CommentDisplayScene.noneOfAll)
                                                }
                                                .pickerStyle(.menu)
                                                .onChange(of: commentDisplayScene) { scene in
                                                        AppSettings.updateCommentDisplayScene(to: scene)
                                                }
                                                Picker("GeneralSettingsView.CommentStyle", selection: $commentDisplayStyle) {
                                                        Text("GeneralSettingsView.CommentStyle.Top").tag(CommentDisplayStyle.top)
                                                        Text("GeneralSettingsView.CommentStyle.Bottom").tag(CommentDisplayStyle.bottom)
                                                        Text("GeneralSettingsView.CommentStyle.Right").tag(CommentDisplayStyle.right)
                                                }
                                                .pickerStyle(.menu)
                                                .onChange(of: commentDisplayStyle) { newStyle in
                                                        AppSettings.updateCommentDisplayStyle(to: newStyle)
                                                }
                                                Picker("GeneralSettingsView.CommentToneStyle", selection: $toneDisplayStyle) {
                                                        Text("GeneralSettingsView.CommentToneStyle.Normal").tag(ToneDisplayStyle.normal)
                                                        Text("GeneralSettingsView.CommentToneStyle.NoTones").tag(ToneDisplayStyle.noTones)
                                                        Text("GeneralSettingsView.CommentToneStyle.Superscript").tag(ToneDisplayStyle.superscript)
                                                        Text("GeneralSettingsView.CommentToneStyle.Subscript").tag(ToneDisplayStyle.subscript)
                                                }
                                                .pickerStyle(.menu)
                                                .onChange(of: toneDisplayStyle) { newStyle in
                                                        AppSettings.updateToneDisplayStyle(to: newStyle)
                                                }
                                                Picker("GeneralSettingsView.CommentToneColor", selection: $toneDisplayColor) {
                                                        Text("GeneralSettingsView.CommentToneColor.Normal").tag(ToneDisplayColor.normal)
                                                        Text("GeneralSettingsView.CommentToneColor.Shallow").tag(ToneDisplayColor.shallow)
                                                }
                                                .pickerStyle(.menu)
                                                .onChange(of: toneDisplayColor) { newOption in
                                                        AppSettings.updateToneDisplayColor(to: newOption)
                                                }
                                        }
                                        Section {
                                                Picker("GeneralSettingsView.LabelSet", selection: $labelSet) {
                                                        Text("GeneralSettingsView.LabelSet.Arabic").tag(LabelSet.arabic)
                                                        Text("GeneralSettingsView.LabelSet.FullWidthArabic").tag(LabelSet.fullWidthArabic)
                                                        Text("GeneralSettingsView.LabelSet.Chinese").tag(LabelSet.chinese)
                                                        Text("GeneralSettingsView.LabelSet.CapitalizedChinese").tag(LabelSet.capitalizedChinese)
                                                        Text("GeneralSettingsView.LabelSet.VerticalCountingRods").tag(LabelSet.verticalCountingRods)
                                                        Text("GeneralSettingsView.LabelSet.HorizontalCountingRods").tag(LabelSet.horizontalCountingRods)
                                                        Text("GeneralSettingsView.LabelSet.Soochow").tag(LabelSet.soochow)
                                                        Text("GeneralSettingsView.LabelSet.Mahjong").tag(LabelSet.mahjong)
                                                        Text("GeneralSettingsView.LabelSet.Roman").tag(LabelSet.roman)
                                                        Text("GeneralSettingsView.LabelSet.SmallRoman").tag(LabelSet.smallRoman)
                                                        Text("GeneralSettingsView.LabelSet.Stems").tag(LabelSet.stems)
                                                        Text("GeneralSettingsView.LabelSet.Branches").tag(LabelSet.branches)
                                                }
                                                .pickerStyle(.menu)
                                                .onChange(of: labelSet) { newOption in
                                                        AppSettings.updateLabelSet(to: newOption)
                                                }
                                                Toggle("GeneralSettingsView.LabelLastZero.ToggleTitle", isOn: $isLabelLastZero)
                                                        .toggleStyle(.switch)
                                                        .onChange(of: isLabelLastZero) { newState in
                                                                AppSettings.updateLabelLastState(to: newState)
                                                        }
                                        }
                                        Section {
                                                Picker("GeneralSettingsView.CharacterStandard.PickerTitle", selection: $legacyCharacterStandard) {
                                                        Text("GeneralSettingsView.CharacterStandard.Traditional").tag(CharacterStandard.preset)
                                                        Text("GeneralSettingsView.CharacterStandard.HongKong").tag(CharacterStandard.hongkong)
                                                        Text("GeneralSettingsView.CharacterStandard.Taiwan").tag(CharacterStandard.taiwan)
                                                        Text("GeneralSettingsView.CharacterStandard.Simplified").tag(CharacterStandard.mutilated)
                                                }
                                                .pickerStyle(.menu)
                                                .onChange(of: legacyCharacterStandard) { newStandard in
                                                        Options.updateLegacyCharacterStandard(to: newStandard)
                                                }
                                                Picker("GeneralSettingsView.TraditionalCharacterStandard.PickerTitle", selection: $traditionalCharacterStandard) {
                                                        Text("GeneralSettingsView.TraditionalCharacterStandard.Option1.Preset").tag(CharacterStandard.preset)
                                                        Text("GeneralSettingsView.TraditionalCharacterStandard.Option6.HongKong").tag(CharacterStandard.hongkong)
                                                        Text("GeneralSettingsView.TraditionalCharacterStandard.Option7.Taiwan").tag(CharacterStandard.taiwan)
                                                        Text("GeneralSettingsView.TraditionalCharacterStandard.Option8.PRCGeneral").tag(CharacterStandard.prcGeneral)
                                                        Text("GeneralSettingsView.TraditionalCharacterStandard.Option9.AncientBooksPublishing").tag(CharacterStandard.ancientBooksPublishing)
                                                        Text("GeneralSettingsView.TraditionalCharacterStandard.Option3.Inherited").tag(CharacterStandard.inherited)
                                                }
                                                .pickerStyle(.menu)
                                                .onChange(of: traditionalCharacterStandard) { newStandard in
                                                        Options.updateTraditionalCharacterStandard(to: newStandard)
                                                }
                                        } footer: {
                                                Text("GeneralSettingsView.TraditionalCharacterStandard.SectionFooter").textCase(nil)
                                        }
                                        Section {
                                                Toggle("GeneralSettingsView.EmojiSuggestions.ToggleTitle", isOn: $isEmojiSuggestionsOn)
                                                        .toggleStyle(.switch)
                                                        .onChange(of: isEmojiSuggestionsOn) { newState in
                                                                AppSettings.updateEmojiSuggestions(to: newState)
                                                        }
                                                Toggle("GeneralSettingsView.EnglishSuggestions.ToggleTitle", isOn: $isEnglishSuggestionsOn)
                                                        .toggleStyle(.switch)
                                                        .onChange(of: isEnglishSuggestionsOn) { newState in
                                                                AppSettings.updateEnglishSuggestions(to: newState)
                                                        }
                                                Toggle("GeneralSettingsView.SystemLexicon.ToggleTitle", isOn: $isTextReplacementsOn)
                                                        .toggleStyle(.switch)
                                                        .onChange(of: isTextReplacementsOn) { newState in
                                                                AppSettings.updateTextReplacementsState(to: newState)
                                                        }
                                                Toggle("GeneralSettingsView.SchemeRules.CompatibleMode.ToggleTitle", isOn: $isCompatibleModeOn)
                                                        .toggleStyle(.switch)
                                                        .onChange(of: isCompatibleModeOn) { newState in
                                                                AppSettings.updateCompatibleMode(to: newState)
                                                        }
                                        } footer: {
                                                Text("GeneralSettingsView.SchemeRules.CompatibleMode.SectionFooter").textCase(nil)
                                        }
                                }
                                .formStyle(.grouped)
                                .scrollContentBackground(.hidden)
                                .stack(cornerRadius: 16)
                                .frame(maxWidth: 500)
                        }
                        .padding(8)
                }
                .navigationTitle("GeneralSettingsView.NavigationTitle.TitleKey")
        }
}
