import SwiftUI
import AVFoundation
import LookupData

@available(iOS 14.0, *)
struct HomeView_iOS14: View {

        private let placeholder: String = NSLocalizedString("Text Field", comment: .empty)
        @State private var inputText: String = .empty
        private var rawCantonese: String { inputText.filtered() }
        private var jyutpings: [String] { LookupData.search(for: rawCantonese) }

        private let tonesInputContent: String = NSLocalizedString("v = 1 陰平， vv = 4 陽平\nx = 2 陰上， xx = 5 陽上\nq = 3 陰去， qq = 6 陽去", comment: .empty)
        private let strokes: String = """
        w = 橫(waang)
        s = 豎(syu)
        a = 撇
        d = 點(dim)
        z = 折(zit)
        """

        var body: some View {
                NavigationView {
                        List {
                                Section {
                                        EnhancedTextField(placeholder: placeholder, text: $inputText)
                                }
                                if !inputText.isEmpty && !jyutpings.isEmpty {
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
                                        Text("Haptic Feedback requires Full Access").textCase(.none)
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
                                                Text("Lookup Jyutping with Pinyin").font(.headline)
                                                Text("以 r 開始，再輸入普通話拼音即可。例如輸入 rcha 就會出「查」等。候選詞會帶顯示對應嘅粵拼。").lineSpacing(6)
                                        }
                                        Section {
                                                Text("Lookup Jyutping with Stroke").font(.headline)
                                                Text("以 x 開始，再輸入筆畫碼即可。例如輸入 xwsad 就會出「木」等。候選詞會帶顯示對應嘅粵拼。").lineSpacing(6)
                                                Text(verbatim: strokes)
                                                        .font(.system(.body, design: .monospaced))
                                                        .lineSpacing(5)
                                                        .contextMenu {
                                                                MenuCopyButton(strokes)
                                                        }
                                        }
                                }
                                Section {
                                        NavigationLink(destination: IntroductionsView()) {
                                                Label("More Introductions", systemImage: "info.circle")
                                        }
                                        NavigationLink(destination: ExpressionsView()) {
                                                Label("Cantonese Expressions", systemImage: "checkmark.seal")
                                        }

                                        NavigationLink(destination: FAQView()) {
                                                Label("Frequently Asked Questions", systemImage: "questionmark.circle")
                                        }
                                }
                        }
                        .listStyle(.insetGrouped)
                        .animation(.default, value: jyutpings)
                        .navigationTitle("Home")
                }
                .navigationViewStyle(.stack)
        }
}


@available(iOS 14.0, *)
struct HomeView_iOS14_Previews: PreviewProvider {
        static var previews: some View {
                HomeView_iOS14()
        }
}
