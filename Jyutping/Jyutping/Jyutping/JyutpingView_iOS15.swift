import SwiftUI
import LookupData

@available(iOS 15.0, *)
struct JyutpingView_iOS15: View {

        @State private var inputText: String = .empty
        @State private var submittedText: String = .empty
        @State private var cantonese: String = .empty
        @State private var pronunciations: [String] = []

        var body: some View {
                NavigationView {
                        List {
                                Section {
                                        TextField("Lookup Jyutping for Cantonese", text: $inputText)
                                                .autocapitalization(.none)
                                                .disableAutocorrection(true)
                                                .submitLabel(.search)
                                                .onSubmit {
                                                        submittedText = inputText
                                                        let newInput: String = inputText.filtered()
                                                        guard newInput != cantonese else { return }
                                                        guard !newInput.isEmpty else {
                                                                cantonese = newInput
                                                                pronunciations = []
                                                                return
                                                        }
                                                        let fetches: [String] = LookupData.search(for: newInput)
                                                        if fetches.isEmpty {
                                                                let traditionalText: String = newInput.traditional
                                                                let searches: [String] = LookupData.search(for: traditionalText)
                                                                cantonese = searches.isEmpty ? newInput : traditionalText
                                                                pronunciations = searches
                                                        } else {
                                                                cantonese = newInput
                                                                pronunciations = fetches
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
                                                Button {
                                                        Speaker.speak(cantonese)
                                                } label: {
                                                        HStack {
                                                                Text(verbatim: cantonese).foregroundColor(.primary)
                                                                Spacer()
                                                                Image.speaker
                                                        }
                                                }
                                                ForEach(pronunciations, id: \.self) { romanization in
                                                        Button {
                                                                Speaker.speak(romanization)
                                                        } label: {
                                                                HStack(spacing: 16) {
                                                                        Text(verbatim: romanization).foregroundColor(.primary)
                                                                        if cantonese.count == 1 {
                                                                                Text(verbatim: Syllable2IPA.IPAText(romanization)).foregroundColor(.secondary)
                                                                        }
                                                                        Spacer()
                                                                        Image.speaker
                                                                }
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
                                        Text("Search on other places (websites)").textCase(.none)
                                }

                                Section {
                                        JyutpingResourcesLinksView()
                                } header: {
                                        Text("Jyutping Resources").textCase(.none)
                                }

                                Section {
                                        CantoneseResourcesLinksView()
                                } header: {
                                        Text("Cantonese Resources").textCase(.none)
                                }
                        }
                        .animation(.default, value: pronunciations)
                        .navigationTitle("Jyutping")
                }
                .navigationViewStyle(.stack)
        }
}

@available(iOS 15.0, *)
struct JyutpingView_iOS15_Previews: PreviewProvider {
        static var previews: some View {
                JyutpingView_iOS15()
        }
}
