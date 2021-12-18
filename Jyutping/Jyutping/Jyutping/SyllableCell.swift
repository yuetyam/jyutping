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
        }
}
