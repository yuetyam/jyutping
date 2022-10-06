import SwiftUI

struct HotkeysView: View {

        @AppStorage(SettingsKeys.SwitchCantoneseEnglish) private var switchCantoneseEnglish: Int = AppSettings.switchCantoneseEnglish

        var body: some View {
                ScrollView {
                        LazyVStack(spacing: 16) {
                                HStack {
                                        Picker("Switch between Cantonese and English", selection: $switchCantoneseEnglish) {
                                                Text("None").tag(1)
                                                HStack(spacing: 4) {
                                                        KeyBlockView.Control
                                                        Text.plus
                                                        KeyBlockView.Shift
                                                        Text.plus
                                                        KeyBlockView.Space
                                                        Text(verbatim: "( ⌃ ⇧ ␣ )")
                                                        Spacer()
                                                }
                                                .tag(2)
                                                HStack(spacing: 4) {
                                                        KeyBlockView.Shift
                                                        Text(verbatim: "( ⇧ )")
                                                        Spacer()
                                                }
                                                .tag(3)
                                        }
                                        .scaledToFit()
                                        .pickerStyle(.radioGroup)
                                        .onChange(of: switchCantoneseEnglish) { newValue in
                                                AppSettings.updateSwitchCantoneseEnglish(to: newValue)
                                        }
                                        Spacer()
                                }
                                .block()
                                VStack(spacing: 8) {
                                        HStack(spacing: 4) {
                                                Text("Display Preferences Window (This Window)")
                                                Text.separator
                                                KeyBlockView.Control
                                                Text.plus
                                                KeyBlockView.Shift
                                                Text.plus
                                                KeyBlockView(",")
                                                Text(verbatim: "( ⌃ ⇧ , )")
                                                Spacer()
                                        }
                                        HStack(spacing: 4) {
                                                Text("Toggle Instant Settings Window")
                                                Text.separator
                                                KeyBlockView.Control
                                                Text.plus
                                                KeyBlockView.Shift
                                                Text.plus
                                                KeyBlockView("`")
                                                Text(verbatim: "( ⌃ ⇧ ` )")
                                                Spacer()
                                        }
                                }
                                .block()
                                VStack(spacing: 8) {
                                        HStack(spacing: 4) {
                                                Text("Clear Input Buffer")
                                                Text.separator
                                                KeyBlockView("esc")
                                                Spacer()
                                        }
                                }
                                .block()
                        }
                        .textSelection(.enabled)
                        .padding()
                }
                .navigationTitle("Hotkeys")
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
                        .minimumScaleFactor(0.5)
                        .padding(.vertical, 2)
                        .frame(width: 64)
                        .background(backColor, in: RoundedRectangle(cornerRadius: 4, style: .continuous))
        }

        static let Control: KeyBlockView = KeyBlockView("Control")
        static let Shift: KeyBlockView = KeyBlockView("Shift")
        static let Space: KeyBlockView = KeyBlockView("Space")
}


private extension Text {
        static let separator: Text = Text(verbatim: ": ").foregroundColor(.secondary)
        static let plus: Text = Text(verbatim: "+")
}

