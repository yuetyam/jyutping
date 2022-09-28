import SwiftUI

struct HotkeysView: View {

        @State private var pressShiftOnce: Int = AppSettings.pressShiftOnce

        var body: some View {
                ScrollView {
                        LazyVStack {
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
                        }
                        .padding()
                }
                .navigationTitle("Hotkeys")
        }
}
