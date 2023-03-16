import SwiftUI

struct IOSSyllableCell: View {

        init(_ line: String, spacing: CGFloat) {
                let parts: [String] = line.components(separatedBy: ",")
                let leading: String = parts[0]
                self.word = leading.filter({ !$0.isASCII })
                self.syllable = leading.filter(\.isASCII)
                self.ipa = parts[1]
                self.jyutping = parts[2]
                self.spacing = spacing
        }

        private let word: String
        private let syllable: String
        private let ipa: String
        private let jyutping: String

        private let spacing: CGFloat

        var body: some View {
                HStack(spacing: spacing) {
                        HStack(spacing: 0) {
                                ZStack(alignment: .leading) {
                                        HStack(spacing: 4) {
                                                Text(verbatim: "佔")
                                                Text(verbatim: "haang4")
                                        }
                                        .hidden()
                                        HStack(spacing: 4) {
                                                Text(verbatim: word)
                                                if !(syllable.isEmpty) {
                                                        Text(verbatim: syllable)
                                                }
                                        }
                                }
                                ZStack(alignment: .leading) {
                                        Speaker(syllable).hidden()
                                        if !(syllable.isEmpty) {
                                                Speaker(syllable)
                                        }
                                }
                        }
                        ZStack(alignment: .leading) {
                                Text(verbatim: "國際音標").hidden()
                                Text(verbatim: ipa)
                        }
                        Text(verbatim: jyutping).font(.fixedWidth)
                        Spacer()
                }
                .textSelection(.enabled)
        }
}

struct MacSyllableCell: View {

        init(_ line: String) {
                let parts: [String] = line.components(separatedBy: ",")
                let leading: String = parts[0]
                self.word = leading.filter({ !$0.isASCII })
                self.syllable = leading.filter(\.isASCII)
                self.ipa = parts[1].replacingOccurrences(of: "~", with: " ~ ")
                self.jyutping = parts[2]
        }

        private let word: String
        private let syllable: String
        private let ipa: String
        private let jyutping: String

        var body: some View {
                HStack(spacing: 44) {
                        HStack {
                                ZStack(alignment: .leading) {
                                        HStack {
                                                Text(verbatim: "佔").font(.master)
                                                Text(verbatim: "gwaang6").font(.fixedWidth)
                                        }
                                        .hidden()
                                        HStack {
                                                Text(verbatim: word).font(.master)
                                                if !(syllable.isEmpty) {
                                                        Text(verbatim: syllable).font(.fixedWidth)
                                                }
                                        }
                                }
                                ZStack(alignment: .leading) {
                                        Speaker(syllable).hidden()
                                        if !(syllable.isEmpty) {
                                                Speaker(syllable)
                                        }
                                }
                        }
                        ZStack(alignment: .leading) {
                                Text(verbatim: "國際音標").hidden()
                                Text(verbatim: ipa)
                        }
                        Text(verbatim: jyutping).font(.fixedWidth)
                        Spacer()
                }
                .textSelection(.enabled)
        }
}
