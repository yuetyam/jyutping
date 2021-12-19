import SwiftUI
import LookupData

@available(iOS 14.0, *)
struct JyutpingView_iOS14: View {

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
                                                HStack {
                                                        Text(verbatim: rawCantonese)
                                                        Spacer()
                                                        Speaker(rawCantonese)
                                                }
                                                .contextMenu {
                                                        MenuCopyButton(rawCantonese)
                                                }
                                                ForEach(jyutpings, id: \.self) { romanization in
                                                        HStack(spacing: 16) {
                                                                Text(verbatim: romanization)
                                                                if rawCantonese.count == 1 {
                                                                        Text(verbatim: Syllable2IPA.IPAText(romanization)).foregroundColor(.secondary)
                                                                }
                                                                Spacer()
                                                                Speaker(romanization)
                                                        }
                                                        .contextMenu {
                                                                MenuCopyButton(romanization)
                                                        }
                                                }
                                        }
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
                        .listStyle(.insetGrouped)
                        .animation(.default, value: jyutpings)
                        .navigationTitle("Jyutping")
                }
                .navigationViewStyle(.stack)
        }
}
