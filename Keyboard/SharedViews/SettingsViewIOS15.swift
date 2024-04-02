import SwiftUI
import CoreIME

struct SettingsViewIOS15: View {

        @EnvironmentObject private var context: KeyboardViewController

        /// Example: 1.0.1 (23)
        private let version: String = {
                let marketingVersion: String = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? "error"
                let currentProjectVersion: String = (Bundle.main.infoDictionary?["CFBundleVersion"] as? String) ?? "null"
                return marketingVersion + " (" + currentProjectVersion + ")"
        }()

        private let expandImageName: String = "chevron.up.chevron.down"
        private let collapseImageName: String = "arrow.down"

        @State private var selectedCharacterStandard: CharacterStandard = Options.characterStandard
        @State private var isAudioFeedbackOn: Bool = Options.isAudioFeedbackOn
        @State private var hapticFeedback: HapticFeedback = HapticFeedback.fetchSavedMode()
        @State private var isEmojiSuggestionsOn: Bool = Options.isEmojiSuggestionsOn
        @State private var selectedKeyboardLayout: KeyboardLayout = Options.keyboardLayout
        @State private var showLowercaseKeys: Bool = Options.showLowercaseKeys
        @State private var keyTextPreview: Bool = Options.keyTextPreview
        @State private var selectedCommentStyle: CommentStyle = Options.commentStyle
        @State private var selectedCommentToneStyle: CommentToneStyle = Options.commentToneStyle
        @State private var selectedDoubleSpaceShortcut: DoubleSpaceShortcut = Options.doubleSpaceShortcut

        @State private var isPerformingClearUserLexicon: Bool = false
        @State private var clearUserLexiconProgress: Double = 0
        private let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

        var body: some View {
                VStack(spacing: 0) {
                        HStack {
                                Image.upChevron
                                        .resizable()
                                        .scaledToFit()
                                        .padding(12)
                                        .frame(width: 48)
                                        .frame(maxHeight: .infinity)
                                        .contentShape(Rectangle())
                                        .onTapGesture {
                                                AudioFeedback.modified()
                                                context.triggerHapticFeedback()
                                                context.updateKeyboardForm(to: context.previousKeyboardForm)
                                        }
                                Spacer()
                                Image(systemName: context.isKeyboardHeightExpanded ? collapseImageName : expandImageName)
                                        .resizable()
                                        .scaledToFit()
                                        .padding(10)
                                        .frame(width: 48)
                                        .frame(maxHeight: .infinity)
                                        .contentShape(Rectangle())
                                        .onTapGesture {
                                                AudioFeedback.modified()
                                                context.triggerHapticFeedback()
                                                context.toggleKeyboardHeight()
                                        }
                        }
                        .background(Material.ultraThin)
                        .frame(height: context.keyboardInterface.isCompact ? 36 : 44)
                        List {
                                Section {
                                        Button {
                                                AudioFeedback.modified()
                                                context.triggerSelectionHapticFeedback()
                                                selectedCharacterStandard = .traditional
                                                Options.updateCharacterStandard(to: .traditional)
                                        } label: {
                                                HStack {
                                                        Text("CharacterStandard.Traditional").foregroundStyle(Color.primary)
                                                        Spacer()
                                                        Image.checkmark.opacity(selectedCharacterStandard == .traditional ? 1: 0)
                                                }
                                        }
                                        Button {
                                                AudioFeedback.modified()
                                                context.triggerSelectionHapticFeedback()
                                                selectedCharacterStandard = .hongkong
                                                Options.updateCharacterStandard(to: .hongkong)
                                        } label: {
                                                HStack {
                                                        Text("CharacterStandard.TraditionalHongKong").foregroundStyle(Color.primary)
                                                        Spacer()
                                                        Image.checkmark.opacity(selectedCharacterStandard == .hongkong ? 1: 0)
                                                }
                                        }
                                        Button {
                                                AudioFeedback.modified()
                                                context.triggerSelectionHapticFeedback()
                                                selectedCharacterStandard = .taiwan
                                                Options.updateCharacterStandard(to: .taiwan)
                                        } label: {
                                                HStack {
                                                        Text("CharacterStandard.TraditionalTaiwan").foregroundStyle(Color.primary)
                                                        Spacer()
                                                        Image.checkmark.opacity(selectedCharacterStandard == .taiwan ? 1: 0)
                                                }
                                        }
                                        Button {
                                                AudioFeedback.modified()
                                                context.triggerSelectionHapticFeedback()
                                                selectedCharacterStandard = .simplified
                                                Options.updateCharacterStandard(to: .simplified)
                                        } label: {
                                                HStack {
                                                        Text("CharacterStandard.Simplified").foregroundStyle(Color.primary)
                                                        Spacer()
                                                        Image.checkmark.opacity(selectedCharacterStandard == .simplified ? 1: 0)
                                                }
                                        }
                                }
                                Section {
                                        Toggle("KeyboardFeedback.Sound", isOn: $isAudioFeedbackOn)
                                                .onChange(of: isAudioFeedbackOn) { newValue in
                                                        Options.updateAudioFeedbackStatus(isOn: newValue)
                                                }
                                        if context.isPhone {
                                                HStack {
                                                        Text("KeyboardFeedback.Haptic").minimumScaleFactor(0.5).lineLimit(1)
                                                        Spacer()
                                                        Picker("Haptic Feedback", selection: $hapticFeedback) {
                                                                Text("KeyboardFeedback.Haptic.None").tag(HapticFeedback.disabled)
                                                                Text("KeyboardFeedback.Haptic.Light").tag(HapticFeedback.light)
                                                                Text("KeyboardFeedback.Haptic.Medium").tag(HapticFeedback.medium)
                                                                Text("KeyboardFeedback.Haptic.Heavy").tag(HapticFeedback.heavy)
                                                        }
                                                        .labelsHidden()
                                                        .pickerStyle(.segmented)
                                                        .fixedSize()
                                                        .onChange(of: hapticFeedback) { newValue in
                                                                context.updateHapticFeedbackMode(to: newValue)
                                                        }
                                                        /*
                                                        .scaledToFit()
                                                        .scaleEffect(x: 0.9, y: 0.9, anchor: .trailing)
                                                        */
                                                }
                                                .disabled(!(context.hasFullAccess))
                                        }
                                } header: {
                                        Text("KeyboardFeedback.Header").textCase(nil)
                                } footer: {
                                        if context.isPhone && !(context.hasFullAccess) {
                                                Text("KeyboardFeedback.Footer").textCase(nil)
                                        }
                                }

                                Section {
                                        Toggle("SettingsView.EmojiSuggestions", isOn: $isEmojiSuggestionsOn)
                                                .onChange(of: isEmojiSuggestionsOn) { newValue in
                                                        Options.updateEmojiSuggestions(to: newValue)
                                                }
                                }

                                Section {
                                        Button {
                                                AudioFeedback.modified()
                                                context.triggerSelectionHapticFeedback()
                                                selectedKeyboardLayout = .qwerty
                                                Options.updateKeyboardLayout(to: .qwerty)
                                        } label: {
                                                HStack {
                                                        Text("KeyboardLayout.QWERTY").foregroundStyle(Color.primary)
                                                        Spacer()
                                                        Image.checkmark.opacity(selectedKeyboardLayout == .qwerty ? 1: 0)
                                                }
                                        }
                                        Button {
                                                AudioFeedback.modified()
                                                context.triggerSelectionHapticFeedback()
                                                selectedKeyboardLayout = .saamPing
                                                Options.updateKeyboardLayout(to: .saamPing)
                                        } label: {
                                                HStack {
                                                        Text("KeyboardLayout.SaamPing").foregroundStyle(Color.primary)
                                                        Spacer()
                                                        Image.checkmark.opacity(selectedKeyboardLayout == .saamPing ? 1: 0)
                                                }
                                        }
                                        if context.isPhone {
                                                Button {
                                                        AudioFeedback.modified()
                                                        context.triggerSelectionHapticFeedback()
                                                        selectedKeyboardLayout = .tenKey
                                                        Options.updateKeyboardLayout(to: .tenKey)
                                                } label: {
                                                        HStack {
                                                                Text("KeyboardLayout.10Key").foregroundStyle(Color.primary)
                                                                Spacer()
                                                                Image.checkmark.opacity(selectedKeyboardLayout == .tenKey ? 1: 0)
                                                        }
                                                }
                                        }
                                } header: {
                                        Text("KeyboardLayout.Header").textCase(nil)
                                }

                                Section {
                                        Toggle("SettingsView.ShowLowercaseKeys", isOn: $showLowercaseKeys)
                                                .onChange(of: showLowercaseKeys) { newValue in
                                                        AudioFeedback.modified()
                                                        Options.updateShowLowercaseKeys(to: newValue)
                                                }
                                        Toggle("SettingsView.KeyTextPreview", isOn: $keyTextPreview)
                                                .onChange(of: keyTextPreview) { newValue in
                                                        AudioFeedback.modified()
                                                        Options.updateKeyTextPreview(to: newValue)
                                                }
                                }

                                Section {
                                        Button {
                                                AudioFeedback.modified()
                                                context.triggerSelectionHapticFeedback()
                                                selectedCommentStyle = .aboveCandidates
                                                Options.updateCommentStyle(to: .aboveCandidates)
                                        } label: {
                                                HStack {
                                                        Text("JyutpingDisplay.AboveCandidates").foregroundStyle(Color.primary)
                                                        Spacer()
                                                        Image.checkmark.opacity(selectedCommentStyle == .aboveCandidates ? 1: 0)
                                                }
                                        }
                                        Button {
                                                AudioFeedback.modified()
                                                context.triggerSelectionHapticFeedback()
                                                selectedCommentStyle = .belowCandidates
                                                Options.updateCommentStyle(to: .belowCandidates)
                                        } label: {
                                                HStack {
                                                        Text("JyutpingDisplay.BelowCandidates").foregroundStyle(Color.primary)
                                                        Spacer()
                                                        Image.checkmark.opacity(selectedCommentStyle == .belowCandidates ? 1: 0)
                                                }
                                        }
                                        Button {
                                                AudioFeedback.modified()
                                                context.triggerSelectionHapticFeedback()
                                                selectedCommentStyle = .noComments
                                                Options.updateCommentStyle(to: .noComments)
                                        } label: {
                                                HStack {
                                                        Text("JyutpingDisplay.NoJyutping").foregroundStyle(Color.primary)
                                                        Spacer()
                                                        Image.checkmark.opacity(selectedCommentStyle == .noComments ? 1: 0)
                                                }
                                        }
                                } header: {
                                        Text("JyutpingDisplay.Header").textCase(nil)
                                }

                                Section {
                                        Button {
                                                AudioFeedback.modified()
                                                context.triggerSelectionHapticFeedback()
                                                selectedCommentToneStyle = .normal
                                                Options.updateCommentToneStyle(to: .normal)
                                        } label: {
                                                HStack {
                                                        Text("ToneDisplay.Option1").foregroundStyle(Color.primary)
                                                        Spacer()
                                                        Image.checkmark.opacity(selectedCommentToneStyle == .normal ? 1: 0)
                                                }
                                        }
                                        Button {
                                                AudioFeedback.modified()
                                                context.triggerSelectionHapticFeedback()
                                                selectedCommentToneStyle = .noTones
                                                Options.updateCommentToneStyle(to: .noTones)
                                        } label: {
                                                HStack {
                                                        Text("ToneDisplay.Option2").foregroundStyle(Color.primary)
                                                        Spacer()
                                                        Image.checkmark.opacity(selectedCommentToneStyle == .noTones ? 1: 0)
                                                }
                                        }
                                        Button {
                                                AudioFeedback.modified()
                                                context.triggerSelectionHapticFeedback()
                                                selectedCommentToneStyle = .superscript
                                                Options.updateCommentToneStyle(to: .superscript)
                                        } label: {
                                                HStack {
                                                        Text("ToneDisplay.Option3").foregroundStyle(Color.primary)
                                                        Spacer()
                                                        Image.checkmark.opacity(selectedCommentToneStyle == .superscript ? 1: 0)
                                                }
                                        }
                                        Button {
                                                AudioFeedback.modified()
                                                context.triggerSelectionHapticFeedback()
                                                selectedCommentToneStyle = .subscript
                                                Options.updateCommentToneStyle(to: .subscript)
                                        } label: {
                                                HStack {
                                                        Text("ToneDisplay.Option4").foregroundStyle(Color.primary)
                                                        Spacer()
                                                        Image.checkmark.opacity(selectedCommentToneStyle == .subscript ? 1: 0)
                                                }
                                        }
                                } header: {
                                        Text("ToneDisplay.Header").textCase(nil)
                                }

                                Section {
                                        Button {
                                                AudioFeedback.modified()
                                                context.triggerSelectionHapticFeedback()
                                                selectedDoubleSpaceShortcut = .insertPeriod
                                                Options.updateDoubleSpaceShortcut(to: .insertPeriod)
                                        } label: {
                                                HStack {
                                                        Text("SpaceDoubleTapping.Option1").foregroundStyle(Color.primary)
                                                        Spacer()
                                                        Image.checkmark.opacity(selectedDoubleSpaceShortcut == .insertPeriod ? 1: 0)
                                                }
                                        }
                                        Button {
                                                AudioFeedback.modified()
                                                context.triggerSelectionHapticFeedback()
                                                selectedDoubleSpaceShortcut = .insertIdeographicComma
                                                Options.updateDoubleSpaceShortcut(to: .insertIdeographicComma)
                                        } label: {
                                                HStack {
                                                        Text("SpaceDoubleTapping.Option3").foregroundStyle(Color.primary)
                                                        Spacer()
                                                        Image.checkmark.opacity(selectedDoubleSpaceShortcut == .insertIdeographicComma ? 1: 0)
                                                }
                                        }
                                        Button {
                                                AudioFeedback.modified()
                                                context.triggerSelectionHapticFeedback()
                                                selectedDoubleSpaceShortcut = .insertFullWidthSpace
                                                Options.updateDoubleSpaceShortcut(to: .insertFullWidthSpace)
                                        } label: {
                                                HStack {
                                                        Text("SpaceDoubleTapping.Option4").foregroundStyle(Color.primary)
                                                        Spacer()
                                                        Image.checkmark.opacity(selectedDoubleSpaceShortcut == .insertFullWidthSpace ? 1: 0)
                                                }
                                        }
                                        Button {
                                                AudioFeedback.modified()
                                                context.triggerSelectionHapticFeedback()
                                                selectedDoubleSpaceShortcut = .doNothing
                                                Options.updateDoubleSpaceShortcut(to: .doNothing)
                                        } label: {
                                                HStack {
                                                        Text("SpaceDoubleTapping.Option2").foregroundStyle(Color.primary)
                                                        Spacer()
                                                        Image.checkmark.opacity(selectedDoubleSpaceShortcut == .doNothing ? 1: 0)
                                                }
                                        }
                                } header: {
                                        Text("SpaceDoubleTapping.Header").textCase(nil)
                                }

                                Section {
                                        Menu {
                                                Button {
                                                        UIPasteboard.general.string = version
                                                } label: {
                                                        Label("SettingsView.Copy", systemImage: "doc.on.doc")
                                                }
                                        } label: {
                                                HStack {
                                                        Text("SettingsView.Version")
                                                        Spacer()
                                                        Text(verbatim: version)
                                                }
                                                .foregroundStyle(Color.primary)
                                        }
                                }

                                Section {
                                        ZStack {
                                                Menu {
                                                        Button(role: .destructive) {
                                                                AudioFeedback.modified()
                                                                context.triggerHapticFeedback()
                                                                clearUserLexiconProgress = 0
                                                                isPerformingClearUserLexicon = true
                                                                UserLexicon.deleteAll()
                                                                EmojiMaster.clearFrequent()
                                                        } label: {
                                                                Label("SettingsView.ClearUserLexicon", systemImage: "trash")
                                                        }
                                                } label: {
                                                        HStack {
                                                                Spacer()
                                                                Text("SettingsView.ClearUserLexicon")
                                                                Spacer()
                                                        }
                                                        .foregroundStyle(Color.red)
                                                }
                                                ProgressView(value: clearUserLexiconProgress).opacity(isPerformingClearUserLexicon ? 1 : 0)
                                        }
                                        .onReceive(timer) { _ in
                                                guard isPerformingClearUserLexicon else { return }
                                                if clearUserLexiconProgress > 1 {
                                                        isPerformingClearUserLexicon = false
                                                } else {
                                                        clearUserLexiconProgress += 0.1
                                                }
                                        }
                                }
                        }
                }
        }
}
