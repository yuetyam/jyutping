import SwiftUI

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
                List {
                        Section {
                                Text(verbatim: "Note: This App does NOT contain an Input Method / Keyboard for macOS.")
                        }
                        Section {
                                Text("Tones Input").font(.headline)
                                Text(verbatim: tonesInputDescription)
                                        .font(.body.monospaced())
                                        .lineSpacing(5)
                                        .fixedSize(horizontal: true, vertical: false)
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
                                        .font(.body.monospaced())
                                        .lineSpacing(5)
                        }
                        Section {
                                Text("Lookup Jyutping with Loengfan").font(.headline)
                                Text("Loengfan Reverse Lookup Description").lineSpacing(6)
                        }
                        Section {
                                Text("Period (Full Stop) Shortcut").font(.headline)
                                Text("Double tapping the space bar will insert a period followed by a space").lineSpacing(6)
                        }
                        Section {
                                Text("Clear the input buffer syllables").font(.headline)
                                Text("Swipe from right to left on the Delete key will clear the pre-edited syllables").lineSpacing(6)
                        }
                }
                .textSelection(.enabled)
                .navigationTitle("Introductions")
        }
}
