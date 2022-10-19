import SwiftUI
import CommonExtensions

@available(iOS 15.0, *)
struct JyutpingView: View {

        @State private var inputText: String = .empty
        @State private var cantonese: String = .empty
        @State private var pronunciations: [String] = []

        var body: some View {
                NavigationView {
                        List {
                                Section {
                                        TextField("Lookup Jyutping for Cantonese", text: $inputText)
                                                .textInputAutocapitalization(.never)
                                                .autocorrectionDisabled(true)
                                                .submitLabel(.search)
                                                .onSubmit {
                                                        let trimmedInput: String = inputText.trimmed()
                                                        guard !trimmedInput.isEmpty else {
                                                                cantonese = .empty
                                                                pronunciations = []
                                                                return
                                                        }
                                                        guard trimmedInput != cantonese else { return }
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
                                                HStack {
                                                        Text(verbatim: cantonese)
                                                        Spacer()
                                                        Speaker(cantonese)
                                                }
                                                ForEach(0..<pronunciations.count, id: \.self) { index in
                                                        let romanization: String = pronunciations[index]
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

                                Section {
                                        TableLinksView()
                                }
                                .labelStyle(.titleOnly)

                                Section {
                                        SearchLinksView()
                                } header: {
                                        Text("Search on other places (websites)").textCase(nil)
                                }

                                Section {
                                        JyutpingResourcesLinksView()
                                } header: {
                                        Text("Jyutping Resources").textCase(nil)
                                }

                                Section {
                                        CantoneseResourcesLinksView()
                                } header: {
                                        Text("Cantonese Resources").textCase(nil)
                                }
                        }
                        .animation(.default, value: cantonese)
                        .navigationTitle("Jyutping")
                }
                .navigationViewStyle(.stack)
        }
}
