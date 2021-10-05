import SwiftUI
import AVFoundation
import JyutpingProvider

@available(iOS 14.0, *)
struct JyutpingView_iOS14: View {

        private let placeholder: String = NSLocalizedString("Lookup Jyutping for Cantonese", comment: "")
        @State private var inputText: String = ""

        private var rawCantonese: String { inputText.filter({ !($0.isASCII || $0.isPunctuation || $0.isWhitespace) }) }
        private var jyutpings: [String] { JyutpingProvider.search(for: rawCantonese) }

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
                                        VStack(spacing: 8) {
                                                HStack {
                                                        Text("No Results.")
                                                        Spacer()
                                                }
                                                HStack {
                                                        Text("Common Cantonese words only.")
                                                                .font(.footnote)
                                                                .foregroundColor(.secondary)
                                                        Spacer()
                                                }
                                        }
                                } else if !inputText.isEmpty {
                                        if #available(iOS 15.0, *) {
                                                Section {
                                                        HStack {
                                                                Text(verbatim: rawCantonese)
                                                                Spacer()
                                                                Button(action: {
                                                                        Speaker.speak(rawCantonese)
                                                                }) {
                                                                        Image(systemName: "speaker.wave.2")
                                                                }
                                                        }
                                                        ForEach(jyutpings, id: \.self) { jyutping in
                                                                HStack(spacing: 16) {
                                                                        Text(verbatim: jyutping)
                                                                        if rawCantonese.count == 1 {
                                                                                Text(verbatim: Syllable2IPA.ipaText(jyutping)).foregroundColor(.secondary)
                                                                        }
                                                                        Spacer()
                                                                        Button(action: {
                                                                                Speaker.speak(jyutping)
                                                                        }) {
                                                                                Image(systemName: "speaker.wave.2")
                                                                        }
                                                                }
                                                        }
                                                }
                                                .textSelection(.enabled)
                                        } else {
                                                Section {
                                                        HStack {
                                                                Text(verbatim: rawCantonese)
                                                                Spacer()
                                                                Button(action: {
                                                                        Speaker.speak(rawCantonese)
                                                                }) {
                                                                        Image(systemName: "speaker.wave.2")
                                                                }
                                                        }
                                                        ForEach(jyutpings, id: \.self) { jyutping in
                                                                HStack(spacing: 16) {
                                                                        Text(verbatim: jyutping)
                                                                        if rawCantonese.count == 1 {
                                                                                Text(verbatim: Syllable2IPA.ipaText(jyutping)).foregroundColor(.secondary)
                                                                        }
                                                                        Spacer()
                                                                        Button(action: {
                                                                                Speaker.speak(jyutping)
                                                                        }) {
                                                                                Image(systemName: "speaker.wave.2")
                                                                        }
                                                                }
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
                        .navigationTitle("Jyutping")
                }
                .navigationViewStyle(.stack)
        }
}
