import SwiftUI
import CommonExtensions

struct MacSearchView: View {

        @State private var inputText: String = .empty
        @State private var submittedText: String = .empty
        @State private var cantonese: String = .empty
        @State private var pronunciations: [String] = []

        var body: some View {
                List {
                        Section {
                                HStack {
                                        Image(systemName: "magnifyingglass")
                                        TextField("Lookup Jyutping for Cantonese", text: $inputText)
                                                .disableAutocorrection(true)
                                                .onSubmit {
                                                        submittedText = inputText.trimmed()
                                                        guard submittedText != cantonese else { return }
                                                        guard !submittedText.isEmpty else {
                                                                cantonese = submittedText
                                                                pronunciations = []
                                                                return
                                                        }
                                                        let search = AppMaster.lookup(text: submittedText)
                                                        if search.romanizations.isEmpty {
                                                                cantonese = submittedText
                                                                pronunciations = []
                                                        } else {
                                                                cantonese = search.text
                                                                pronunciations = search.romanizations
                                                        }
                                                }
                                }
                        }
                        if !submittedText.isEmpty && pronunciations.isEmpty {
                                Section {
                                        Text("No Results.")
                                        Text("Common Cantonese words only.").font(.footnote)
                                }
                        } else if !submittedText.isEmpty {
                                Section {
                                        HStack {
                                                Text(verbatim: cantonese)
                                                Spacer()
                                                Speaker(cantonese)
                                        }
                                        ForEach(pronunciations, id: \.self) { romanization in
                                                HStack(spacing: 16) {
                                                        Text(verbatim: romanization)
                                                        if cantonese.count == 1 {
                                                                Text(verbatim: Syllable2IPA.IPAText(romanization)).foregroundColor(.secondary)
                                                        }
                                                        Spacer()
                                                        Speaker(romanization)
                                                }
                                        }
                                }
                                .textSelection(.enabled)
                        }
                }
                .animation(.default, value: pronunciations)
                .navigationTitle("Search")
        }
}
