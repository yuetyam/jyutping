import SwiftUI
import CommonExtensions

struct MacSearchView: View {

        @State private var inputText: String = .empty
        @State private var cantonese: String = .empty
        @State private var pronunciations: [String] = []

        @FocusState private var isTextFieldFocused: Bool

        var body: some View {
                ScrollView {
                        LazyVStack(spacing: 16) {
                                TextField("Lookup Jyutping for Cantonese", text: $inputText)
                                        .textFieldStyle(.plain)
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
                                        .focused($isTextFieldFocused)
                                        .font(.masterHeadline)
                                        .padding(8)
                                        .background(Color.textBackgroundColor, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
                                        .padding(.vertical)
                                        .onAppear {
                                                isTextFieldFocused = true
                                        }
                                if !cantonese.isEmpty {
                                        HStack {
                                                Text(verbatim: cantonese).font(.masterHeadline)
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
                        .padding()
                }
                .animation(.default, value: cantonese)
                .navigationTitle("Search")
        }
}
