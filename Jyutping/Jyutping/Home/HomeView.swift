import SwiftUI
import LookupData

struct HomeView: View {

        private let placeholder: String = NSLocalizedString("Text Field", comment: .empty)
        @State private var inputText: String = .empty
        private var rawCantonese: String { inputText.filtered() }
        private var jyutpings: [String] { LookupData.search(for: rawCantonese) }

        // Tones Input Section
        private let tonesInputContent: String = NSLocalizedString("v = 1 陰平， vv = 4 陽平\nx = 2 陰上， xx = 5 陽上\nq = 3 陰去， qq = 6 陽去", comment: .empty)

        var body: some View {
                NavigationView {
                        List {
                                Section {
                                        EnhancedTextField(placeholder: placeholder, text: $inputText)
                                }
                                if !inputText.isEmpty && !jyutpings.isEmpty {
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
                                        Text("How to enable this Keyboard").font(.headline)
                                        VStack(spacing: 5) {
                                                HStack {
                                                        Text.dotMark
                                                        Text("Jump to")
                                                        Text("Settings").fontWeight(.semibold)
                                                        Spacer()
                                                }
                                                HStack {
                                                        Text.dotMark
                                                        Text("Tap")
                                                        Text("Keyboards").fontWeight(.semibold)
                                                        Spacer()
                                                }
                                                HStack {
                                                        Text.dotMark
                                                        Text("Turn on")
                                                        Text("Jyutping").fontWeight(.semibold)
                                                        Spacer()
                                                }
                                                HStack {
                                                        Text.dotMark
                                                        Text("Turn on")
                                                        Text("Allow Full Access").fontWeight(.semibold)
                                                        Spacer()
                                                }
                                        }
                                } footer: {
                                        Text("Haptic Feedback requires Full Access")
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
                                Group {
                                        Section {
                                                Text("Tones Input").font(.headline)
                                                Text(tonesInputContent)
                                                        .font(.system(.body, design: .monospaced))
                                                        .lineSpacing(5)
                                                        .fixedSize(horizontal: true, vertical: false)
                                                        .contextMenu {
                                                                MenuCopyButton(tonesInputContent)
                                                        }
                                        }
                                        Section {
                                                Text("Lookup Jyutping with Cangjie").font(.headline)
                                                Text("以 v 開始，再輸入倉頡碼即可。例如輸入 vdam 就會出「查」等。候選詞會帶顯示對應嘅粵拼。").lineSpacing(6)
                                        }
                                        Section {
                                                Text("Lookup Jyutping with Stroke").font(.headline)
                                                Text("以 x 開始，再輸入筆畫碼即可。例如輸入 xwsad 就會出「木」等。候選詞會帶顯示對應嘅粵拼。").lineSpacing(6)
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
                                                                        HStack {
                                                                                Text("Copy")
                                                                                Spacer()
                                                                                Image(systemName: "doc.on.doc")
                                                                        }
                                                                }
                                                        }
                                        }
                                        Section {
                                                Text("Lookup Jyutping with Pinyin").font(.headline)
                                                Text("以 r 開始，再輸入普通話拼音即可。例如輸入 rcha 就會出「查」等。候選詞會帶顯示對應嘅粵拼。").lineSpacing(6)
                                        }
                                        Section {
                                                Text("Period (Full Stop) Shortcut").font(.headline)
                                                Text("Double tapping the space bar will insert a period followed by a space").lineSpacing(6)
                                        }
                                }
                                Section {
                                        Text("Can I use with external keyboards?").font(.headline)
                                        Text("Unfortunately not. Third-party keyboard apps can't communicate with external keyboards due to system limitations.").lineSpacing(6)
                                }
                        }
                        .listStyle(.grouped)
                        .animation(.default, value: jyutpings)
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
