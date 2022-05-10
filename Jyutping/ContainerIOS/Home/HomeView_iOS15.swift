import SwiftUI
import CommonExtensions

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

        private let tonesInputDescription: String = NSLocalizedString("tones.input.description", comment: .empty)
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
                                                        guard inputText != cantonese else { return }
                                                        guard !inputText.isEmpty else {
                                                                cantonese = inputText
                                                                pronunciations = []
                                                                return
                                                        }
                                                        let search = AppMaster.lookup(text: inputText)
                                                        if search.romanizations.isEmpty {
                                                                cantonese = inputText
                                                                pronunciations = []
                                                        } else {
                                                                cantonese = search.text
                                                                pronunciations = search.romanizations
                                                        }
                                                }
                                }
                                if !cantonese.isEmpty && !pronunciations.isEmpty {
                                        Section {
                                                HStack {
                                                        Text(verbatim: cantonese)
                                                        Spacer()
                                                        Speaker(cantonese)
                                                }
                                                ForEach(pronunciations, id: \.self) { romanization in
                                                        HStack(spacing: 16) {
                                                                Text(verbatim: romanization)
                                                                if cantonese.count == 1 {
                                                                        Text(verbatim: Syllable2IPA.IPAText(romanization)).foregroundColor(.secondary)
                                                                }
                                                                Spacer()
                                                                Speaker(romanization)
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
                                                .accessibilityLabel("accessibility.how_to_enable_this_keyboard")
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
                                                Text(verbatim: tonesInputDescription)
                                                        .font(.body.monospaced())
                                                        .lineSpacing(5)
                                                        .fixedSize(horizontal: true, vertical: false)
                                                        .contextMenu {
                                                                MenuCopyButton(tonesInputDescription)
                                                        }
                                        }
                                        Section {
                                                Text("Lookup Jyutping with Cangjie").font(.headline)
                                                Text("Cangjie Reverse Lookup Description").lineSpacing(6)
                                        }
                                        .textSelection(.enabled)
                                        Section {
                                                Text("Lookup Jyutping with Pinyin").font(.headline)
                                                Text("Pinyin Reverse Lookup Description").lineSpacing(6)
                                        }
                                        .textSelection(.enabled)
                                        Section {
                                                Text("Lookup Jyutping with Stroke").font(.headline).textSelection(.enabled)
                                                Text("Stroke Reverse Lookup Description").lineSpacing(6).textSelection(.enabled)
                                                Text(verbatim: strokes)
                                                        .font(.body.monospaced())
                                                        .lineSpacing(5)
                                                        .contextMenu {
                                                                MenuCopyButton(strokes)
                                                        }
                                        }
                                }
                                Section {
                                        NavigationLink {
                                                IntroductionsView().textSelection(.enabled)
                                        } label: {
                                                Label("More Introductions", systemImage: "info.circle")
                                        }
                                        NavigationLink {
                                                ExpressionsView().textSelection(.enabled)
                                        } label: {
                                                Label("Cantonese Expressions", systemImage: "checkmark.seal")
                                        }
                                }
                                Section {
                                        NavigationLink {
                                                FAQView().textSelection(.enabled)
                                        } label: {
                                                Label("Frequently Asked Questions", systemImage: "questionmark.circle")
                                        }
                                        NavigationLink {
                                                PrivacyNoticeView().textSelection(.enabled)
                                        } label: {
                                                Label("Privacy Notice", systemImage: "lock.circle")
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
