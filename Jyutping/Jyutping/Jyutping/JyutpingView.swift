import SwiftUI
import AVFoundation
import LookupData

struct JyutpingView: View {

        private let placeholder: String = NSLocalizedString("Lookup Jyutping for Cantonese", comment: .empty)
        @State private var inputText: String = .empty

        private var rawCantonese: String { inputText.filtered() }
        private var jyutpings: [String] { LookupData.search(for: rawCantonese) }

        var body: some View {
                NavigationView {
                        List {
                                Section {
                                        HStack {
                                                Image(systemName: "magnifyingglass").opacity(0.5)
                                                EnhancedTextField(placeholder: placeholder,
                                                                  text: $inputText,
                                                                  returnKey: .search,
                                                                  autocorrection: .no,
                                                                  autocapitalization: UITextAutocapitalizationType.none)
                                        }
                                }
                                if !inputText.isEmpty && jyutpings.isEmpty {
                                        Section {
                                                Text("No Results.")
                                                Text("Common Cantonese words only.").font(.footnote)
                                        }
                                } else if !inputText.isEmpty {
                                        Section {
                                                Button {
                                                        Speech.speak(rawCantonese)
                                                } label: {
                                                        HStack {
                                                                Text(verbatim: rawCantonese).foregroundColor(.primary)
                                                                Spacer()
                                                                Image.speaker
                                                        }
                                                }
                                                ForEach(jyutpings, id: \.self) { jyutping in
                                                        Button {
                                                                Speech.speak(jyutping)
                                                        } label: {
                                                                HStack(spacing: 16) {
                                                                        Text(verbatim: jyutping).foregroundColor(.primary)
                                                                        if rawCantonese.count == 1 {
                                                                                Text(verbatim: Syllable2IPA.IPAText(jyutping)).foregroundColor(.secondary)
                                                                        }
                                                                        Spacer()
                                                                        Image.speaker
                                                                }
                                                        }
                                                }
                                        }
                                }

                                Section {
                                        NavigationLink(destination: InitialsTable()) {
                                                Text("Jyutping Initials")
                                        }
                                        NavigationLink(destination: FinalsTable()) {
                                                Text("Jyutping Finals")
                                        }
                                        NavigationLink(destination: TonesTable()) {
                                                Text("Jyutping Tones")
                                        }
                                }

                                Section {
                                        SearchLinksView()
                                } header: {
                                        Text("Search on other places (websites)")
                                }

                                Section {
                                        JyutpingResourcesLinksView()
                                } header: {
                                        Text("Jyutping Resources")
                                }

                                Section {
                                        CantoneseResourcesLinksView()
                                } header: {
                                        Text("Cantonese Resources")
                                }
                        }
                        .listStyle(.grouped)
                        .animation(.default, value: jyutpings)
                        .navigationBarTitle("Jyutping")
                }
                .navigationViewStyle(.stack)
        }
}
