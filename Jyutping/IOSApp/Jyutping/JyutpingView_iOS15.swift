import SwiftUI

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
