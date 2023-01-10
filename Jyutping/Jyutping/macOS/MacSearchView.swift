#if os(macOS)

import SwiftUI
import Materials

struct MacSearchView: View {

        @State private var inputText: String = ""
        @State private var cantonese: String = ""
        @State private var pronunciations: [String] = []
        @State private var yingWaaEntries: [YingWaaFanWan] = []

        @FocusState private var isTextFieldFocused: Bool

        var body: some View {
                ScrollView {
                        LazyVStack(spacing: 16) {
                                TextField("Lookup Jyutping for Cantonese", text: $inputText)
                                        .textFieldStyle(.plain)
                                        .disableAutocorrection(true)
                                        .onSubmit {
                                                let trimmedInput: String = inputText.trimmingCharacters(in: .whitespacesAndNewlines).trimmingCharacters(in: .controlCharacters)
                                                guard trimmedInput != cantonese else { return }
                                                guard !trimmedInput.isEmpty else {
                                                        cantonese = ""
                                                        pronunciations = []
                                                        return
                                                }
                                                yingWaaEntries = AppMaster.lookupYingWaaFanWan(for: trimmedInput)
                                                let search = AppMaster.lookup(text: trimmedInput)
                                                if search.romanizations.isEmpty {
                                                        cantonese = trimmedInput
                                                        pronunciations = []
                                                } else {
                                                        cantonese = search.text
                                                        pronunciations = search.romanizations
                                                }
                                        }
                                        .focused($isTextFieldFocused)
                                        .padding(8)
                                        .background(Color.textBackgroundColor, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
                                        .padding(.vertical)
                                        .onAppear {
                                                isTextFieldFocused = true
                                        }
                                if !cantonese.isEmpty {
                                        HStack {
                                                Text(verbatim: cantonese)
                                                Spacer()
                                                Speaker(cantonese)
                                        }
                                        .block()
                                }
                                if !pronunciations.isEmpty {
                                        VStack {
                                                ForEach(0..<pronunciations.count, id: \.self) { index in
                                                        let romanization: String = pronunciations[index]
                                                        HStack(spacing: 16) {
                                                                Text(verbatim: romanization).font(.title3.monospaced())
                                                                if cantonese.count == 1 {
                                                                        Text(verbatim: Syllable2IPA.IPAText(romanization)).foregroundColor(.secondary)
                                                                }
                                                                Spacer()
                                                                Speaker(romanization)
                                                        }
                                                        if (index < pronunciations.count - 1) {
                                                                Divider()
                                                        }
                                                }
                                        }
                                        .block()
                                }
                                if !yingWaaEntries.isEmpty {
                                        VStack(spacing: 2) {
                                                HStack {
                                                        Text(verbatim: yingWaaEntries.first!.word)
                                                        Text(verbatim: "《英華分韻撮要》")
                                                        Text(verbatim: "衛三畏(Samuel Wells Williams)　1856　廣州").foregroundColor(.secondary)
                                                        Spacer()
                                                }
                                                .font(.copilot)
                                                VStack {
                                                        ForEach(0..<yingWaaEntries.count, id: \.self) { index in
                                                                YingWaaFanWanView(entry: yingWaaEntries[index])
                                                                if (index < yingWaaEntries.count - 1) {
                                                                        Divider()
                                                                }
                                                        }
                                                }
                                                .block()
                                        }
                                        .padding(.vertical)
                                }
                        }
                        .font(.master)
                        .textSelection(.enabled)
                        .padding()
                }
                .animation(.default, value: cantonese)
                .navigationTitle("Search")
        }
}

private struct YingWaaFanWanView: View {
        let entry: YingWaaFanWan
        var body: some View {
                VStack(alignment: .leading) {
                        HStack(spacing: 16) {
                                HStack {
                                        Text(verbatim: "書本原文標示")
                                        Text.separator
                                        Text(verbatim: entry.romanization)
                                }
                                if let romanizationType = entry.romanizationType {
                                        Text(verbatim: romanizationType)
                                }
                                if let romanizationNote = entry.romanizationNote {
                                        Text(verbatim: romanizationNote)
                                }
                                if let interpretation = entry.interpretation {
                                        Text(verbatim: interpretation)
                                }
                                if let note = entry.note {
                                        Text(verbatim: note)
                                }
                        }
                        HStack(spacing: 16) {
                                HStack {
                                        Text(verbatim: "對應現代粵拼")
                                        Text.separator
                                        Text(verbatim: entry.jyutping)
                                }
                                Text(verbatim: Syllable2IPA.IPAText(entry.jyutping)).foregroundColor(.secondary)
                                if let note = entry.note {
                                        Text(verbatim: note)
                                }
                                Spacer()
                                Speaker(entry.jyutping)
                        }
                }
        }
}

#endif
