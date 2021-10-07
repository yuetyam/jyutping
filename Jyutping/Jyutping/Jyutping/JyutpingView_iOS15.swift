import SwiftUI
import JyutpingProvider

@available(iOS 15.0, *)
struct JyutpingView_iOS15: View {

        @State private var inputText: String = ""
        @State private var submittedText: String = ""
        @State private var cantonese: String = ""
        @State private var pronunciations: [String] = []

        var body: some View {
                NavigationView {
                        List {
                                Section {
                                        TextField("Lookup Jyutping for Cantonese", text: $inputText)
                                                .autocapitalization(.none)
                                                .disableAutocorrection(true)
                                                .onSubmit {
                                                        submittedText = inputText
                                                        let newInput: String = inputText.filter({ !($0.isASCII || $0.isPunctuation || $0.isWhitespace) })
                                                        if cantonese != newInput {
                                                                cantonese = newInput
                                                                pronunciations = newInput.isEmpty ? [] : JyutpingProvider.search(for: newInput)
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
                                                        Button(action: {
                                                                Speaker.speak(cantonese)
                                                        }) {
                                                                Image.speaker
                                                        }
                                                }
                                                ForEach(pronunciations, id: \.self) { romanization in
                                                        HStack(spacing: 16) {
                                                                Text(verbatim: romanization)
                                                                if cantonese.count == 1 {
                                                                        Text(verbatim: Syllable2IPA.IPAText(romanization)).foregroundColor(.secondary)
                                                                }
                                                                Spacer()
                                                                Button(action: {
                                                                        Speaker.speak(romanization)
                                                                }) {
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
