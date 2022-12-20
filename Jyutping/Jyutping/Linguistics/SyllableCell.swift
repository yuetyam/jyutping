import SwiftUI

struct SyllableCell: View {

        init(_ line: String, width: CGFloat) {
                let parts: [String] = line.components(separatedBy: ",")
                self.components = parts
                self.width = width
                self.syllable = String(parts[0].dropFirst(2))
        }

        private let components: [String]
        private let width: CGFloat
        private let syllable: String

        var body: some View {
                HStack {
                        HStack(spacing: 8) {
                                Text(verbatim: components[0])
                                if !syllable.isEmpty {
                                        Speaker(syllable)
                                }
                        }
                        .frame(width: width + 25, alignment: .leading)
                        Text(verbatim: components[1]).frame(width: width - 12, alignment: .leading)
                        Text(verbatim: components[2])
                        Spacer()
                }
                .font(.fixedWidth)
                .textSelection(.enabled)
        }
}


struct MacTableCell: View {

        init(_ line: String, placeholder: String) {
                let parts: [String] = line.components(separatedBy: ",")
                let leading: String = parts[0]
                self.word = leading.filter({ !$0.isASCII })
                self.syllable = leading.filter({ $0.isASCII })
                self.placeholder = placeholder
                self.ipa = parts[1].replacingOccurrences(of: "[", with: "[ ").replacingOccurrences(of: "]", with: " ]").replacingOccurrences(of: "~", with: " ~ ")
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
                                if !syllable.isEmpty {
                                        Speaker(syllable)
                                }
                        }
                        .frame(width: 170, alignment: .leading)

                        Text(verbatim: ipa).frame(width: 128, alignment: .leading)

                        Text(verbatim: jyutping).font(.fixedWidth)

                        Spacer()
                }
                .textSelection(.enabled)
        }
}
