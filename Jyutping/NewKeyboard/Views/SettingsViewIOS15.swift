import SwiftUI
import CoreIME

struct SettingsViewIOS15: View {

        @EnvironmentObject private var context: KeyboardViewController

        @State private var selectedCharacterStandard: CharacterStandard = Options.characterStandard
        @State private var isAudioFeedbackOn: Bool = Options.isAudioFeedbackOn
        @State private var hapticFeedback: HapticFeedback = .disabled
        @State private var isEmojiSuggestionsOn: Bool = Options.isEmojiSuggestionsOn
        @State private var selectedKeyboardLayout: KeyboardLayout = Options.keyboardLayout
        @State private var selectedCommentStyle: CommentStyle = Options.commentStyle
        @State private var selectedCommentToneStyle: CommentToneStyle = Options.commentToneStyle
        @State private var selectedDoubleSpaceShortcut: DoubleSpaceShortcut = Options.doubleSpaceShortcut

        @State private var isPerformingClearUserLexicon: Bool = false
        @State private var clearUserLexiconProgress: Double = 0
        private let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

        var body: some View {
                VStack(spacing: 0) {
                        HStack {
                                Image(systemName: "chevron.up")
                                        .resizable()
                                        .scaledToFit()
                                        .padding(12)
                                        .frame(width: 48)
                                Spacer()
                        }
                        .frame(height: context.keyboardInterface.isCompact ? 36 : 44)
                        .background(Material.ultraThin)
                        .contentShape(Rectangle())
                        .onTapGesture {
                                context.updateKeyboardType(to: context.previousKeyboardType)
                        }
                        List {
                                Section {
                                        Button {
                                                selectedCharacterStandard = .traditional
                                                Options.updateCharacterStandard(to: .traditional)
                                        } label: {
                                                HStack {
                                                        Text("Traditional Characters").foregroundColor(.primary)
                                                        Spacer()
                                                        Image.checkmark.opacity(selectedCharacterStandard == .traditional ? 1: 0)
                                                }
                                        }
                                        Button {
                                                selectedCharacterStandard = .hongkong
                                                Options.updateCharacterStandard(to: .hongkong)
                                        } label: {
                                                HStack {
                                                        Text("Traditional Characters, Hong Kong").foregroundColor(.primary)
                                                        Spacer()
                                                        Image.checkmark.opacity(selectedCharacterStandard == .hongkong ? 1: 0)
                                                }
                                        }
                                        Button {
                                                selectedCharacterStandard = .taiwan
                                                Options.updateCharacterStandard(to: .taiwan)
                                        } label: {
                                                HStack {
                                                        Text("Traditional Characters, Taiwan").foregroundColor(.primary)
                                                        Spacer()
                                                        Image.checkmark.opacity(selectedCharacterStandard == .taiwan ? 1: 0)
                                                }
                                        }
                                        Button {
                                                selectedCharacterStandard = .simplified
                                                Options.updateCharacterStandard(to: .simplified)
                                        } label: {
                                                HStack {
                                                        Text("Simplified Characters").foregroundColor(.primary)
                                                        Spacer()
                                                        Image.checkmark.opacity(selectedCharacterStandard == .simplified ? 1: 0)
                                                }
                                        }
                                }
                                Section {
                                        Toggle("Sound", isOn: $isAudioFeedbackOn)
                                                .onChange(of: isAudioFeedbackOn) { newValue in
                                                        DispatchQueue.preferences.async {
                                                                Options.updateAudioFeedbackStatus(isOn: newValue)
                                                        }
                                                }
                                        if context.isPhone {
                                                HStack {
                                                        Text("Haptic").minimumScaleFactor(0.5).lineLimit(1)
                                                        Spacer()
                                                        Picker("Haptic Feedback", selection: $hapticFeedback) {
                                                                Text("Haptic.None").tag(HapticFeedback.disabled)
                                                                Text("Haptic.Light").tag(HapticFeedback.light)
                                                                Text("Haptic.Medium").tag(HapticFeedback.medium)
                                                                Text("Haptic.Heavy").tag(HapticFeedback.heavy)
                                                        }
                                                        .labelsHidden()
                                                        .pickerStyle(.segmented)
                                                        .fixedSize()
                                                        /*
                                                        .scaledToFit()
                                                        .scaleEffect(x: 0.9, y: 0.9, anchor: .trailing)
                                                        */
                                                        .onChange(of: hapticFeedback) { newValue in
                                                                // TODO: perform change
                                                        }
                                                }
                                                .disabled(!(context.hasFullAccess))
                                        }
                                } header: {
                                        Text("Keyboard Feedback").textCase(nil)
                                } footer: {
                                        if context.isPhone && !(context.hasFullAccess) {
                                                Text("Haptic Feedback requires Full Access").textCase(nil)
                                        }
                                }

                                Section {
                                        Toggle("Emoji Suggestions", isOn: $isEmojiSuggestionsOn)
                                                .onChange(of: isEmojiSuggestionsOn) { newValue in
                                                        DispatchQueue.preferences.async {
                                                                Options.updateEmojiSuggestions(to: newValue)
                                                        }
                                                }
                                }

                                Section {
                                        Button {
                                                selectedKeyboardLayout = .qwerty
                                                Options.updateKeyboardLayout(to: .qwerty)
                                        } label: {
                                                HStack {
                                                        Text("KeyboardLayout.QWERTY").foregroundColor(.primary)
                                                        Spacer()
                                                        Image.checkmark.opacity(selectedKeyboardLayout == .qwerty ? 1: 0)
                                                }
                                        }
                                        Button {
                                                selectedKeyboardLayout = .saamPing
                                                Options.updateKeyboardLayout(to: .saamPing)
                                        } label: {
                                                HStack {
                                                        Text("KeyboardLayout.SaamPing").foregroundColor(.primary)
                                                        Spacer()
                                                        Image.checkmark.opacity(selectedKeyboardLayout == .saamPing ? 1: 0)
                                                }
                                        }
                                        Button {
                                                selectedKeyboardLayout = .tenKey
                                                Options.updateKeyboardLayout(to: .tenKey)
                                        } label: {
                                                HStack {
                                                        Text("KeyboardLayout.10Key").foregroundColor(.primary)
                                                        Spacer()
                                                        Image.checkmark.opacity(selectedKeyboardLayout == .tenKey ? 1: 0)
                                                }
                                        }
                                } header: {
                                        Text("Keyboard Layout").textCase(nil)
                                }

                                Section {
                                        Button {
                                                selectedCommentStyle = .aboveCandidates
                                                Options.updateCommentStyle(to: .aboveCandidates)
                                        } label: {
                                                HStack {
                                                        Text("Above Candidates").foregroundColor(.primary)
                                                        Spacer()
                                                        Image.checkmark.opacity(selectedCommentStyle == .aboveCandidates ? 1: 0)
                                                }
                                        }
                                        Button {
                                                selectedCommentStyle = .belowCandidates
                                                Options.updateCommentStyle(to: .belowCandidates)
                                        } label: {
                                                HStack {
                                                        Text("Below Candidates").foregroundColor(.primary)
                                                        Spacer()
                                                        Image.checkmark.opacity(selectedCommentStyle == .belowCandidates ? 1: 0)
                                                }
                                        }
                                        Button {
                                                selectedCommentStyle = .noComments
                                                Options.updateCommentStyle(to: .noComments)
                                        } label: {
                                                HStack {
                                                        Text("No Jyutping").foregroundColor(.primary)
                                                        Spacer()
                                                        Image.checkmark.opacity(selectedCommentStyle == .noComments ? 1: 0)
                                                }
                                        }
                                } header: {
                                        Text("Jyutping Display").textCase(nil)
                                }

                                Section {
                                        Button {
                                                selectedCommentToneStyle = .normal
                                                Options.updateCommentToneStyle(to: .normal)
                                        } label: {
                                                HStack {
                                                        Text("ToneDisplayStyle.Option1").foregroundColor(.primary)
                                                        Spacer()
                                                        Image.checkmark.opacity(selectedCommentToneStyle == .normal ? 1: 0)
                                                }
                                        }
                                        Button {
                                                selectedCommentToneStyle = .superscript
                                                Options.updateCommentToneStyle(to: .superscript)
                                        } label: {
                                                HStack {
                                                        Text("ToneDisplayStyle.Option2").foregroundColor(.primary)
                                                        Spacer()
                                                        Image.checkmark.opacity(selectedCommentToneStyle == .superscript ? 1: 0)
                                                }
                                        }
                                        Button {
                                                selectedCommentToneStyle = .subscript
                                                Options.updateCommentToneStyle(to: .subscript)
                                        } label: {
                                                HStack {
                                                        Text("ToneDisplayStyle.Option3").foregroundColor(.primary)
                                                        Spacer()
                                                        Image.checkmark.opacity(selectedCommentToneStyle == .subscript ? 1: 0)
                                                }
                                        }
                                        Button {
                                                selectedCommentToneStyle = .noTones
                                                Options.updateCommentToneStyle(to: .noTones)
                                        } label: {
                                                HStack {
                                                        Text("ToneDisplayStyle.Option4").foregroundColor(.primary)
                                                        Spacer()
                                                        Image.checkmark.opacity(selectedCommentToneStyle == .noTones ? 1: 0)
                                                }
                                        }
                                } header: {
                                        Text("Jyutping Tones Display").textCase(nil)
                                }

                                Section {
                                        Button {
                                                selectedDoubleSpaceShortcut = .insertPeriod
                                                Options.updateDoubleSpaceShortcut(to: .insertPeriod)
                                        } label: {
                                                HStack {
                                                        Text("DoubleSpaceShortcut.Option1").foregroundColor(.primary)
                                                        Spacer()
                                                        Image.checkmark.opacity(selectedDoubleSpaceShortcut == .insertPeriod ? 1: 0)
                                                }
                                        }
                                        Button {
                                                selectedDoubleSpaceShortcut = .insertIdeographicComma
                                                Options.updateDoubleSpaceShortcut(to: .insertIdeographicComma)
                                        } label: {
                                                HStack {
                                                        Text("DoubleSpaceShortcut.Option3").foregroundColor(.primary)
                                                        Spacer()
                                                        Image.checkmark.opacity(selectedDoubleSpaceShortcut == .insertIdeographicComma ? 1: 0)
                                                }
                                        }
                                        Button {
                                                selectedDoubleSpaceShortcut = .insertFullWidthSpace
                                                Options.updateDoubleSpaceShortcut(to: .insertFullWidthSpace)
                                        } label: {
                                                HStack {
                                                        Text("DoubleSpaceShortcut.Option4").foregroundColor(.primary)
                                                        Spacer()
                                                        Image.checkmark.opacity(selectedDoubleSpaceShortcut == .insertFullWidthSpace ? 1: 0)
                                                }
                                        }
                                        Button {
                                                selectedDoubleSpaceShortcut = .doNothing
                                                Options.updateDoubleSpaceShortcut(to: .doNothing)
                                        } label: {
                                                HStack {
                                                        Text("DoubleSpaceShortcut.Option2").foregroundColor(.primary)
                                                        Spacer()
                                                        Image.checkmark.opacity(selectedDoubleSpaceShortcut == .doNothing ? 1: 0)
                                                }
                                        }
                                } header: {
                                        Text("Space Double Tapping Shortcut").textCase(nil)
                                }

                                Section {
                                        ZStack {
                                                Menu {
                                                        Button(role: .destructive) {
                                                                // TODO: perform clearing
                                                                clearUserLexiconProgress = 0
                                                                isPerformingClearUserLexicon = true
                                                        } label: {
                                                                Label("Clear User Lexicon", systemImage: "trash")
                                                        }
                                                } label: {
                                                        HStack {
                                                                Spacer()
                                                                Text("Clear User Lexicon")
                                                                Spacer()
                                                        }
                                                        .foregroundColor(.red)
                                                }
                                                ProgressView(value: clearUserLexiconProgress).opacity(isPerformingClearUserLexicon ? 1 : 0)
                                        }
                                        .onReceive(timer) { _ in
                                                guard isPerformingClearUserLexicon else { return }
                                                if clearUserLexiconProgress > 1 {
                                                        isPerformingClearUserLexicon = false
                                                } else {
                                                        clearUserLexiconProgress += 0.05
                                                }
                                        }
                                }
                        }
                }
        }
}
