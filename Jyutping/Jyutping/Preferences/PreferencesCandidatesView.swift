import SwiftUI

struct PreferencesCandidatesView: View {

        @State private var pageSize: Int = {
                let savedValue: Int = UserDefaults.standard.integer(forKey: "CandidatesPageSize")
                let isSavedValueValid: Bool = savedValue > 4 && savedValue < 11
                guard isSavedValueValid else { return AppSettings.displayCandidatesPageSize }
                return savedValue
        }()

        var body: some View {
                ScrollView {
                        LazyVStack {
                                HStack {
                                        Picker("Candidates count per page", selection: $pageSize) {
                                                ForEach(5..<11, id: \.self) {
                                                        Text(verbatim: "\($0)").tag($0)
                                                }
                                        }
                                        .scaledToFit()
                                        .onChange(of: pageSize) { newValue in
                                                AppSettings.updateDisplayCandidatesPageSize(to: newValue)
                                        }
                                        Spacer()
                                }
                        }
                        .padding()
                }
                .navigationTitle("Candidates")
        }
}


struct HotkeysView: View {

        @State private var pressShiftOnce: Int = {
                let savedValue: Int = UserDefaults.standard.integer(forKey: "PressShiftOnce")
                switch savedValue {
                case 0:
                        return 1
                case 1:
                        return 1
                case 2:
                        return 2
                default:
                        return 1
                }
        }()

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

