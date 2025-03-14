import SwiftUI
import CoreIME
import CommonExtensions

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

        @State private var characterStandard: CharacterStandard = Options.characterStandard
        @State private var isAudioFeedbackOn: Bool = Options.isAudioFeedbackOn
        @State private var hapticFeedback: HapticFeedback = HapticFeedback.fetchSavedMode()
        @State private var keyboardLayout: KeyboardLayout = KeyboardLayout.fetchSavedLayout()
        @State private var isKeyPadNumericLayout: Bool = NumericLayout.fetchSavedLayout().isNumberKeyPad
        @State private var showLowercaseKeys: Bool = Options.showLowercaseKeys
        @State private var keyTextPreview: Bool = Options.keyTextPreview
        @State private var commentStyle: CommentStyle = Options.commentStyle
        @State private var commentToneStyle: CommentToneStyle = Options.commentToneStyle
        @State private var cangjieVariant: CangjieVariant = Options.cangjieVariant
        @State private var isEmojiSuggestionsOn: Bool = Options.isEmojiSuggestionsOn
        @State private var preferredLanguage: PreferredLanguage = Options.preferredLanguage
        @State private var isInputMemoryOn: Bool = Options.isInputMemoryOn

        @State private var isTryingToClearInputMemory: Bool = false
        @State private var isPerformingClearInputMemory: Bool = false
        @State private var clearInputMemoryProgress: Double = 0
        private let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

        var body: some View {
                VStack(spacing: 0) {
                        ZStack {
                                Text("SettingsView.NavigationBar.HintText").font(.footnote).opacity(0.66)
                                HStack {
                                        Button {
                                                AudioFeedback.modified()
                                                context.triggerHapticFeedback()
                                                context.updateKeyboardForm(to: context.previousKeyboardForm)
                                        } label: {
                                                ZStack {
                                                        Color.interactiveClear
                                                        Image.chevronUp
                                                                .resizable()
                                                                .scaledToFit()
                                                                .padding(14)
                                                }
                                        }
                                        .buttonStyle(.plain)
                                        .frame(width: 48)
                                        .frame(maxHeight: .infinity)
                                        Spacer()
                                        Button {
                                                AudioFeedback.modified()
                                                context.triggerHapticFeedback()
                                                context.toggleKeyboardHeight()
                                        } label: {
                                                ZStack {
                                                        Color.interactiveClear
                                                        Image(systemName: context.isKeyboardHeightExpanded ? collapseImageName : expandImageName)
                                                                .resizable()
                                                                .scaledToFit()
                                                                .padding(14)
                                                }
                                        }
                                        .buttonStyle(.plain)
                                        .frame(width: 48)
                                        .frame(maxHeight: .infinity)
                                }
                        }
                        .background(Material.ultraThin)
                        .frame(height: 44)
                        List {
                                Picker("SettingsView.CharacterStandard.PickerTitle", selection: $characterStandard) {
                                        Text("SettingsView.CharacterStandard.PickerOption.Traditional").tag(CharacterStandard.traditional)
                                        Text("SettingsView.CharacterStandard.PickerOption.TraditionalHongKong").tag(CharacterStandard.hongkong)
                                        Text("SettingsView.CharacterStandard.PickerOption.TraditionalTaiwan").tag(CharacterStandard.taiwan)
                                        Text("SettingsView.CharacterStandard.PickerOption.Simplified").tag(CharacterStandard.simplified)
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
                                        if context.isPhone {
                                                HStack(spacing: 0) {
                                                        Text("SettingsView.KeyboardFeedback.Haptic.PickerTitle").minimumScaleFactor(0.5).lineLimit(1)
                                                        Spacer()
                                                        Picker("SettingsView.KeyboardFeedback.Haptic.PickerTitle", selection: $hapticFeedback) {
                                                                Text("SettingsView.KeyboardFeedback.Haptic.PickerOption.None").tag(HapticFeedback.disabled)
                                                                Text("SettingsView.KeyboardFeedback.Haptic.PickerOption.Light").tag(HapticFeedback.light)
                                                                Text("SettingsView.KeyboardFeedback.Haptic.PickerOption.Medium").tag(HapticFeedback.medium)
                                                                Text("SettingsView.KeyboardFeedback.Haptic.PickerOption.Heavy").tag(HapticFeedback.heavy)
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
                                        if context.isPhone && context.hasFullAccess.negative {
                                                Text("SettingsView.KeyboardFeedback.SectionFooter").textCase(nil)
                                        }
                                }

                                Picker("SettingsView.KeyboardLayout.PickerTitle", selection: $keyboardLayout) {
                                        Text("SettingsView.KeyboardLayout.PickerOption.QWERTY").tag(KeyboardLayout.qwerty)
                                        Text("SettingsView.KeyboardLayout.PickerOption.TripleStroke").tag(KeyboardLayout.tripleStroke)
                                        #if DEBUG
                                        Text("SettingsView.KeyboardLayout.PickerOption.10Key").tag(KeyboardLayout.tenKey)
                                        #endif
                                }
                                .pickerStyle(.inline)
                                .textCase(nil)
                                .onChange(of: keyboardLayout) { newLayout in
                                        AudioFeedback.modified()
                                        context.triggerSelectionHapticFeedback()
                                        context.updateKeyboardLayout(to: newLayout)
                                }

                                if context.isPhone && keyboardLayout.isTenKey.negative {
                                        Section {
                                                Toggle("SettingsView.NumericLayout.ToggleTitle", isOn: $isKeyPadNumericLayout)
                                                        .onChange(of: isKeyPadNumericLayout) { isOn in
                                                                AudioFeedback.modified()
                                                                let newLayout: NumericLayout = isOn ? .numberKeyPad : .default
                                                                context.updateNumericLayout(to: newLayout)
                                                        }
                                        }
                                }

                                Section {
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

                                Picker("SettingsView.CommentStyle.PickerTitle", selection: $commentStyle) {
                                        Text("SettingsView.CommentStyle.PickerOption.Above").tag(CommentStyle.aboveCandidates)
                                        Text("SettingsView.CommentStyle.PickerOption.Below").tag(CommentStyle.belowCandidates)
                                        Text("SettingsView.CommentStyle.PickerOption.None").tag(CommentStyle.noComments)
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
                                }

                                Section {
                                        HStack(spacing: 0) {
                                                Text("SettingsView.KeyboardDisplayLanguage.PickerTitle").minimumScaleFactor(0.5).lineLimit(1)
                                                Spacer()
                                                Picker("SettingsView.KeyboardDisplayLanguage.PickerTitle", selection: $preferredLanguage) {
                                                        Text(verbatim: "粵語").tag(PreferredLanguage.cantonese)
                                                        Text(verbatim: "English").tag(PreferredLanguage.english)
                                                }
                                                .pickerStyle(.segmented)
                                                .labelsHidden()
                                                .fixedSize()
                                                .onChange(of: preferredLanguage) { newOption in
                                                        AudioFeedback.modified()
                                                        context.triggerSelectionHapticFeedback()
                                                        Options.updatePreferredLanguage(to: newOption)
                                                }
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
                                                                UserLexicon.deleteAll()
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
