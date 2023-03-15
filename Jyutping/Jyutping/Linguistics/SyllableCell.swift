import SwiftUI

struct IOSSyllableCell: View {

        init(_ line: String, placeholder: String, width: CGFloat) {
                let parts: [String] = line.components(separatedBy: ",")
                let leading: String = parts[0]
                self.example = leading
                self.syllable = leading.filter({ $0.isASCII })
                self.placeholder = placeholder
                self.ipa = parts[1]
                self.jyutping = parts[2]
                self.width = width
        }

        private let example: String
        private let syllable: String
        private let placeholder: String
        private let ipa: String
        private let jyutping: String
        private let width: CGFloat

        var body: some View {
                HStack {
                        HStack(spacing: 2) {
                                ZStack(alignment: .leading) {
                                        Text(verbatim: placeholder).hidden()
                                        Text(verbatim: example)
                                }
                                Speaker(syllable)
                        }
                        .frame(width: width + 25, alignment: .leading)

                        Text(verbatim: ipa).frame(width: width - 12, alignment: .leading)

                        Text(verbatim: jyutping).font(.fixedWidth)

                        Spacer()
                }
                .textSelection(.enabled)
        }
}

struct MacSyllableCell: View {

        init(_ line: String, placeholder: String) {
                let parts: [String] = line.components(separatedBy: ",")
                let leading: String = parts[0]
                self.word = leading.filter({ !$0.isASCII })
                self.syllable = leading.filter({ $0.isASCII })
                self.placeholder = placeholder
                self.ipa = parts[1].replacingOccurrences(of: "~", with: " ~ ")
                self.jyutping = parts[2]
        }

        private let word: String
        private let syllable: String
        private let placeholder: String
        private let ipa: String
        private let jyutping: String

        var body: some View {
                HStack {
                        HStack {
                                Text(verbatim: word).font(.master)
                                ZStack(alignment: .leading) {
                                        Text(verbatim: placeholder).hidden()
                                        Text(verbatim: syllable)
                                }
                                Speaker(syllable)
                        }
                        .frame(width: 170, alignment: .leading)

                        Text(verbatim: ipa).frame(width: 128, alignment: .leading)

                        Text(verbatim: jyutping).font(.fixedWidth)

                        Spacer()
                }
                .textSelection(.enabled)
        }
}
