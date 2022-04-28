import SwiftUI
import CommonExtensions
import ContainersData

struct HomeView_iOS14: View {

        private let placeholder: String = NSLocalizedString("Text Field", comment: .empty)
        @State private var inputText: String = .empty
        private var rawCantonese: String { inputText.ideographicFiltered() }
        private var jyutpings: [String] { Lookup.look(for: rawCantonese) }

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
                                        .accessibilityLabel("accessibility.how_to_enable_this_keyboard")
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
                                                Text(verbatim: tonesInputDescription)
                                                        .font(.system(.body, design: .monospaced))
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
                                        Section {
                                                Text("Lookup Jyutping with Pinyin").font(.headline)
                                                Text("Pinyin Reverse Lookup Description").lineSpacing(6)
                                        }
                                        Section {
                                                Text("Lookup Jyutping with Stroke").font(.headline)
                                                Text("Stroke Reverse Lookup Description").lineSpacing(6)
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
                                                EnhancedLabel("More Introductions", icon: "info.circle")
                                        }
                                        NavigationLink(destination: ExpressionsView()) {
                                                EnhancedLabel("Cantonese Expressions", icon: "checkmark.seal")
                                        }
                                }
                                Section {
                                        NavigationLink(destination: FAQView()) {
                                                EnhancedLabel("Frequently Asked Questions", icon: "questionmark.circle")
                                        }
                                        NavigationLink(destination: PrivacyNoticeView()) {
                                                EnhancedLabel("Privacy Notice", icon: "lock.circle")
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
