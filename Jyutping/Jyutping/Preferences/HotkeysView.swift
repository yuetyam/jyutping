import SwiftUI

struct HotkeysView: View {

        @AppStorage(SettingsKeys.PressShiftOnce) private var pressShiftOnce: Int = AppSettings.pressShiftOnce

        var body: some View {
                ScrollView {
                        LazyVStack(spacing: 16) {
                                HStack {
                                        Picker("Press Shift Key Once To", selection: $pressShiftOnce) {
                                                Text(verbatim: "Do Nothing").tag(1)
                                                Text(verbatim: "Switch between Cantonese and English").tag(2)
                                        }
                                        .scaledToFit()
                                        .pickerStyle(.radioGroup)
                                        .onChange(of: pressShiftOnce) { newValue in
                                                AppSettings.updatePressShiftOnce(to: newValue)
                                        }
                                        Spacer()
                                }
                                .block()
                        }
                        .padding()
                }
                .background(.ultraThinMaterial)
                .navigationTitle("Hotkeys")
        }
}
