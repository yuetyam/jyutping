import SwiftUI
import CoreIME
import CommonExtensions

struct SettingsView: View {

        @EnvironmentObject private var context: KeyboardViewController

        /// Example: 1.0.1 (23)
        private let version: String = {
                let marketingVersion: String = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? "error"
                let currentProjectVersion: String = (Bundle.main.infoDictionary?["CFBundleVersion"] as? String) ?? "null"
                return marketingVersion + " (" + currentProjectVersion + ")"
        }()

        @State private var isAudioFeedbackOn: Bool = AudioFeedback.fetchSavedState()
        @State private var hapticFeedback: HapticFeedback = HapticFeedback.fetchSavedMode()
        @State private var useKeyPadNumericLayout: Bool = NumericLayout.fetchSavedLayout().isDedicated
        @State private var needsNumberRow: Bool = Options.needsNumberRow
        @State private var showLowercaseKeys: Bool = Options.showLowercaseKeys
        @State private var keyTextPreview: Bool = Options.fetchKeyTextPreviewState()
        @State private var keyHeightOffset: CGFloat = Options.fetchKeyHeightOffset()
        @State private var inputKeyStyle: InputKeyStyle = InputKeyStyle.fetchSavedStyle()
        @State private var appearanceStyle: AppearanceStyle = AppearanceStyle.fetchSavedStyle()
        @State private var preferredInputMode: PreferredInputMode = PreferredInputMode.saved
        @State private var commentStyle: CommentStyle = Options.commentStyle
        @State private var commentScene: CommentScene = Options.commentScene
        @State private var commentToneStyle: CommentToneStyle = Options.commentToneStyle
        @State private var traditionalCharacterStandard: CharacterStandard = Options.traditionalCharacterStandard
        @State private var useDedicatedStrokeLayout: Bool = StrokeLayout.fetchSavedLayout().isDedicated
        @State private var cangjieVariant: CangjieVariant = Options.cangjieVariant
        @State private var isEmojiSuggestionsOn: Bool = Options.isEmojiSuggestionsOn
        @State private var isEnglishSuggestionsOn: Bool = Options.isEnglishSuggestionsOn
        @State private var isTextReplacementsOn: Bool = Options.isTextReplacementsOn
        @State private var isCompatibleModeOn: Bool = Options.isCompatibleModeOn
        @State private var preferredLanguage: KeyboardDisplayLanguage = Options.preferredLanguage
        @State private var isInputMemoryOn: Bool = Options.isInputMemoryOn

        @State private var isTryingToClearInputMemory: Bool = false
        @State private var isPerformingClearInputMemory: Bool = false
        @State private var clearInputMemoryProgress: Double = 0

        @ObservedObject private var transfer = InputMemoryTransferController.shared

        var body: some View {
                VStack(spacing: 0) {
                        ZStack {
                                Text("SettingsView.NavigationBar.HintText").font(.footnote).shallow()
                                HStack {
                                        NavigationLeadingBackButton()
                                        Spacer()
                                        NavigationTrailingExpansionButton()
                                }
                        }
                        .frame(height: context.keyboardInterface.isCompact ? PresetConstant.buttonLength : PresetConstant.buttonLengthXL)
                        List {
                                Section {
                                        Toggle("SettingsView.KeyboardFeedback.Sound.ToggleTitle", isOn: $isAudioFeedbackOn)
                                                .onChange(of: isAudioFeedbackOn) { _, newState in
                                                        context.updateAudioFeedbackState(to: newState)
                                                }
                                        if context.isRunningOnPhone {
                                                HStack(spacing: 0) {
                                                        Text("SettingsView.KeyboardFeedback.Haptic.PickerTitle").minimumScaleFactor(0.4).lineLimit(1)
                                                        Spacer()
                                                        Picker("SettingsView.KeyboardFeedback.Haptic.PickerTitle", selection: $hapticFeedback) {
                                                                Text("SettingsView.KeyboardFeedback.Haptic.Option.None").tag(HapticFeedback.disabled)
                                                                Text("SettingsView.KeyboardFeedback.Haptic.Option.Light").tag(HapticFeedback.light)
                                                                Text("SettingsView.KeyboardFeedback.Haptic.Option.Medium").tag(HapticFeedback.medium)
                                                                Text("SettingsView.KeyboardFeedback.Haptic.Option.Heavy").tag(HapticFeedback.heavy)
                                                        }
                                                        .pickerStyle(.segmented)
                                                        .labelsHidden()
                                                        .fixedSize()
                                                        .onChange(of: hapticFeedback) { _, newMode in
                                                                context.performAudioFeedback(.modify)
                                                                context.triggerSelectionHapticFeedback()
                                                                context.updateHapticFeedbackMode(to: newMode)
                                                        }
                                                }
                                                .disabled(context.hasFullAccess.negative)
                                        }
                                } footer: {
                                        if context.isRunningOnPhone && context.hasFullAccess.negative {
                                                Text("SettingsView.KeyboardFeedback.SectionFooter").textCase(nil)
                                        }
                                }

                                Section {
                                        if context.isRunningOnPhone {
                                                Toggle("SettingsView.NumericLayout.ToggleTitle", isOn: $useKeyPadNumericLayout)
                                                        .onChange(of: useKeyPadNumericLayout) { _, isOn in
                                                                context.performAudioFeedback(.modify)
                                                                let newLayout: NumericLayout = isOn ? .dedicated : .default
                                                                context.updateNumericLayout(to: newLayout)
                                                        }
                                                Toggle("SettingsView.NumberRow.ToggleTitle", isOn: $needsNumberRow)
                                                        .onChange(of: needsNumberRow) { _, isOn in
                                                                context.performAudioFeedback(.modify)
                                                                context.updateNumberRowState(to: isOn)
                                                        }
                                        }
                                        Toggle("SettingsView.ShowLowercaseKeys.ToggleTitle", isOn: $showLowercaseKeys)
                                                .onChange(of: showLowercaseKeys) { _, newState in
                                                        context.performAudioFeedback(.modify)
                                                        Options.updateShowLowercaseKeys(to: newState)
                                                }
                                        Toggle("SettingsView.KeyTextPreview.ToggleTitle", isOn: $keyTextPreview)
                                                .onChange(of: keyTextPreview) { _, newState in
                                                        context.performAudioFeedback(.modify)
                                                        context.updateKeyTextPreview(to: newState)
                                                }
                                }

                                Section {
                                        Slider(value: $keyHeightOffset, in: (-7...7), step: 1) {
                                                Text("SettingsView.KeyHeightOffset.SliderTitle")
                                        } minimumValueLabel: {
                                                Text(verbatim: "-7")
                                        } maximumValueLabel: {
                                                Text(verbatim: "+7")
                                        } onEditingChanged: { isEditing in
                                                if isEditing.negative {
                                                        context.updateKeyHeightOffset(to: keyHeightOffset)
                                                }
                                        }
                                } header: {
                                        HStack(spacing: 2) {
                                                Text("SettingsView.KeyHeightOffset.SliderTitle")
                                                Text(verbatim: ": ")
                                                Text(keyHeightOffset, format: .number.sign(strategy: .always()).grouping(.never))
                                        }
                                        .textCase(nil)
                                }

                                if context.isRunningOnPhone {
                                        Section {
                                                HStack(spacing: 0) {
                                                        Text("SettingsView.InputKeyStyle.PickerTitle").minimumScaleFactor(0.4).lineLimit(1)
                                                        Spacer()
                                                        Picker("SettingsView.InputKeyStyle.PickerTitle", selection: $inputKeyStyle) {
                                                                Text("SettingsView.InputKeyStyle.Option1.None").tag(InputKeyStyle.clear)
                                                                Text("SettingsView.InputKeyStyle.Option2.Numbers").tag(InputKeyStyle.numbers)
                                                                Text("SettingsView.InputKeyStyle.Option3.Symbols").tag(InputKeyStyle.symbols)
                                                        }
                                                        .pickerStyle(.segmented)
                                                        .labelsHidden()
                                                        .fixedSize()
                                                        .onChange(of: inputKeyStyle) { _, newStyle in
                                                                context.performAudioFeedback(.modify)
                                                                context.triggerSelectionHapticFeedback()
                                                                context.updateInputKeyStyle(to: newStyle)
                                                        }
                                                }
                                        }
                                        Section {
                                                HStack(spacing: 0) {
                                                        Text("SettingsView.AppearanceStyle.PickerTitle").minimumScaleFactor(0.4).lineLimit(1)
                                                        Spacer()
                                                        Picker("SettingsView.AppearanceStyle.PickerTitle", selection: $appearanceStyle) {
                                                                if #available(iOSApplicationExtension 26.0, *) {
                                                                        Text("SettingsView.AppearanceStyle.Option1.Clean").tag(AppearanceStyle.clean)
                                                                        Text("SettingsView.AppearanceStyle.Option2.Glass").tag(AppearanceStyle.glass)
                                                                        Text("SettingsView.AppearanceStyle.Option3.Classic").tag(AppearanceStyle.classic)
                                                                } else {
                                                                        Text("SettingsView.AppearanceStyle.Option3.Classic").tag(AppearanceStyle.classic)
                                                                        Text("SettingsView.AppearanceStyle.Option1.Clean").tag(AppearanceStyle.clean)
                                                                }
                                                        }
                                                        .pickerStyle(.segmented)
                                                        .labelsHidden()
                                                        .fixedSize()
                                                        .onChange(of: appearanceStyle) { _, newOption in
                                                                context.performAudioFeedback(.modify)
                                                                context.triggerSelectionHapticFeedback()
                                                                context.updateAppearanceStyle(to: newOption)
                                                        }
                                                }
                                        }
                                }

                                Section {
                                        HStack(spacing: 0) {
                                                Text("SettingsView.PreferredInputMode.PickerTitle").minimumScaleFactor(0.4).lineLimit(1)
                                                Spacer()
                                                Picker("SettingsView.PreferredInputMode.PickerTitle", selection: $preferredInputMode) {
                                                        Text("SettingsView.PreferredInputMode.Option1.Cantonese").tag(PreferredInputMode.cantonese)
                                                        Text("SettingsView.PreferredInputMode.Option2.ABC").tag(PreferredInputMode.abc)
                                                        Text("SettingsView.PreferredInputMode.Option3.Previous").tag(PreferredInputMode.previous)
                                                }
                                                .pickerStyle(.segmented)
                                                .labelsHidden()
                                                .fixedSize()
                                                .onChange(of: preferredInputMode) { _, newMode in
                                                        context.performAudioFeedback(.modify)
                                                        context.triggerSelectionHapticFeedback()
                                                        PreferredInputMode.updateSaved(mode: newMode)
                                                }
                                        }
                                }

                                Section {
                                        HStack(spacing: 0) {
                                                Text("SettingsView.CommentStyle.PickerTitle").minimumScaleFactor(0.4).lineLimit(1)
                                                Spacer()
                                                Picker("SettingsView.CommentStyle.PickerTitle", selection: $commentStyle) {
                                                        Text("SettingsView.CommentStyle.Option.Above").tag(CommentStyle.aboveCandidates)
                                                        Text("SettingsView.CommentStyle.Option.Below").tag(CommentStyle.belowCandidates)
                                                }
                                                .pickerStyle(.segmented)
                                                .labelsHidden()
                                                .fixedSize()
                                                .onChange(of: commentStyle) { _, newStyle in
                                                        context.performAudioFeedback(.modify)
                                                        context.triggerSelectionHapticFeedback()
                                                        Options.updateCommentStyle(to: newStyle)
                                                }
                                        }
                                        HStack(spacing: 0) {
                                                Text("SettingsView.CommentScene.PickerTitle").minimumScaleFactor(0.4).lineLimit(1)
                                                Spacer()
                                                Picker("SettingsView.CommentScene.PickerTitle", selection: $commentScene) {
                                                        Text("SettingsView.CommentScene.Option.All").tag(CommentScene.all)
                                                        Text("SettingsView.CommentScene.Option.Lookup").tag(CommentScene.reverseLookup)
                                                        Text("SettingsView.CommentScene.Option.None").tag(CommentScene.noneOfAll)
                                                }
                                                .pickerStyle(.segmented)
                                                .labelsHidden()
                                                .fixedSize()
                                                .onChange(of: commentScene) { _, scene in
                                                        context.performAudioFeedback(.modify)
                                                        context.triggerSelectionHapticFeedback()
                                                        Options.updateCommentScene(to: scene)
                                                }
                                        }
                                }

                                Section {
                                        Picker("SettingsView.CommentToneStyle.PickerTitle", selection: $commentToneStyle) {
                                                Text("SettingsView.CommentToneStyle.PickerOption1").tag(CommentToneStyle.normal)
                                                Text("SettingsView.CommentToneStyle.PickerOption2").tag(CommentToneStyle.noTones)
                                                Text("SettingsView.CommentToneStyle.PickerOption3").tag(CommentToneStyle.superscript)
                                                Text("SettingsView.CommentToneStyle.PickerOption4").tag(CommentToneStyle.subscript)
                                        }
                                        .pickerStyle(.inline)
                                        .labelsHidden()
                                        .onChange(of: commentToneStyle) { _, newStyle in
                                                context.performAudioFeedback(.modify)
                                                context.triggerSelectionHapticFeedback()
                                                Options.updateCommentToneStyle(to: newStyle)
                                        }
                                } header: {
                                        Text("SettingsView.CommentToneStyle.PickerTitle").textCase(nil)
                                }

                                Section {
                                        Picker("SettingsView.TraditionalCharacterStandard.PickerTitle", selection: $traditionalCharacterStandard) {
                                                Text("SettingsView.TraditionalCharacterStandard.Option1.Preset").tag(CharacterStandard.preset)
                                                Text("SettingsView.TraditionalCharacterStandard.Option6.HongKong").tag(CharacterStandard.hongkong)
                                                Text("SettingsView.TraditionalCharacterStandard.Option7.Taiwan").tag(CharacterStandard.taiwan)
                                                Text("SettingsView.TraditionalCharacterStandard.Option8.PRCGeneral").tag(CharacterStandard.prcGeneral)
                                                Text("SettingsView.TraditionalCharacterStandard.Option9.AncientBooksPublishing").tag(CharacterStandard.ancientBooksPublishing)
                                                Text("SettingsView.TraditionalCharacterStandard.Option3.Inherited").tag(CharacterStandard.inherited)
                                        }
                                        .pickerStyle(.inline)
                                        .labelsHidden()
                                        .onChange(of: traditionalCharacterStandard) { _, newStandard in
                                                context.performAudioFeedback(.modify)
                                                context.triggerSelectionHapticFeedback()
                                                context.syncTraditionalCharacterStandard(to: newStandard)
                                                Options.updateTraditionalCharacterStandard(to: newStandard)
                                        }
                                } header: {
                                        Text("SettingsView.TraditionalCharacterStandard.SectionHeader").textCase(nil)
                                } footer: {
                                        Text("SettingsView.TraditionalCharacterStandard.SectionFooter").textCase(nil)
                                }

                                Section {
                                        Toggle("SettingsView.StrokeLayout.ToggleTitle", isOn: $useDedicatedStrokeLayout)
                                                .onChange(of: useDedicatedStrokeLayout) { _, isOn in
                                                        context.performAudioFeedback(.modify)
                                                        let newLayout: StrokeLayout = isOn ? .dedicated : .default
                                                        context.updateStrokeLayout(to: newLayout)
                                                }
                                } header: {
                                        Text("SettingsView.StrokeLayout.SectionHeader").textCase(nil)
                                }

                                Section {
                                        Picker("SettingsView.CangjieVariant.PickerTitle", selection: $cangjieVariant) {
                                                Text("SettingsView.CangjieVariant.PickerOption1").tag(CangjieVariant.cangjie5)
                                                Text("SettingsView.CangjieVariant.PickerOption2").tag(CangjieVariant.cangjie3)
                                                Text("SettingsView.CangjieVariant.PickerOption3").tag(CangjieVariant.quick5)
                                                Text("SettingsView.CangjieVariant.PickerOption4").tag(CangjieVariant.quick3)

                                        }
                                        .pickerStyle(.segmented)
                                        .labelsHidden()
                                        .fixedSize()
                                        .onChange(of: cangjieVariant) { _, newVariant in
                                                context.performAudioFeedback(.modify)
                                                context.triggerSelectionHapticFeedback()
                                                Options.updateCangjieVariant(to: newVariant)
                                        }
                                } header: {
                                        Text("SettingsView.CangjieVariant.PickerTitle").textCase(nil)
                                }

                                Section {
                                        Toggle("SettingsView.EmojiSuggestions.ToggleTitle", isOn: $isEmojiSuggestionsOn)
                                                .onChange(of: isEmojiSuggestionsOn) { _, newState in
                                                        context.performAudioFeedback(.modify)
                                                        Options.updateEmojiSuggestions(to: newState)
                                                }
                                        Toggle("SettingsView.EnglishSuggestions.ToggleTitle", isOn: $isEnglishSuggestionsOn)
                                                .onChange(of: isEnglishSuggestionsOn) { _, newState in
                                                        context.performAudioFeedback(.modify)
                                                        Options.updateEnglishSuggestions(to: newState)
                                                }
                                        Toggle("SettingsView.SystemLexicon.ToggleTitle", isOn: $isTextReplacementsOn)
                                                .onChange(of: isTextReplacementsOn) { _, newState in
                                                        context.performAudioFeedback(.modify)
                                                        Options.updateTextReplacementsMode(to: newState)
                                                }
                                        Toggle("SettingsView.SchemeRules.CompatibleMode.ToggleTitle", isOn: $isCompatibleModeOn)
                                                .onChange(of: isCompatibleModeOn) { _, newState in
                                                        context.performAudioFeedback(.modify)
                                                        Options.updateCompatibleMode(to: newState)
                                                }
                                } footer: {
                                        Text("SettingsView.SchemeRules.CompatibleMode.SectionFooter").textCase(nil)
                                }

                                Section {
                                        Picker("SettingsView.KeyboardDisplayLanguage.PickerTitle", selection: $preferredLanguage) {
                                                Text("SettingsView.KeyboardDisplayLanguage.Auto").tag(KeyboardDisplayLanguage.auto)
                                                Text(verbatim: "粵語").tag(KeyboardDisplayLanguage.cantonese)
                                                Text(verbatim: "English").tag(KeyboardDisplayLanguage.english)
                                                Text(verbatim: "Français").tag(KeyboardDisplayLanguage.french)
                                                Text(verbatim: "日本語").tag(KeyboardDisplayLanguage.japanese)
                                        }
                                        .pickerStyle(.menu)
                                        .textCase(nil)
                                        .onChange(of: preferredLanguage) { _, newOption in
                                                context.performAudioFeedback(.modify)
                                                context.triggerSelectionHapticFeedback()
                                                Options.updatePreferredLanguage(to: newOption)
                                        }
                                } footer: {
                                        Text("SettingsView.KeyboardDisplayLanguage.SectionFooter").textCase(nil)
                                }

                                Section {
                                        Toggle("SettingsView.InputMemory.ToggleTitle", isOn: $isInputMemoryOn)
                                                .onChange(of: isInputMemoryOn) { _, newState in
                                                        Options.updateInputMemory(to: newState)
                                                }

                                        ZStack {
                                                Color.clear
                                                        .sensoryFeedback(.warning, trigger: isTryingToClearInputMemory, condition: { $0.negative && $1 })
                                                        .sensoryFeedback(.success, trigger: isPerformingClearInputMemory, condition: { $0 && $1.negative })
                                                Menu {
                                                        Button(role: .destructive) {
                                                                context.performAudioFeedback(.modify)
                                                                context.triggerHapticFeedback()
                                                                clearInputMemoryProgress = 0
                                                                isPerformingClearInputMemory = true
                                                                InputMemory.deleteAll()
                                                                EmojiMaster.clearFrequent()
                                                        } label: {
                                                                Label("SettingsView.InputMemory.ClearInputMemory.ButtonTitle", systemImage: "trash")
                                                        }
                                                        .onAppear {
                                                                context.performAudioFeedback(.modify)
                                                                isTryingToClearInputMemory = true
                                                        }
                                                } label: {
                                                        HStack {
                                                                Label("SettingsView.InputMemory.ClearInputMemory.ButtonTitle", systemImage: "trash")
                                                                Spacer()
                                                        }
                                                        .foregroundStyle(Color.red)
                                                }
                                                .disabled(transfer.isTransferring)
                                                .opacity(isPerformingClearInputMemory ? 0.5 : 1)
                                                ProgressView(value: clearInputMemoryProgress).opacity(isPerformingClearInputMemory ? 1 : 0)
                                        }
                                        .task {
                                                while Task.isCancelled.negative {
                                                        try? await Task.sleep(for: .milliseconds(100)) // 0.1s
                                                        if isTryingToClearInputMemory {
                                                                isTryingToClearInputMemory = false
                                                        }
                                                        if isPerformingClearInputMemory {
                                                                if clearInputMemoryProgress < 1 {
                                                                        clearInputMemoryProgress += 0.1
                                                                } else {
                                                                        isPerformingClearInputMemory = false
                                                                }
                                                        }
                                                }
                                        }
                                }

                                Section {
                                        Button {
                                                guard isPerformingClearInputMemory.negative else { return }
                                                context.performAudioFeedback(.modify)
                                                transfer.presentExportDestinationPicker()
                                        } label: {
                                                HStack {
                                                        Label("SettingsView.ExportInputMemory.ButtonTitle", systemImage: "square.and.arrow.up")
                                                        Spacer()
                                                        if transfer.isExporting {
                                                                ProgressView()
                                                        }
                                                }
                                        }
                                        .disabled(transfer.isTransferring || isPerformingClearInputMemory)

                                        Button {
                                                guard isPerformingClearInputMemory.negative else { return }
                                                context.performAudioFeedback(.modify)
                                                transfer.presentImporter()
                                        } label: {
                                                HStack {
                                                        Label("SettingsView.ImportInputMemory.ButtonTitle", systemImage: "square.and.arrow.down")
                                                        Spacer()
                                                        if transfer.isImporting {
                                                                ProgressView()
                                                        }
                                                }
                                        }
                                        .disabled(transfer.isTransferring || isPerformingClearInputMemory)
                                } footer: {
                                        if let feedback = transfer.feedback {
                                                Text(feedback).textCase(nil)
                                        }
                                }

                                Section {
                                        Menu {
                                                Button {
                                                        UIPasteboard.general.string = version
                                                } label: {
                                                        Label("SettingsView.Version.Copy.ButtonTitle", systemImage: "doc.on.doc")
                                                }
                                        } label: {
                                                HStack {
                                                        Text("SettingsView.Version.LabelTitle")
                                                        Spacer()
                                                        Text(verbatim: version)
                                                }
                                                .foregroundStyle(Color.primary)
                                        }
                                }
                        }
                        .listSectionSpacing(.compact)
                        .scrollContentBackground(.hidden)
                        .background(Color.interactiveClear)
                }
                .fileImporter(isPresented: $transfer.isPickerPresented, allowedContentTypes: transfer.pickerContentTypes, onCompletion: transfer.completePicker)
                .onDisappear {
                        transfer.cancelExport()
                        if transfer.isTransferring.negative {
                                transfer.feedback = nil
                        }
                }
        }
}
