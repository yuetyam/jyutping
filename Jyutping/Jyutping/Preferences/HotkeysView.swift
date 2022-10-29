import SwiftUI

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

struct HotkeysView: View {

        @AppStorage(SettingsKeys.PressShiftOnce) private var pressShiftOnce: Int = AppSettings.pressShiftOnce.rawValue
        @AppStorage(SettingsKeys.SpeakCandidate) private var speakCandidateSate: Int = AppSettings.isSpeakCandidateEnabled ? 101 : 102

        var body: some View {
                ScrollView {
                        LazyVStack(spacing: 16) {
                                HStack {
                                        Picker("Press Shift Once To", selection: $pressShiftOnce) {
                                                Text("Do Nothing").tag(1)
                                                Text("Switch between Cantonese and English").tag(2)
                                        }
                                        .scaledToFit()
                                        .pickerStyle(.radioGroup)
                                        .onChange(of: pressShiftOnce) { newValue in
                                                AppSettings.updatePressShiftOnce(to: newValue)
                                        }
                                        Spacer()
                                }
                                .block()
                                VStack(spacing: 8) {
                                        HStack(spacing: 4) {
                                                LabelText("Open Preferences Window (This Window)")
                                                Text.separator
                                                KeyBlockView.Control
                                                Text.plus
                                                KeyBlockView.Shift
                                                Text.plus
                                                KeyBlockView(",")
                                                Spacer()
                                        }
                                        HStack(spacing: 4) {
                                                LabelText("Open/Close InstantSettings Window")
                                                Text.separator
                                                KeyBlockView.Control
                                                Text.plus
                                                KeyBlockView.Shift
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
                                                KeyBlockView.Control
                                                Text.plus
                                                KeyBlockView.Shift
                                                Text.plus
                                                KeyBlockView.Number
                                                Spacer()
                                        }
                                        HStack {
                                                Text(verbatim: "number: 1, 2, 3, ... 8, 9, 0")
                                                Spacer()
                                        }
                                        .font(.subheadline)
                                }
                                .block()
                                VStack(spacing: 8) {
                                        HStack(spacing: 4) {
                                                LabelText("Switch to Cantonese Mode")
                                                Text.separator
                                                KeyBlockView.Control
                                                Text.plus
                                                KeyBlockView.Shift
                                                Text.plus
                                                KeyBlockView("-")
                                                Spacer()
                                        }
                                        HStack(spacing: 4) {
                                                LabelText("Switch to English Mode")
                                                Text.separator
                                                KeyBlockView.Control
                                                Text.plus
                                                KeyBlockView.Shift
                                                Text.plus
                                                KeyBlockView("=")
                                                Spacer()
                                        }
                                }
                                .block()
                                HStack(spacing: 4) {
                                        LabelText("Remove highlighted Candidate from User Lexicon")
                                        Text.separator
                                        KeyBlockView.Control
                                        Text.plus
                                        KeyBlockView.Shift
                                        Text.plus
                                        KeyBlockView.BackwardDelete
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
                                                KeyBlockView("tab ⇥")
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
                                                KeyBlockView("page up ↑")
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
                                                KeyBlockView("page down ↓")
                                                Spacer()
                                        }
                                        HStack(spacing: 4) {
                                                LabelText("Jump to the first Candidate page")
                                                Text.separator
                                                KeyBlockView("home ⤒")
                                                Spacer()
                                        }
                                }
                                .block()
                                VStack {
                                        HStack(spacing: 4) {
                                                LabelText("Speak Candidate (Using system's built-in TTS)")
                                                Text.separator
                                                KeyBlockView.Control
                                                Text.plus
                                                KeyBlockView.Shift
                                                Text.plus
                                                KeyBlockView.Number
                                                Spacer()
                                                Toggle("isSpeakCandidateEnabled", isOn: $speakCandidateSate.isSpeakCandidateOn)
                                                        .toggleStyle(.switch)
                                                        .labelsHidden()
                                                        .onChange(of: speakCandidateSate) { newValue in
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
        private let backColor: Color = Color(nsColor: NSColor.textBackgroundColor)

        var body: some View {
                Text(verbatim: keyText)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .frame(width: 72, height: 24)
                        .background(backColor, in: RoundedRectangle(cornerRadius: 4, style: .continuous))
        }

        static let Control: KeyBlockView = KeyBlockView("control ⌃")
        static let Shift: KeyBlockView = KeyBlockView("shift ⇧")
        static let Number: KeyBlockView = KeyBlockView("number")
        // static let Space: KeyBlockView = KeyBlockView("Space ␣")
        static let escape: KeyBlockView = KeyBlockView("esc ⎋")

        /// Backspace. NOT Forward Delete.
        static let BackwardDelete: KeyBlockView = KeyBlockView("delete ⌫")
}


private extension Text {
        static let separator: Text = Text(verbatim: ": ").foregroundColor(.secondary)
        static let plus: Text = Text(verbatim: "+")
        static let or: Text = Text("or")
}

