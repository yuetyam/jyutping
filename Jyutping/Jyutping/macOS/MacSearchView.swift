#if os(macOS)

import SwiftUI

struct MacSearchView: View {

        @State private var inputText: String = ""
        @State private var cantonese: String = ""
        @State private var pronunciations: [String] = []

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
                                                        .block()
                                                }
                                        }
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

#endif
