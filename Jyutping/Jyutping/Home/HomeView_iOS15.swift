import SwiftUI
import AVFoundation
import JyutpingProvider

@available(iOS 15.0, *)
struct HomeView_iOS15: View {

        private let placeholder: String = NSLocalizedString("Text Field", comment: "")
        @State private var inputText: String = ""
        private var rawCantonese: String { inputText.filter({ !($0.isASCII || $0.isPunctuation || $0.isWhitespace) }) }
        private var jyutpings: [String] { JyutpingProvider.search(for: rawCantonese) }
        private let synthesizer: AVSpeechSynthesizer = AVSpeechSynthesizer()
        private func speak(_ text: String) {
                let utterance: AVSpeechUtterance = AVSpeechUtterance(string: text)
                utterance.voice = AVSpeechSynthesisVoice(language: "zh-HK")
                synthesizer.speak(utterance)
        }

        // Tones Input Section
        private let dotText: Text = Text(verbatim: "•")
        private let tonesInputContent: String = NSLocalizedString("v = 1 陰平， vv = 4 陽平\nx = 2 陰上， xx = 5 陽上\nq = 3 陰去， qq = 6 陽去", comment: "")

        var body: some View {
                NavigationView {
                        List {
                                Section {
                                        EnhancedTextField(placeholder: placeholder, text: $inputText)
                                }
                                if (!inputText.isEmpty) && (!jyutpings.isEmpty) {
                                        Section {
                                                HStack {
                                                        Text(verbatim: rawCantonese)
                                                        Spacer()
                                                        Button(action: {
                                                                speak(rawCantonese)
                                                        }) {
                                                                Image(systemName: "speaker.wave.2")
                                                        }
                                                }
                                                ForEach(jyutpings, id: \.self) { jyutping in
                                                        HStack {
                                                                Text(verbatim: jyutping)
                                                                Spacer()
                                                                Button(action: {
                                                                        speak(jyutping)
                                                                }) {
                                                                        Image(systemName: "speaker.wave.2")
                                                                }
                                                        }
                                                }
                                        }
                                        .textSelection(.enabled)
                                }
                                Section {
                                        Text("How to enable this Keyboard").font(.headline)
                                        VStack(spacing: 5) {
                                                HStack {
                                                        dotText
                                                        Text("Jump to **Settings**")
                                                        Spacer()
                                                }
                                                HStack {
                                                        dotText
                                                        Text("Tap **Keyboards**")
                                                        Spacer()
                                                }
                                                HStack {
                                                        dotText
                                                        Text("Turn on **Jyutping**")
                                                        Spacer()
                                                }
                                                HStack {
                                                        dotText
                                                        Text("Turn on **Allow Full Access**")
                                                        Spacer()
                                                }
                                        }
                                }
                                Section {
                                        Button(action: {
                                                guard let url: URL = URL(string: UIApplication.openSettingsURLString) else { return }
                                                UIApplication.shared.open(url)
                                        }) {
                                                HStack{
                                                        Spacer()
                                                        Text("Go to **Settings**")
                                                        Spacer()
                                                }
                                        }
                                }
                                Group {
                                        Section {
                                                Text("Tones Input").font(.headline)
                                                Text(tonesInputContent)
                                                        .font(.system(.body, design: .monospaced))
                                                        .lineSpacing(5)
                                                        .fixedSize(horizontal: true, vertical: false)
                                                        .contextMenu {
                                                                MenuCopyButton(content: tonesInputContent)
                                                        }
                                        }
                                        Section {
                                                Text("Lookup Jyutping with Cangjie").font(.headline)
                                                Text("以 v 開始，再輸入倉頡碼即可。例如輸入 vdam 就會出「查」等。候選詞會帶顯示對應嘅粵拼。").lineSpacing(6).textSelection(.enabled)
                                        }
                                        Section {
                                                Text("Lookup Jyutping with Stroke").font(.headline)
                                                Text("以 x 開始，再輸入筆畫碼即可。例如輸入 xwsad 就會出「木」等。候選詞會帶顯示對應嘅粵拼。").lineSpacing(6).textSelection(.enabled)
                                                Text("""
                                                w = 橫(waang)
                                                s = 豎(syu)
                                                a = 撇
                                                d = 點(dim)
                                                z = 折(zit)
                                                """)
                                                        .font(.system(.body, design: .monospaced))
                                                        .lineSpacing(6)
                                                        .contextMenu {
                                                                Button(action: {
                                                                        let rules: String = """
                                                                        w = 橫(waang)
                                                                        s = 豎(syu)
                                                                        a = 撇
                                                                        d = 點(dim)
                                                                        z = 折(zit)
                                                                        """
                                                                        UIPasteboard.general.string = rules
                                                                }) {
                                                                        Label("Copy", systemImage: "doc.on.doc")
                                                                }
                                                        }
                                        }
                                        Section {
                                                Text("Lookup Jyutping with Pinyin").font(.headline)
                                                Text("以 r 開始，再輸入普通話拼音即可。例如輸入 rcha 就會出「查」等。候選詞會帶顯示對應嘅粵拼。").lineSpacing(6).textSelection(.enabled)
                                        }
                                        Section {
                                                Text("Period (Full Stop) Shortcut").font(.headline)
                                                Text("Double tapping the space bar will insert a period followed by a space").lineSpacing(6).textSelection(.enabled)
                                        }
                                }
                                Section {
                                        Text("Can I use with external keyboards?").font(.headline)
                                        Text("Unfortunately not. Third-party keyboard apps can't communicate with external keyboards due to system limitations.").lineSpacing(6).textSelection(.enabled)
                                }
                        }
                        .navigationTitle("Home")
                }
                .navigationViewStyle(.stack)
        }
}


@available(iOS 15.0, *)
struct HomeView_iOS15_Previews: PreviewProvider {
        static var previews: some View {
                HomeView_iOS15()
        }
}
