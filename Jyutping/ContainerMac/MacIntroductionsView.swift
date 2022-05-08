import SwiftUI
import CommonExtensions

struct MacIntroductionsView: View {

        private let tonesInputDescription: String = NSLocalizedString("tones.input.description", comment: .empty)
        private let strokes: String = """
        w = 橫(waang)
        s = 豎(syu)
        a = 撇
        d = 點(dim)
        z = 折(zit)
        """

        var body: some View {
                ScrollView {
                        LazyVStack(spacing: 32) {
                                VStack(spacing: 16) {
                                        HStack {
                                                Text("**Note**: This App does NOT contain an Input Method / Keyboard for macOS.")
                                                Spacer()
                                        }
                                        HStack {
                                                Text("**注意**: 本App並無 macOS 輸入法／鍵盤。本App旨在幫助用戶學習、熟悉粵拼及粵拼輸入法")
                                                Spacer()
                                        }
                                }
                                .block()

                                VStack(spacing: 16) {
                                        HStack {
                                                Text("Tones Input").font(.headline)
                                                Spacer()
                                        }
                                        HStack {
                                                Text(verbatim: tonesInputDescription).font(.body.monospaced()).lineSpacing(5)
                                                Spacer()
                                        }
                                }
                                .block()

                                BlockView(heading: "Lookup Jyutping with Cangjie", content: "Cangjie Reverse Lookup Description")
                                BlockView(heading: "Lookup Jyutping with Pinyin", content: "Pinyin Reverse Lookup Description")

                                VStack(spacing: 16) {
                                        HStack {
                                                Text("Lookup Jyutping with Stroke").font(.headline)
                                                Spacer()
                                        }
                                        HStack {
                                                Text("Stroke Reverse Lookup Description").lineSpacing(6)
                                                Spacer()
                                        }
                                        HStack {
                                                Text(verbatim: strokes).font(.body.monospaced()).lineSpacing(5)
                                                Spacer()
                                        }
                                }
                                .block()

                                BlockView(heading: "Lookup Jyutping with Loengfan", content: "Loengfan Reverse Lookup Description")
                                BlockView(heading: "Period (Full Stop) Shortcut", content: "Double tapping the space bar will insert a period followed by a space")
                                BlockView(heading: "Clear the input buffer syllables", content: "Swipe from right to left on the Delete key will clear the pre-edited syllables")
                        }
                        .textSelection(.enabled)
                        .padding(32)
                }
                .navigationTitle("Introductions")
        }
}


struct BlockView: View {

        let heading: LocalizedStringKey
        let content: LocalizedStringKey

        var body: some View {
                VStack(spacing: 16) {
                        HStack {
                                Text(heading).font(.headline)
                                Spacer()
                        }
                        HStack {
                                Text(content).lineSpacing(6)
                                Spacer()
                        }
                }
                .block()
        }
}

