import SwiftUI

/*
private extension Int {
        var isSpeakCandidateOn: Bool {
                get {
                        switch self {
                        case 101:
                                return true
                        case 102:
                                return false
                        default:
                                return false
                        }
                }
                set {
                        self = newValue ? 101 : 102
                }
        }
}
*/

struct HotkeysView: View {

        @AppStorage(SettingsKey.PressShiftOnce) private var pressShiftOnce: Int = AppSettings.pressShiftOnce.rawValue
        @AppStorage(SettingsKey.ShiftSpaceCombination) private var shiftSpaceCombination: Int = AppSettings.shiftSpaceCombination.rawValue
        // @AppStorage(SettingsKey.SpeakCandidate) private var speakCandidateState: Int = AppSettings.isSpeakCandidateEnabled ? 101 : 102

        var body: some View {
                ScrollView {
                        LazyVStack(spacing: 16) {
                                HStack {
                                        Picker("Press **Shift** Once To", selection: $pressShiftOnce) {
                                                Text("Do Nothing").tag(1)
                                                Text("Switch between Cantonese and ABC (Not Implemented Yet)").tag(2)
                                        }
                                        .scaledToFit()
                                        .pickerStyle(.radioGroup)
                                        .onChange(of: pressShiftOnce) { newValue in
                                                AppSettings.updatePressShiftOnce(to: newValue)
                                        }
                                        Spacer()
                                }
                                .block()
                                HStack {
                                        Picker("Press **Shift** + **Space** To", selection: $shiftSpaceCombination) {
                                                Text("Input a Full-width Space (U+3000)").tag(1)
                                                Text("Switch between Cantonese and ABC").tag(2)
                                        }
                                        .scaledToFit()
                                        .pickerStyle(.radioGroup)
                                        .onChange(of: shiftSpaceCombination) { newValue in
                                                AppSettings.updateShiftSpaceCombination(to: newValue)
                                        }
                                        Spacer()
                                }
                                .block()
                                VStack(spacing: 8) {
                                        HStack(spacing: 4) {
                                                LabelText("Open Preferences Window (This Window)")
                                                Text.separator
                                                KeyBlockView.control
                                                Text.plus
                                                KeyBlockView.shift
                                                Text.plus
                                                KeyBlockView(",")
                                                Spacer()
                                        }
                                        HStack(spacing: 4) {
                                                LabelText("Open/Close InstantSettings Window")
                                                Text.separator
                                                KeyBlockView.control
                                                Text.plus
                                                KeyBlockView.shift
                                                Text.plus
                                                KeyBlockView("`")
                                                Spacer()
                                        }
                                }
                                .block()
                                VStack {
                                        HStack(spacing: 4) {
                                                LabelText("Directly toggle InstantSettings options")
                                                Text.separator
                                                KeyBlockView.control
                                                Text.plus
                                                KeyBlockView.shift
                                                Text.plus
                                                KeyBlockView.number
                                                Spacer()
                                        }
                                        HStack {
                                                Text(verbatim: "number: 1, 2, 3, ... 8, 9, 0")
                                                Spacer()
                                        }
                                        .font(.subheadline)
                                }
                                .block()
                                HStack(spacing: 4) {
                                        LabelText("Remove highlighted Candidate from User Lexicon")
                                        Text.separator
                                        KeyBlockView.control
                                        Text.plus
                                        KeyBlockView.shift
                                        Text.plus
                                        KeyBlockView.backwardDelete
                                        Spacer()
                                }
                                .block()
                                HStack(spacing: 4) {
                                        LabelText("Clear current Input Buffer")
                                        Text.separator
                                        KeyBlockView.escape
                                        Spacer()
                                }
                                .block()
                                VStack(spacing: 8) {
                                        HStack(spacing: 4) {
                                                LabelText("Highlight previous Candidate")
                                                Text.separator
                                                KeyBlockView("▲")
                                                Spacer()
                                        }
                                        HStack(spacing: 4) {
                                                LabelText("Highlight next Candidate")
                                                Text.separator
                                                KeyBlockView("▼")
                                                Text.or
                                                KeyBlockView("Tab ⇥")
                                                Spacer()
                                        }
                                        HStack(spacing: 4) {
                                                LabelText("Backward to previous Candidate page")
                                                Text.separator
                                                KeyBlockView("-")
                                                Text.or
                                                KeyBlockView("[")
                                                Text.or
                                                KeyBlockView(",")
                                                Text.or
                                                KeyBlockView("Page Up ↑")
                                                Spacer()
                                        }
                                        HStack(spacing: 4) {
                                                LabelText("Forward to next Candidate page")
                                                Text.separator
                                                KeyBlockView("=")
                                                Text.or
                                                KeyBlockView("]")
                                                Text.or
                                                KeyBlockView(".")
                                                Text.or
                                                KeyBlockView("Page Down ↓")
                                                Spacer()
                                        }
                                        HStack(spacing: 4) {
                                                LabelText("Jump to the first Candidate page")
                                                Text.separator
                                                KeyBlockView("Home ⤒")
                                                Spacer()
                                        }
                                }
                                .block()
                                /*
                                VStack {
                                        HStack(spacing: 4) {
                                                LabelText("Speak Candidate (Using system's built-in TTS)")
                                                Text.separator
                                                KeyBlockView.control
                                                Text.plus
                                                KeyBlockView.shift
                                                Text.plus
                                                KeyBlockView.number
                                                Spacer()
                                                Toggle("isSpeakCandidateEnabled", isOn: $speakCandidateState.isSpeakCandidateOn)
                                                        .toggleStyle(.switch)
                                                        .labelsHidden()
                                                        .onChange(of: speakCandidateState) { newValue in
                                                                AppSettings.updateSpeakCandidateState(to: newValue)
                                                        }
                                        }
                                        HStack {
                                                Text(verbatim: "number: 1, 2, 3, ... 8, 9, 0")
                                                Spacer()
                                        }
                                        .font(.subheadline)
                                }
                                .block()
                                */
                        }
                        .textSelection(.enabled)
                        .padding(.bottom)
                        .padding()
                }
                .navigationTitle("PreferencesView.NavigationTitle.Hotkeys")
        }
}


private struct LabelText: View {
        init(_ title: LocalizedStringKey) {
                self.title = title
        }
        private let title: LocalizedStringKey
        var body: some View {
                Text(title)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .frame(width: 270, alignment: .leading)
        }
}


private struct KeyBlockView: View {

        init(_ keyText: String) {
                self.keyText = keyText
        }

        private let keyText: String

        var body: some View {
                Text(verbatim: keyText)
                        .lineLimit(1)
                        .minimumScaleFactor(0.4)
                        .frame(width: 72, height: 24)
                        .background(Material.regular, in: RoundedRectangle(cornerRadius: 4, style: .continuous))
        }

        static let control: KeyBlockView = KeyBlockView("Control ⌃")
        static let shift: KeyBlockView = KeyBlockView("Shift ⇧")
        static let number: KeyBlockView = KeyBlockView("number")
        static let space: KeyBlockView = KeyBlockView("Space ␣")
        static let escape: KeyBlockView = KeyBlockView("Esc ⎋")

        /// Backspace. NOT Forward-Delete.
        static let backwardDelete: KeyBlockView = KeyBlockView("Delete ⌫")
}


private extension Text {
        static let separator: Text = Text(verbatim: ": ").foregroundColor(.secondary)
        static let plus: Text = Text(verbatim: "+")
        static let or: Text = Text("or")
}

