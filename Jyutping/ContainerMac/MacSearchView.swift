import SwiftUI
import CommonExtensions

struct MacSearchView: View {

        @State private var inputText: String = .empty
        @State private var cantonese: String = .empty
        @State private var pronunciations: [String] = []

        var body: some View {
                ScrollView {
                        LazyVStack(spacing: 16) {
                                TextField("Lookup Jyutping for Cantonese", text: $inputText)
                                        .textFieldStyle(.roundedBorder)
                                        .disableAutocorrection(true)
                                        .onSubmit {
                                                let trimmedInput: String = inputText.trimmed()
                                                guard trimmedInput != cantonese else { return }
                                                guard !trimmedInput.isEmpty else {
                                                        cantonese = .empty
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
                                        .padding(.vertical)
                                if !cantonese.isEmpty {
                                        HStack {
                                                Text(verbatim: cantonese).font(.title3)
                                                Spacer()
                                                Speaker(cantonese)
                                        }
                                        .block()
                                }
                                ForEach(0..<pronunciations.count, id: \.self) { index in
                                        let romanization: String = pronunciations[index]
                                        HStack(spacing: 16) {
                                                Text(verbatim: romanization).font(.title3)
                                                if cantonese.count == 1 {
                                                        Text(verbatim: Syllable2IPA.IPAText(romanization)).foregroundColor(.secondary)
                                                }
                                                Spacer()
                                                Speaker(romanization)
                                        }
                                        .block()
                                }
                        }
                        .textSelection(.enabled)
                        .padding(32)
                }
                .animation(.default, value: cantonese)
                .navigationTitle("Search")
        }
}
