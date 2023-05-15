import SwiftUI
import CoreIME

@available(iOSApplicationExtension 16.0, *)
struct SettingsView: View {

        @EnvironmentObject private var context: KeyboardViewController

        @State private var selectedCharacterStandard: CharacterStandard = Options.characterStandard
        @State private var isAudioFeedbackOn: Bool = Options.isAudioFeedbackOn
        @State private var hapticFeedback: HapticFeedback = .disabled
        @State private var isEmojiSuggestionsOn: Bool = Options.isEmojiSuggestionsOn

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
                                                        Text("Traditional").foregroundColor(.primary)
                                                        Spacer()
                                                        Image.checkmark.opacity(selectedCharacterStandard == .traditional ? 1: 0)
                                                }
                                        }
                                        Button {
                                                selectedCharacterStandard = .hongkong
                                                Options.updateCharacterStandard(to: .hongkong)
                                        } label: {
                                                HStack {
                                                        Text("Traditional, Hong Kong").foregroundColor(.primary)
                                                        Spacer()
                                                        Image.checkmark.opacity(selectedCharacterStandard == .hongkong ? 1: 0)
                                                }
                                        }
                                        Button {
                                                selectedCharacterStandard = .taiwan
                                                Options.updateCharacterStandard(to: .taiwan)
                                        } label: {
                                                HStack {
                                                        Text("Traditional, Taiwan").foregroundColor(.primary)
                                                        Spacer()
                                                        Image.checkmark.opacity(selectedCharacterStandard == .taiwan ? 1: 0)
                                                }
                                        }
                                        Button {
                                                selectedCharacterStandard = .simplified
                                                Options.updateCharacterStandard(to: .simplified)
                                        } label: {
                                                HStack {
                                                        Text("Simplified").foregroundColor(.primary)
                                                        Spacer()
                                                        Image.checkmark.opacity(selectedCharacterStandard == .simplified ? 1: 0)
                                                }
                                        }
                                } header: {
                                        Text("Characters").textCase(nil)
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
                                        HStack {
                                                Text("KeyboardLayout.QWERTY")
                                                Spacer()
                                                Image.checkmark
                                        }
                                        HStack {
                                                Text("KeyboardLayout.SaamPing")
                                        }
                                        HStack {
                                                Text("KeyboardLayout.10Key")
                                        }
                                } header: {
                                        Text("Keyboard Layout").textCase(nil)
                                }

                                Section {
                                        HStack {
                                                Text("Above Candidates")
                                                Spacer()
                                                Image.checkmark
                                        }
                                        HStack {
                                                Text("Above Candidates")
                                        }
                                        HStack {
                                                Text("No Jyutping")
                                        }
                                } header: {
                                        Text("Jyutping Display").textCase(nil)
                                }

                                Section {
                                        HStack {
                                                Text("ToneDisplayStyle.Option1")
                                                Spacer()
                                                Image.checkmark
                                        }
                                        HStack {
                                                Text("ToneDisplayStyle.Option2")
                                        }
                                        HStack {
                                                Text("ToneDisplayStyle.Option3")
                                        }
                                        HStack {
                                                Text("ToneDisplayStyle.Option4")
                                        }
                                } header: {
                                        Text("Jyutping Tones Display").textCase(nil)
                                }

                                Section {
                                        HStack {
                                                Text("DoubleSpaceShortcut.Option1")
                                                Spacer()
                                                Image.checkmark
                                        }
                                        HStack {
                                                Text("DoubleSpaceShortcut.Option3")
                                        }
                                        HStack {
                                                Text("DoubleSpaceShortcut.Option4")
                                        }
                                        HStack {
                                                Text("DoubleSpaceShortcut.Option2")
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
                        .scrollContentBackground(.hidden)
                        .background(Color.interactiveClear)
                }
        }
}
