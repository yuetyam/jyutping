import SwiftUI

struct HotkeysView: View {

        @AppStorage(SettingsKeys.PressShiftOnce) private var pressShiftOnce: Int = AppSettings.pressShiftOnce.rawValue

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
                                                Text("Open Preferences Window (This Window)").frame(width: 260, alignment: .leading)
                                                Text.separator
                                                KeyBlockView.Control
                                                Text.plus
                                                KeyBlockView.Shift
                                                Text.plus
                                                KeyBlockView(",")
                                                Spacer()
                                        }
                                        HStack(spacing: 4) {
                                                Text("Open/Close InstantSettings Window").frame(width: 260, alignment: .leading)
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
                                                Text("Directly Select InstantSettings Options").frame(width: 260, alignment: .leading)
                                                Text.separator
                                                KeyBlockView.Control
                                                Text.plus
                                                KeyBlockView.Shift
                                                Text.plus
                                                KeyBlockView("1~0")
                                                Spacer()
                                        }
                                }
                                .block()
                                VStack(spacing: 8) {
                                        HStack(spacing: 4) {
                                                Text("Switch to Cantonese Mode").frame(width: 260, alignment: .leading)
                                                Text.separator
                                                KeyBlockView.Control
                                                Text.plus
                                                KeyBlockView.Shift
                                                Text.plus
                                                KeyBlockView("-")
                                                Spacer()
                                        }
                                        HStack(spacing: 4) {
                                                Text("Switch to English Mode").frame(width: 260, alignment: .leading)
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
                                        Text("Clear Input Buffer").frame(width: 260, alignment: .leading)
                                        Text.separator
                                        KeyBlockView("esc")
                                        Spacer()
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
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .padding(.vertical, 2)
                        .frame(width: 70)
                        .background(backColor, in: RoundedRectangle(cornerRadius: 4, style: .continuous))
        }

        static let Control: KeyBlockView = KeyBlockView("Control ⌃")
        static let Shift: KeyBlockView = KeyBlockView("Shift ⇧")
}


private extension Text {
        static let separator: Text = Text(verbatim: ": ").foregroundColor(.secondary)
        static let plus: Text = Text(verbatim: "+")
}

