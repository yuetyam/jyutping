#if os(iOS)

import SwiftUI
import Materials

struct SearchView: View {

        let placeholder: LocalizedStringKey
        @Binding var animationState: Int

        @State private var inputText: String = ""
        @State private var cantonese: String = ""
        @State private var pronunciations: [String] = []

        @State private var yingWaaEntries: [YingWaaFanWan] = []
        @State private var choHokEntries: [ChoHokYuetYamCitYiu] = []
        @State private var fanWanEntries: [FanWanCuetYiu] = []
        @State private var gwongWanEntries: [GwongWan] = []

        var body: some View {
                Section {
                        TextField(placeholder, text: $inputText)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled(true)
                                .onSubmit {
                                        let trimmedInput: String = inputText.trimmingCharacters(in: .whitespacesAndNewlines).trimmingCharacters(in: .controlCharacters)
                                        guard trimmedInput != cantonese else { return }
                                        defer {
                                                animationState += 1
                                        }
                                        guard !trimmedInput.isEmpty else {
                                                cantonese = ""
                                                pronunciations = []
                                                yingWaaEntries = []
                                                choHokEntries = []
                                                fanWanEntries = []
                                                gwongWanEntries = []
                                                return
                                        }
                                        yingWaaEntries = AppMaster.lookupYingWaaFanWan(for: trimmedInput)
                                        choHokEntries = AppMaster.lookupChoHokYuetYamCitYiu(for: trimmedInput)
                                        fanWanEntries = AppMaster.lookupFanWanCuetYiu(for: trimmedInput)
                                        gwongWanEntries = AppMaster.lookupGwongWan(for: trimmedInput)
                                        let search = AppMaster.lookup(text: trimmedInput)
                                        if search.romanizations.isEmpty {
                                                cantonese = trimmedInput
                                                pronunciations = []
                                        } else {
                                                cantonese = search.text
                                                pronunciations = search.romanizations
                                        }
                                }
                }
                if !cantonese.isEmpty {
                        Section {
                                CantoneseTextLabel(cantonese)
                                ForEach(0..<pronunciations.count, id: \.self) { index in
                                        RomanizationLabel(pronunciations[index])
                                }
                        }
                        .textSelection(.enabled)
                }
                if !yingWaaEntries.isEmpty {
                        Section {
                                ForEach(0..<yingWaaEntries.count, id: \.self) { index in
                                        YingWaaFanWanLabel(entry: yingWaaEntries[index])
                                }
                        } header: {
                                Text(verbatim: "《英華分韻撮要》　衛三畏　1856　廣州").textCase(nil)
                        }
                        .textSelection(.enabled)
                }
                if !choHokEntries.isEmpty {
                        Section {
                                ForEach(0..<choHokEntries.count, id: \.self) { index in
                                        ChoHokYuetYamCitYiuLabel(entry: choHokEntries[index])
                                }
                        } header: {
                                Text(verbatim: "《初學粵音切要》　湛約翰　1855　香港").textCase(nil)
                        }
                        .textSelection(.enabled)
                }
                if !fanWanEntries.isEmpty {
                        Section {
                                ForEach(0..<fanWanEntries.count, id: \.self) { index in
                                        FanWanCuetYiuLabel(entry: fanWanEntries[index])
                                }
                        } header: {
                                Text(verbatim: "《分韻撮要》　佚名　約明末清初").textCase(nil)
                        }
                        .textSelection(.enabled)
                }
                if !gwongWanEntries.isEmpty {
                        Section {
                                ForEach(0..<gwongWanEntries.count, id: \.self) { index in
                                        GwongWanLabel(entry: gwongWanEntries[index])
                                }
                        } header: {
                                Text(verbatim: "《大宋重修廣韻》").textCase(nil)
                        }
                        .textSelection(.enabled)
                }
        }
}

#endif
