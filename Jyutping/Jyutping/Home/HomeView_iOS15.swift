import SwiftUI
import LookupData

@available(iOS 15.0, *)
struct HomeView_iOS15: View {

        @State private var inputText: String = .empty
        @State private var cantonese: String = .empty
        @State private var pronunciations: [String] = []

        @State private var isKeyboardEnabled: Bool = {
                guard let keyboards: [String] = UserDefaults.standard.object(forKey: "AppleKeyboards") as? [String] else { return false }
                return keyboards.contains("im.cantonese.CantoneseIM.Keyboard")
        }()
        @State private var isGuideViewExpanded: Bool = false

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
                                        TextField("Text Field", text: $inputText)
                                                .autocapitalization(.none)
                                                .disableAutocorrection(true)
                                                .onSubmit {
                                                        let newInput: String = inputText.filtered()
                                                        guard newInput != cantonese else { return }
                                                        guard !newInput.isEmpty else {
                                                                cantonese = newInput
                                                                pronunciations = []
                                                                return
                                                        }
                                                        let search = LookupData.advancedSearch(for: newInput)
                                                        if search.romanizations.isEmpty {
                                                                cantonese = newInput
                                                                pronunciations = []
                                                        } else {
                                                                cantonese = search.text
                                                                pronunciations = search.romanizations
                                                        }
                                                }
                                }
                                if !cantonese.isEmpty && !pronunciations.isEmpty {
                                        Section {
                                                Button {
                                                        Speaker.speak(cantonese)
                                                } label: {
                                                        HStack {
                                                                Text(verbatim: cantonese).foregroundColor(.primary)
                                                                Spacer()
                                                                Image.speaker
                                                        }
                                                }
                                                ForEach(pronunciations, id: \.self) { romanization in
                                                        Button {
                                                                Speaker.speak(romanization)
                                                        } label: {
                                                                HStack(spacing: 16) {
                                                                        Text(verbatim: romanization).foregroundColor(.primary)
                                                                        if cantonese.count == 1 {
                                                                                Text(verbatim: Syllable2IPA.IPAText(romanization)).foregroundColor(.secondary)
                                                                        }
                                                                        Spacer()
                                                                        Image.speaker
                                                                }
                                                        }
                                                }
                                        }
                                        .textSelection(.enabled)
                                }
                                Section {
                                        if isKeyboardEnabled {
                                                HStack {
                                                        Text("How to enable this Keyboard")
                                                        Spacer()
                                                        if isGuideViewExpanded {
                                                                Image(systemName: "chevron.down")
                                                        } else {
                                                                Image(systemName: "chevron.left")
                                                        }
                                                }
                                                .contentShape(Rectangle())
                                                .onTapGesture {
                                                        isGuideViewExpanded.toggle()
                                                }
                                        } else {
                                                Text("How to enable this Keyboard").font(.headline)
                                        }
                                        if !isKeyboardEnabled || isGuideViewExpanded {
                                                VStack(spacing: 5) {
                                                        HStack {
                                                                Text.dotMark
                                                                Text("Jump to **Settings**")
                                                                Spacer()
                                                        }
                                                        HStack {
                                                                Text.dotMark
                                                                Text("Tap **Keyboards**")
                                                                Spacer()
                                                        }
                                                        HStack {
                                                                Text.dotMark
                                                                Text("Turn on **Jyutping**")
                                                                Spacer()
                                                        }
                                                        HStack {
                                                                Text.dotMark
                                                                Text("Turn on **Allow Full Access**")
                                                                Spacer()
                                                        }
                                                }
                                        }
                                } footer: {
                                        if !isKeyboardEnabled || isGuideViewExpanded {
                                                Text("Haptic Feedback requires Full Access").textCase(.none)
                                        } else {
                                                EmptyView()
                                        }
                                }
                                if !isKeyboardEnabled || isGuideViewExpanded {
                                        Section {
                                                Button {
                                                        guard let url: URL = URL(string: UIApplication.openSettingsURLString) else { return }
                                                        UIApplication.shared.open(url)
                                                } label: {
                                                        HStack{
                                                                Spacer()
                                                                Text("Go to **Settings**")
                                                                Spacer()
                                                        }
                                                }
                                        }
                                }
                                Group {
                                        Section {
                                                Text("Tones Input").font(.headline)
                                                Text(tonesInputContent)
                                                        .font(.body.monospaced())
                                                        .lineSpacing(5)
                                                        .fixedSize(horizontal: true, vertical: false)
                                                        .contextMenu {
                                                                MenuCopyButton(tonesInputContent)
                                                        }
                                        }
                                        Section {
                                                Text("Lookup Jyutping with Cangjie").font(.headline)
                                                Text("以 v 開始，再輸入倉頡碼即可。例如輸入 vdam 就會出「查」等。候選詞會帶顯示對應嘅粵拼。").lineSpacing(6).textSelection(.enabled)
                                        }
                                        Section {
                                                Text("Lookup Jyutping with Pinyin").font(.headline)
                                                Text("以 r 開始，再輸入普通話拼音即可。例如輸入 rcha 就會出「查」等。候選詞會帶顯示對應嘅粵拼。").lineSpacing(6).textSelection(.enabled)
                                        }
                                        Section {
                                                Text("Lookup Jyutping with Stroke").font(.headline)
                                                Text("以 x 開始，再輸入筆畫碼即可。例如輸入 xwsad 就會出「木」等。候選詞會帶顯示對應嘅粵拼。").lineSpacing(6).textSelection(.enabled)
                                                Text(verbatim: strokes)
                                                        .font(.body.monospaced())
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
                        .animation(.default, value: pronunciations)
                        .animation(.default, value: isGuideViewExpanded)
                        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
                                guard let keyboards: [String] = UserDefaults.standard.object(forKey: "AppleKeyboards") as? [String] else { return }
                                let isContained: Bool =  keyboards.contains("im.cantonese.CantoneseIM.Keyboard")
                                if isKeyboardEnabled != isContained {
                                        isKeyboardEnabled = isContained
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
