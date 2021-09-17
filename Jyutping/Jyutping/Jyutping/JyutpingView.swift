import SwiftUI
import AVFoundation
import JyutpingProvider

struct JyutpingView: View {

        private let placeholder: String = NSLocalizedString("Lookup Jyutping for Cantonese", comment: "")
        @State private var inputText: String = ""

        private var rawCantonese: String { inputText.filter({ !($0.isASCII || $0.isPunctuation || $0.isWhitespace) }) }
        private var jyutpings: [String] { JyutpingProvider.search(for: rawCantonese) }

        private let synthesizer: AVSpeechSynthesizer = AVSpeechSynthesizer()
        private func speak(_ text: String) {
                let utterance: AVSpeechUtterance = AVSpeechUtterance(string: text)
                utterance.voice = AVSpeechSynthesisVoice(language: "zh-HK")
                synthesizer.speak(utterance)
        }

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
                                if (!inputText.isEmpty) && (jyutpings.isEmpty) {
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
                                        Section {
                                                HStack {
                                                        Text(verbatim: rawCantonese)
                                                        Spacer()
                                                        Button(action: {
                                                                speak(rawCantonese)
                                                        }) {
                                                                Image(systemName: "speaker.2")
                                                        }
                                                }
                                                ForEach(jyutpings, id: \.self) { jyutping in
                                                        HStack {
                                                                Text(verbatim: jyutping).font(.system(.body, design: .monospaced))
                                                                Spacer()
                                                                Button(action: {
                                                                        speak(jyutping)
                                                                }) {
                                                                        Image(systemName: "speaker.2")
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
                                        LinkSafariView(url: URL(string: "https://jyut.net")!) {
                                                FootnoteLabelView(icon: "doc.text.magnifyingglass", title: Text(verbatim: "粵音資料集叢"), footnote: "jyut.net")
                                        }
                                        LinkSafariView(url: URL(string: "https://words.hk")!) {
                                                FootnoteLabelView(icon: "doc.text.magnifyingglass", title: Text(verbatim: "粵典"), footnote: "words.hk")
                                        }
                                        LinkSafariView(url: URL(string: "https://humanum.arts.cuhk.edu.hk/Lexis/lexi-can")!) {
                                                FootnoteLabelView(icon: "doc.text.magnifyingglass", title: Text(verbatim: "粵語審音配詞字庫"), footnote: "humanum.arts.cuhk.edu.hk/Lexis/lexi-can")
                                        }
                                        LinkSafariView(url: URL(string: "https://www.jyutdict.org")!) {
                                                FootnoteLabelView(icon: "doc.text.magnifyingglass", title: Text(verbatim: "泛粵大典"), footnote: "www.jyutdict.org")
                                        }
                                        LinkSafariView(url: URL(string: "https://shyyp.net/hant")!) {
                                                FootnoteLabelView(icon: "doc.text.magnifyingglass", title: Text(verbatim: "羊羊粵語"), footnote: "shyyp.net/hant")
                                        }
                                } header: {
                                        Text("Search on other places (websites)")
                                }
                                Section {
                                        LinkSafariView(url: URL(string: "https://www.jyutping.org")!) {
                                                FootnoteLabelView(title: Text("Jyutping"), footnote: "www.jyutping.org")
                                        }
                                        LinkSafariView(url: URL(string: "https://www.lshk.org/jyutping")!) {
                                                FootnoteLabelView(title: Text("Jyutping - LSHK"), footnote: "www.lshk.org/jyutping")
                                        }
                                        LinkSafariView(url: URL(string: "https://www.youtube.com/channel/UCcmAegX-cgcOOconZIwqynw")!) {
                                                FootnoteLabelView(title: Text("Learn Jyutping"), footnote: "www.youtube.com/channel/UCcmAegX-cgcOOconZIwqynw")
                                        }
                                } header: {
                                        Text("Jyutping Resources")
                                }
                                Section {
                                        LinkSafariView(url: URL(string: "https://resonate.hk")!) {
                                                FootnoteLabelView(title: Text(verbatim: "迴響"), footnote: "resonate.hk")
                                        }
                                        LinkSafariView(url: URL(string: "https://hambaanglaang.hk")!) {
                                                FootnoteLabelView(title: Text(verbatim: "冚唪唥粵文"), footnote: "hambaanglaang.hk")
                                        }
                                        LinkSafariView(url: URL(string: "https://www.hok6.com")!) {
                                                FootnoteLabelView(title: Text(verbatim: "學識 Hok6"), footnote: "www.hok6.com")
                                        }
                                } header: {
                                        Text("Cantonese Resources")
                                }
                        }
                        .listStyle(.grouped)
                        .navigationBarTitle("Jyutping")
                }
                .navigationViewStyle(.stack)
        }
}
