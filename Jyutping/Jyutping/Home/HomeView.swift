import SwiftUI
import AVFoundation
import JyutpingProvider

struct HomeView: View {

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
                                        HStack {
                                                Text("How to enable this Keyboard")
                                                Spacer()
                                        }
                                        .font(.headline)
                                        VStack(spacing: 5) {
                                                HStack {
                                                        dotText
                                                        Text("Jump to")
                                                        Text("Settings").fontWeight(.semibold)
                                                        Spacer()
                                                }
                                                HStack {
                                                        dotText
                                                        Text("Tap")
                                                        Text("Keyboards").fontWeight(.semibold)
                                                        Spacer()
                                                }
                                                HStack {
                                                        dotText
                                                        Text("Turn on")
                                                        Text("Jyutping").fontWeight(.semibold)
                                                        Spacer()
                                                }
                                                HStack {
                                                        dotText
                                                        Text("Turn on")
                                                        Text("Allow Full Access").fontWeight(.semibold)
                                                        Spacer()
                                                }
                                                .padding(.bottom)
                                        }
                                }
                                Section {
                                        Button(action: {
                                                guard let url: URL = URL(string: UIApplication.openSettingsURLString) else { return }
                                                UIApplication.shared.open(url)
                                        }) {
                                                HStack{
                                                        Spacer()
                                                        Text("Go to")
                                                        Text("Settings").fontWeight(.semibold)
                                                        Spacer()
                                                }
                                        }
                                }
                                Section {
                                        HStack {
                                                Text("Tones Input")
                                                Spacer()
                                        }
                                        .font(.headline)
                                        HStack {
                                                Text(tonesInputContent)
                                                        .font(.system(.body, design: .monospaced))
                                                        .lineSpacing(5)
                                                        .fixedSize(horizontal: true, vertical: false)
                                                Spacer()
                                        }
                                        .padding(.bottom)
                                        .contextMenu {
                                                MenuCopyButton(content: tonesInputContent)
                                        }
                                }
                                Section {
                                        HStack {
                                                Text("Lookup Jyutping with Cangjie")
                                                Spacer()
                                        }
                                        .font(.headline)
                                        HStack {
                                                Text("以 v 開始，再輸入倉頡碼即可。例如輸入 vdam 就會出「查」等。候選詞會帶顯示對應嘅粵拼。").lineSpacing(6)
                                                Spacer()
                                        }
                                        .padding(.bottom)
                                }
                                Section {
                                        HStack {
                                                Text("Lookup Jyutping with Stroke")
                                                Spacer()
                                        }
                                        .font(.headline)
                                        HStack {
                                                Text("以 x 開始，再輸入筆畫碼即可。例如輸入 xwsad 就會出「木」等。候選詞會帶顯示對應嘅粵拼。").lineSpacing(6)
                                                Spacer()
                                        }
                                        .padding(.bottom)
                                        HStack {
                                                Text("""
                                                w = 橫(waang)
                                                s = 豎(syu)
                                                a = 撇
                                                d = 點(dim)
                                                z = 折(zit)
                                                """)
                                                Spacer()
                                        }
                                        .font(.system(.body, design: .monospaced))
                                        .lineSpacing(6)
                                        .padding(.bottom)
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
                                                        HStack {
                                                                Text("Copy")
                                                                Spacer()
                                                                Image(systemName: "doc.on.doc")
                                                        }
                                                }
                                        }
                                }
                                Section {
                                        HStack {
                                                Text("Lookup Jyutping with Pinyin")
                                                Spacer()
                                        }
                                        .font(.headline)
                                        HStack {
                                                Text("以 r 開始，再輸入普通話拼音即可。例如輸入 rcha 就會出「查」等。候選詞會帶顯示對應嘅粵拼。").lineSpacing(6)
                                                Spacer()
                                        }
                                        .padding(.bottom)
                                }
                                Section {
                                        HStack {
                                                Text("Period (Full Stop) Shortcut")
                                                Spacer()
                                        }
                                        .font(.headline)
                                        HStack {
                                                Text("Double tapping the space bar will insert a period followed by a space").lineSpacing(6)
                                                Spacer()
                                        }
                                        .padding(.bottom)
                                }
                        }
                        .listStyle(.grouped)
                        .navigationBarTitle("Home")
                }
                .navigationViewStyle(.stack)
        }
}


struct HomeView_Previews: PreviewProvider {
        static var previews: some View {
                HomeView()
        }
}
