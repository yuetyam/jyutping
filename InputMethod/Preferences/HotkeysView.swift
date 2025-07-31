import SwiftUI

struct HotkeysView: View {

        @State private var pressShiftOnce: PressShiftOnce = AppSettings.pressShiftOnce
        @State private var shiftSpaceCombination: ShiftSpaceCombination = AppSettings.shiftSpaceCombination
        @State private var bracketKeysMode: BracketKeysMode = AppSettings.bracketKeysMode
        @State private var commaPeriodKeysMode: CommaPeriodKeysMode = AppSettings.commaPeriodKeysMode

        var body: some View {
                ScrollView {
                        LazyVStack(spacing: 16) {
                                VStack {
                                        HStack(spacing: 4) {
                                                LabelText("HotkeysView.PressShiftOnceTo")
                                                Text.separator
                                                Picker("HotkeysView.PressShiftOnceTo", selection: $pressShiftOnce) {
                                                        Text("HotkeysView.PressShiftOnceTo.DoNothing").tag(PressShiftOnce.doNothing)
                                                        Text("HotkeysView.SwitchInputMethodMode").tag(PressShiftOnce.switchInputMethodMode)
                                                }
                                                .pickerStyle(.menu)
                                                .labelsHidden()
                                                .fixedSize()
                                                .onChange(of: pressShiftOnce) { newOption in
                                                        AppSettings.updatePressShiftOnce(to: newOption)
                                                }
                                                Spacer()
                                        }
                                        HStack(spacing: 4) {
                                                LabelText("HotkeysView.PressShiftSpaceTo")
                                                Text.separator
                                                Picker("HotkeysView.PressShiftSpaceTo", selection: $shiftSpaceCombination) {
                                                        Text("HotkeysView.PressShiftSpaceTo.InputFullWidthSpace").tag(ShiftSpaceCombination.inputFullWidthSpace)
                                                        Text("HotkeysView.SwitchInputMethodMode").tag(ShiftSpaceCombination.switchInputMethodMode)
                                                }
                                                .pickerStyle(.menu)
                                                .labelsHidden()
                                                .fixedSize()
                                                .onChange(of: shiftSpaceCombination) { newOption in
                                                        AppSettings.updateShiftSpaceCombination(to: newOption)
                                                }
                                                Spacer()
                                        }
                                }
                                .block()
                                VStack {
                                        HStack(spacing: 4) {
                                                LabelText("HotkeysView.BracketKeysMode")
                                                Text.separator
                                                Picker("HotkeysView.BracketKeysMode", selection: $bracketKeysMode) {
                                                        Text("HotkeysView.BracketKeysMode.CharacterSelection").tag(BracketKeysMode.characterSelection)
                                                        Text("HotkeysView.BracketKeysMode.CandidatePaging").tag(BracketKeysMode.candidatePaging)
                                                        Text("HotkeysView.BracketKeysMode.NoOperation").tag(BracketKeysMode.noOperation)
                                                }
                                                .pickerStyle(.menu)
                                                .labelsHidden()
                                                .fixedSize()
                                                .onChange(of: bracketKeysMode) { newOption in
                                                        AppSettings.updateBracketKeysMode(to: newOption)
                                                }
                                                Spacer()
                                        }
                                        HStack(spacing: 4) {
                                                LabelText("HotkeysView.CommaPeriodKeysMode")
                                                Text.separator
                                                Picker("HotkeysView.CommaPeriodKeysMode", selection: $commaPeriodKeysMode) {
                                                        Text("HotkeysView.CommaPeriodKeysMode.CandidatePaging").tag(CommaPeriodKeysMode.candidatePaging)
                                                        Text("HotkeysView.CommaPeriodKeysMode.CharacterSelection").tag(CommaPeriodKeysMode.characterSelection)
                                                        Text("HotkeysView.CommaPeriodKeysMode.NoOperation").tag(CommaPeriodKeysMode.noOperation)
                                                }
                                                .pickerStyle(.menu)
                                                .labelsHidden()
                                                .fixedSize()
                                                .onChange(of: commaPeriodKeysMode) { newOption in
                                                        AppSettings.updateCommaPeriodKeysMode(to: newOption)
                                                }
                                                Spacer()
                                        }
                                }
                                .block()

                                VStack(spacing: 2) {
                                        HStack(spacing: 4) {
                                                LabelText("HotkeysView.OpenPreferencesWindow")
                                                Text.separator
                                                KeyBlockView.control
                                                Text.plus
                                                KeyBlockView.shift
                                                Text.plus
                                                KeyBlockView(",")
                                                Spacer()
                                        }
                                        .block()
                                        HStack(spacing: 2) {
                                                SymbolKeyView(",")
                                                Text("HotkeysView.OpenPreferencesWindow.Footer").font(.subheadline)
                                                Spacer()
                                        }
                                        .padding(.horizontal, 8)
                                }
                                VStack(spacing: 2) {
                                        HStack(spacing: 4) {
                                                LabelText("HotkeysView.EnterExitOptionsView")
                                                Text.separator
                                                KeyBlockView.control
                                                Text.plus
                                                KeyBlockView.shift
                                                Text.plus
                                                KeyBlockView("`")
                                                Spacer()
                                        }
                                        .block()
                                        HStack(spacing: 2) {
                                                SymbolKeyView("`")
                                                Text("HotkeysView.EnterExitOptionsView.Footer").font(.subheadline)
                                                Spacer()
                                        }
                                        .padding(.horizontal, 8)
                                }
                                VStack(spacing: 2) {
                                        HStack(spacing: 4) {
                                                LabelText("HotkeysView.DirectlyToggleSpecificOption")
                                                Text.separator
                                                KeyBlockView.control
                                                Text.plus
                                                KeyBlockView.shift
                                                Text.plus
                                                KeyBlockView.number
                                                Spacer()
                                        }
                                        .block()
                                        HStack {
                                                Text(verbatim: "number: 1, 2, 3, ... 8, 9, 0")
                                                Spacer()
                                        }
                                        .font(.subheadline)
                                        .padding(.horizontal, 8)
                                }
                                VStack(spacing: 8) {
                                        HStack(spacing: 4) {
                                                LabelText("HotkeysView.ClearCurrentPreEditText")
                                                Text.separator
                                                KeyBlockView.escape
                                                Text.or
                                                KeyBlockView.control
                                                Text.plus
                                                KeyBlockView.shift
                                                Text.plus
                                                KeyBlockView("U")
                                                Spacer()
                                        }
                                        HStack(spacing: 4) {
                                                LabelText("HotkeysView.InputCurrentPreEditText")
                                                Text.separator
                                                KeyBlockView.returnKey
                                                Spacer()
                                        }
                                        HStack(spacing: 4) {
                                                LabelText("HotkeysView.InputCurrentRomanization")
                                                Text.separator
                                                KeyBlockView.shift
                                                Text.plus
                                                KeyBlockView.returnKey
                                                Spacer()
                                        }
                                        HStack(spacing: 4) {
                                                LabelText("HotkeysView.SelectCurrentCandidate")
                                                Text.separator
                                                KeyBlockView.space
                                                Spacer()
                                        }
                                        HStack(spacing: 4) {
                                                LabelText("HotkeysView.SelectFirstCharacterOfCurrentCandidate")
                                                Text.separator
                                                KeyBlockView("[")
                                                Spacer()
                                        }
                                        HStack(spacing: 4) {
                                                LabelText("HotkeysView.SelectLastCharacterOfCurrentCandidate")
                                                Text.separator
                                                KeyBlockView("]")
                                                Spacer()
                                        }
                                        HStack(spacing: 4) {
                                                LabelText("HotkeysView.ForgetCurrentCandidate")
                                                Text.separator
                                                KeyBlockView.control
                                                Text.plus
                                                KeyBlockView.shift
                                                Text.plus
                                                KeyBlockView.backwardDelete
                                                Spacer()
                                        }
                                }
                                .block()
                                VStack(spacing: 2) {
                                        HStack {
                                                Text("HotkeysView.Header.HorizontalOrientation")
                                                Spacer()
                                        }
                                        .font(.subheadline)
                                        .padding(.horizontal, 8)
                                        VStack(spacing: 8) {
                                                HStack(spacing: 4) {
                                                        LabelText("HotkeysView.MoveToPreviousCandidate")
                                                        Text.separator
                                                        KeyBlockView("◀")
                                                        Text.or
                                                        KeyBlockView.shift
                                                        Text.plus
                                                        KeyBlockView.tab
                                                        Spacer()
                                                }
                                                HStack(spacing: 4) {
                                                        LabelText("HotkeysView.MoveToNextCandidate")
                                                        Text.separator
                                                        KeyBlockView("▶")
                                                        Text.or
                                                        KeyBlockView.tab
                                                        Spacer()
                                                }
                                                HStack(spacing: 4) {
                                                        LabelText("HotkeysView.BackwardToPreviousCandidatePage")
                                                        Text.separator
                                                        KeyBlockView("▲")
                                                        Text.or
                                                        KeyBlockView("-")
                                                        Text.or
                                                        KeyBlockView("Page Up ↑")
                                                        Spacer()
                                                }
                                                HStack(spacing: 4) {
                                                        LabelText("HotkeysView.ForwardToNextCandidatePage")
                                                        Text.separator
                                                        KeyBlockView("▼")
                                                        Text.or
                                                        KeyBlockView("=")
                                                        Text.or
                                                        KeyBlockView("Page Down ↓")
                                                        Spacer()
                                                }
                                        }
                                        .block()
                                }
                                VStack(spacing: 2) {
                                        HStack {
                                                Text("HotkeysView.Header.VerticalOrientation")
                                                Spacer()
                                        }
                                        .font(.subheadline)
                                        .padding(.horizontal, 8)
                                        VStack(spacing: 8) {
                                                HStack(spacing: 4) {
                                                        LabelText("HotkeysView.MoveToPreviousCandidate")
                                                        Text.separator
                                                        KeyBlockView("▲")
                                                        Text.or
                                                        KeyBlockView.shift
                                                        Text.plus
                                                        KeyBlockView.tab
                                                        Spacer()
                                                }
                                                HStack(spacing: 4) {
                                                        LabelText("HotkeysView.MoveToNextCandidate")
                                                        Text.separator
                                                        KeyBlockView("▼")
                                                        Text.or
                                                        KeyBlockView.tab
                                                        Spacer()
                                                }
                                                HStack(spacing: 4) {
                                                        LabelText("HotkeysView.BackwardToPreviousCandidatePage")
                                                        Text.separator
                                                        KeyBlockView("◀")
                                                        Text.or
                                                        KeyBlockView("-")
                                                        Text.or
                                                        KeyBlockView("Page Up ↑")
                                                        Spacer()
                                                }
                                                HStack(spacing: 4) {
                                                        LabelText("HotkeysView.ForwardToNextCandidatePage")
                                                        Text.separator
                                                        KeyBlockView("▶")
                                                        Text.or
                                                        KeyBlockView("=")
                                                        Text.or
                                                        KeyBlockView("Page Down ↓")
                                                        Spacer()
                                                }
                                        }
                                        .block()
                                }
                                HStack(spacing: 4) {
                                        LabelText("HotkeysView.BackToTheFirstCandidatePage")
                                        Text.separator
                                        KeyBlockView("Home ⤒")
                                        Spacer()
                                }
                                .block()
                        }
                        .textSelection(.enabled)
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
                        .frame(width: 240, alignment: .leading)
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
                        .minimumScaleFactor(0.5)
                        .frame(width: 64, height: 24)
                        .background(Color.textBackgroundColor, in: RoundedRectangle(cornerRadius: 5, style: .continuous))
        }

        static let control: KeyBlockView = KeyBlockView("Control ⌃")
        static let shift: KeyBlockView = KeyBlockView("Shift ⇧")
        static let number: KeyBlockView = KeyBlockView("number")
        static let space: KeyBlockView = KeyBlockView("Space ␣")
        static let escape: KeyBlockView = KeyBlockView("esc ⎋")
        static let tab: KeyBlockView = KeyBlockView("Tab ⇥")
        static let returnKey: KeyBlockView = KeyBlockView("Return ⏎")

        /// Backspace. NOT Forward-Delete.
        static let backwardDelete: KeyBlockView = KeyBlockView("Delete ⌫")
}

private struct SymbolKeyView: View {
        init(_ keyText: String) {
                self.keyText = keyText
        }
        private let keyText: String
        var body: some View {
                Text(verbatim: keyText)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 1)
                        .stack(cornerRadius: 5)
        }
}

private extension Text {
        static let separator: Text = Text(verbatim: ": ").foregroundColor(.secondary)
        static let plus: Text = Text(verbatim: "+")
        static let or: Text = Text("HotkeysView.Or")
}

