import SwiftUI
import CoreIME
import CommonExtensions

private struct LeadingNavigationButton: View {
        @EnvironmentObject private var context: KeyboardViewController
        var body: some View {
                HStack(spacing: 0) {
                        TransparentButton(width: 4, height: PresetConstant.buttonLength, action: action)
                        if #available(iOSApplicationExtension 26.0, *) {
                                Button(action: action) {
                                        ZStack{
                                                Color.interactiveClear
                                                Image.chevronUp
                                                        .resizable()
                                                        .scaledToFit()
                                                        .padding(12)
                                        }
                                        .frame(width: PresetConstant.buttonLength, height: PresetConstant.buttonLength)
                                }
                                .buttonStyle(.plain)
                                .glassEffect(.clear, in: .circle)
                        } else {
                                Button(action: action) {
                                        ZStack{
                                                Color.interactiveClear
                                                Image.chevronUp
                                                        .resizable()
                                                        .scaledToFit()
                                                        .padding(12)
                                        }
                                        .frame(width: PresetConstant.buttonLength, height: PresetConstant.buttonLength)
                                }
                                .buttonStyle(.plain)
                        }
                        TransparentButton(width: 12, height: PresetConstant.buttonLength, action: action)
                }
        }
        private func action() {
                AudioFeedback.modified()
                context.triggerHapticFeedback()
                context.updateKeyboardForm(to: context.previousKeyboardForm)
        }
}
private struct TrailingNavigationButton: View {
        @EnvironmentObject private var context: KeyboardViewController
        private let expandImageName: String = {
                if #available(iOSApplicationExtension 17.0, *) {
                        return "arrow.down.backward.and.arrow.up.forward"
                } else {
                        return "arrow.up.and.line.horizontal.and.arrow.down"
                }
        }()
        private let collapseImageName: String = {
                if #available(iOSApplicationExtension 17.0, *) {
                        return "arrow.up.forward.and.arrow.down.backward"
                } else {
                        return "arrow.down.and.line.horizontal.and.arrow.up"
                }
        }()
        var body: some View {
                HStack(spacing: 0) {
                        TransparentButton(width: 12, height: PresetConstant.buttonLength, action: action)
                        if #available(iOSApplicationExtension 26.0, *) {
                                Button(action: action) {
                                        ZStack {
                                                Color.interactiveClear
                                                Image(systemName: context.isKeyboardHeightExpanded ? collapseImageName : expandImageName)
                                                        .resizable()
                                                        .scaledToFit()
                                                        .padding(13)
                                        }
                                        .frame(width: PresetConstant.buttonLength, height: PresetConstant.buttonLength)
                                }
                                .buttonStyle(.plain)
                                .glassEffect(.clear, in: .circle)
                        } else {
                                Button(action: action) {
                                        ZStack {
                                                Color.interactiveClear
                                                Image(systemName: context.isKeyboardHeightExpanded ? collapseImageName : expandImageName)
                                                        .resizable()
                                                        .scaledToFit()
                                                        .padding(13)
                                        }
                                        .frame(width: PresetConstant.buttonLength, height: PresetConstant.buttonLength)
                                }
                                .buttonStyle(.plain)
                        }
                        TransparentButton(width: 4, height: PresetConstant.buttonLength, action: action)
                }
        }
        private func action() {
                AudioFeedback.modified()
                context.triggerHapticFeedback()
                context.toggleKeyboardHeight()
        }
}

@available(iOS 16.0, *)
@available(iOSApplicationExtension 16.0, *)
struct SettingsView: View {

        @EnvironmentObject private var context: KeyboardViewController

        /// Example: 1.0.1 (23)
        private let version: String = {
                let marketingVersion: String = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? "error"
                let currentProjectVersion: String = (Bundle.main.infoDictionary?["CFBundleVersion"] as? String) ?? "null"
                return marketingVersion + " (" + currentProjectVersion + ")"
        }()

        @State private var characterStandard: CharacterStandard = Options.characterStandard
        @State private var isAudioFeedbackOn: Bool = Options.isAudioFeedbackOn
        @State private var hapticFeedback: HapticFeedback = HapticFeedback.fetchSavedMode()
        @State private var keyboardLayout: KeyboardLayout = KeyboardLayout.fetchSavedLayout()
        @State private var isKeyPadNumericLayout: Bool = NumericLayout.fetchSavedLayout().isNumberKeyPad
        @State private var isTenKeyStrokeLayout: Bool = StrokeLayout.fetchSavedLayout().isTenKey
        @State private var needsNumberRow: Bool = Options.needsNumberRow
        @State private var showLowercaseKeys: Bool = Options.showLowercaseKeys
        @State private var keyTextPreview: Bool = Options.keyTextPreview
        @State private var inputKeyStyle: InputKeyStyle = Options.inputKeyStyle
        @State private var commentStyle: CommentStyle = Options.commentStyle
        @State private var commentToneStyle: CommentToneStyle = Options.commentToneStyle
        @State private var cangjieVariant: CangjieVariant = Options.cangjieVariant
        @State private var isEmojiSuggestionsOn: Bool = Options.isEmojiSuggestionsOn
        @State private var isTextReplacementsOn: Bool = Options.isTextReplacementsOn
        @State private var isCompatibleModeOn: Bool = Options.isCompatibleModeOn
        @State private var preferredLanguage: KeyboardDisplayLanguage = Options.preferredLanguage
        @State private var isInputMemoryOn: Bool = Options.isInputMemoryOn

        @State private var isTryingToClearInputMemory: Bool = false
        @State private var isPerformingClearInputMemory: Bool = false
        @State private var clearInputMemoryProgress: Double = 0
        private let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

        var body: some View {
                VStack(spacing: 0) {
                        ZStack {
                                Text("SettingsView.NavigationBar.HintText")
                                        .font(.footnote)
                                        .shallow()
                                HStack {
                                        LeadingNavigationButton()
                                        Spacer()
                                        TrailingNavigationButton()
                                }
                        }
                        .frame(height: PresetConstant.buttonLength)
                        List {
                                Picker("SettingsView.CharacterStandard.PickerTitle", selection: $characterStandard) {
                                        Text("SettingsView.CharacterStandard.Option.Traditional").tag(CharacterStandard.traditional)
                                        Text("SettingsView.CharacterStandard.Option.TraditionalHongKong").tag(CharacterStandard.hongkong)
                                        Text("SettingsView.CharacterStandard.Option.TraditionalTaiwan").tag(CharacterStandard.taiwan)
                                        Text("SettingsView.CharacterStandard.Option.Simplified").tag(CharacterStandard.simplified)
                                }
                                .pickerStyle(.inline)
                                .textCase(nil)
                                .onChange(of: characterStandard) { newStandard in
                                        AudioFeedback.modified()
                                        context.triggerSelectionHapticFeedback()
                                        Options.updateCharacterStandard(to: newStandard)
                                }

                                Section {
                                        Toggle("SettingsView.KeyboardFeedback.Sound.ToggleTitle", isOn: $isAudioFeedbackOn)
                                                .onChange(of: isAudioFeedbackOn) { newState in
                                                        Options.updateAudioFeedbackStatus(isOn: newState)
                                                }
                                        if context.isRunningOnPhone {
                                                HStack(spacing: 0) {
                                                        Text("SettingsView.KeyboardFeedback.Haptic.PickerTitle").minimumScaleFactor(0.5).lineLimit(1)
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
                                                        .onChange(of: hapticFeedback) { newMode in
                                                                AudioFeedback.modified()
                                                                context.triggerSelectionHapticFeedback()
                                                                context.updateHapticFeedbackMode(to: newMode)
                                                        }
                                                }
                                                .disabled(context.hasFullAccess.negative)
                                        }
                                } header: {
                                        Text("SettingsView.KeyboardFeedback.SectionHeader").textCase(nil)
                                } footer: {
                                        if context.isRunningOnPhone && context.hasFullAccess.negative {
                                                Text("SettingsView.KeyboardFeedback.SectionFooter").textCase(nil)
                                        }
                                }

                                Picker("SettingsView.KeyboardLayout.PickerTitle", selection: $keyboardLayout) {
                                        Text("SettingsView.KeyboardLayout.Option.QWERTY").tag(KeyboardLayout.qwerty)
                                        Text("SettingsView.KeyboardLayout.Option.TripleStroke").tag(KeyboardLayout.tripleStroke)
                                        Text("SettingsView.KeyboardLayout.Option.10Key").tag(KeyboardLayout.tenKey)
                                }
                                .pickerStyle(.inline)
                                .textCase(nil)
                                .onChange(of: keyboardLayout) { newLayout in
                                        AudioFeedback.modified()
                                        context.triggerSelectionHapticFeedback()
                                        context.updateKeyboardLayout(to: newLayout)
                                }

                                Section {
                                        if context.isRunningOnPhone {
                                                Toggle("SettingsView.NumericLayout.ToggleTitle", isOn: $isKeyPadNumericLayout)
                                                        .onChange(of: isKeyPadNumericLayout) { isOn in
                                                                AudioFeedback.modified()
                                                                let newLayout: NumericLayout = isOn ? .numberKeyPad : .default
                                                                context.updateNumericLayout(to: newLayout)
                                                        }
                                                Toggle("SettingsView.StrokeLayout.ToggleTitle", isOn: $isTenKeyStrokeLayout)
                                                        .onChange(of: isTenKeyStrokeLayout) { isOn in
                                                                AudioFeedback.modified()
                                                                let newLayout: StrokeLayout = isOn ? .tenKey : .default
                                                                context.updateStrokeLayout(to: newLayout)
                                                        }
                                                Toggle("SettingsView.NumberRow.ToggleTitle", isOn: $needsNumberRow)
                                                        .onChange(of: needsNumberRow) { isOn in
                                                                AudioFeedback.modified()
                                                                context.updateNumberRowState(to: isOn)
                                                        }
                                        }
                                        Toggle("SettingsView.ShowLowercaseKeys.ToggleTitle", isOn: $showLowercaseKeys)
                                                .onChange(of: showLowercaseKeys) { newState in
                                                        AudioFeedback.modified()
                                                        Options.updateShowLowercaseKeys(to: newState)
                                                }
                                        Toggle("SettingsView.KeyTextPreview.ToggleTitle", isOn: $keyTextPreview)
                                                .onChange(of: keyTextPreview) { newState in
                                                        AudioFeedback.modified()
                                                        Options.updateKeyTextPreview(to: newState)
                                                }
                                }

                                if context.isRunningOnPhone {
                                        Picker("SettingsView.InputKeyStyle.PickerTitle", selection: $inputKeyStyle) {
                                                Text("SettingsView.InputKeyStyle.Option.None").tag(InputKeyStyle.clear)
                                                Text("SettingsView.InputKeyStyle.Option.Numbers").tag(InputKeyStyle.numbers)
                                                Text("SettingsView.InputKeyStyle.Option.NumbersAndSymbols").tag(InputKeyStyle.numbersAndSymbols)
                                        }
                                        .pickerStyle(.inline)
                                        .textCase(nil)
                                        .onChange(of: inputKeyStyle) { newStyle in
                                                AudioFeedback.modified()
                                                context.triggerSelectionHapticFeedback()
                                                Options.updateInputKeyStyle(to: newStyle)
                                        }
                                }

                                Picker("SettingsView.CommentStyle.PickerTitle", selection: $commentStyle) {
                                        Text("SettingsView.CommentStyle.Option.Above").tag(CommentStyle.aboveCandidates)
                                        Text("SettingsView.CommentStyle.Option.Below").tag(CommentStyle.belowCandidates)
                                        Text("SettingsView.CommentStyle.Option.None").tag(CommentStyle.noComments)
                                }
                                .pickerStyle(.inline)
                                .textCase(nil)
                                .onChange(of: commentStyle) { newStyle in
                                        AudioFeedback.modified()
                                        context.triggerSelectionHapticFeedback()
                                        Options.updateCommentStyle(to: newStyle)
                                }

                                Picker("SettingsView.CommentToneStyle.PickerTitle", selection: $commentToneStyle) {
                                        Text("SettingsView.CommentToneStyle.PickerOption1").tag(CommentToneStyle.normal)
                                        Text("SettingsView.CommentToneStyle.PickerOption2").tag(CommentToneStyle.noTones)
                                        Text("SettingsView.CommentToneStyle.PickerOption3").tag(CommentToneStyle.superscript)
                                        Text("SettingsView.CommentToneStyle.PickerOption4").tag(CommentToneStyle.subscript)
                                }
                                .pickerStyle(.inline)
                                .textCase(nil)
                                .onChange(of: commentToneStyle) { newStyle in
                                        AudioFeedback.modified()
                                        context.triggerSelectionHapticFeedback()
                                        Options.updateCommentToneStyle(to: newStyle)
                                }

                                Picker("SettingsView.CangjieVariant.PickerTitle", selection: $cangjieVariant) {
                                        Text("SettingsView.CangjieVariant.PickerOption1").tag(CangjieVariant.cangjie5)
                                        Text("SettingsView.CangjieVariant.PickerOption2").tag(CangjieVariant.cangjie3)
                                        Text("SettingsView.CangjieVariant.PickerOption3").tag(CangjieVariant.quick5)
                                        Text("SettingsView.CangjieVariant.PickerOption4").tag(CangjieVariant.quick3)

                                }
                                .pickerStyle(.inline)
                                .textCase(nil)
                                .onChange(of: cangjieVariant) { newVariant in
                                        AudioFeedback.modified()
                                        context.triggerSelectionHapticFeedback()
                                        Options.updateCangjieVariant(to: newVariant)
                                }

                                Section {
                                        Toggle("SettingsView.EmojiSuggestions.ToggleTitle", isOn: $isEmojiSuggestionsOn)
                                                .onChange(of: isEmojiSuggestionsOn) { newState in
                                                        AudioFeedback.modified()
                                                        Options.updateEmojiSuggestions(to: newState)
                                                }
                                        Toggle("SettingsView.SystemLexicon.ToggleTitle", isOn: $isTextReplacementsOn)
                                                .onChange(of: isTextReplacementsOn) { newState in
                                                        AudioFeedback.modified()
                                                        Options.updateTextReplacementsMode(to: newState)
                                                }
                                        Toggle("SettingsView.SchemeRules.CompatibleMode.ToggleTitle", isOn: $isCompatibleModeOn)
                                                .onChange(of: isCompatibleModeOn) { newState in
                                                        AudioFeedback.modified()
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
                                        .onChange(of: preferredLanguage) { newOption in
                                                AudioFeedback.modified()
                                                context.triggerSelectionHapticFeedback()
                                                Options.updatePreferredLanguage(to: newOption)
                                        }
                                } footer: {
                                        Text("SettingsView.KeyboardDisplayLanguage.SectionFooter").textCase(nil)
                                }

                                Section {
                                        Toggle("SettingsView.InputMemory.ToggleTitle", isOn: $isInputMemoryOn)
                                                .onChange(of: isInputMemoryOn) { newState in
                                                        Options.updateInputMemory(to: newState)
                                                }
                                        ZStack {
                                                if #available(iOSApplicationExtension 17.0, *) {
                                                        Color.clear
                                                                .sensoryFeedback(.warning, trigger: isTryingToClearInputMemory, condition: { $0.negative && $1 })
                                                                .sensoryFeedback(.success, trigger: isPerformingClearInputMemory, condition: { $0 && $1.negative })
                                                }
                                                Menu {
                                                        Button(role: .destructive) {
                                                                AudioFeedback.modified()
                                                                context.triggerHapticFeedback()
                                                                clearInputMemoryProgress = 0
                                                                isPerformingClearInputMemory = true
                                                                InputMemory.deleteAll()
                                                                EmojiMaster.clearFrequent()
                                                        } label: {
                                                                Label("SettingsView.InputMemory.ClearInputMemory.ButtonTitle", systemImage: "trash")
                                                        }
                                                        .onAppear {
                                                                AudioFeedback.modified()
                                                                isTryingToClearInputMemory = true
                                                        }
                                                } label: {
                                                        HStack {
                                                                Text("SettingsView.InputMemory.ClearInputMemory.ButtonTitle")
                                                                Spacer()
                                                        }
                                                        .foregroundStyle(Color.red)
                                                }
                                                .opacity(isPerformingClearInputMemory ? 0.5 : 1)
                                                ProgressView(value: clearInputMemoryProgress).opacity(isPerformingClearInputMemory ? 1 : 0)
                                        }
                                        .onReceive(timer) { _ in
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
                        .scrollContentBackground(.hidden)
                        .background(Color.interactiveClear)
                }
        }
}
