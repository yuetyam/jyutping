#if os(iOS)

import SwiftUI

struct IOSToneTableView: View {

        @Environment(\.horizontalSizeClass) var horizontalSize

        var body: some View {
                let dataLines: [String] = Constant.toneSourceText.components(separatedBy: .newlines).map({ $0.trimmingCharacters(in: .whitespaces) })
                let spacing: CGFloat = (horizontalSize == .compact) ? 18 : 32
                List {
                        Section {
                                ForEach(0..<dataLines.count, id: \.self) { index in
                                        IOSToneLabel(dataLines[index], spacing: spacing)
                                }
                        }
                        Section {
                                IOSToneTipView()
                        }
                }
                .textSelection(.enabled)
                .navigationTitle("Jyutping Tones")
                .navigationBarTitleDisplayMode(.inline)
        }
}

private struct IOSToneTipView: View {
        var body: some View {
                VStack(spacing: 0) {
                        HStack {
                                Text(verbatim: "聲調之「上」應讀上聲 soeng5")
                                Speaker("soeng5")
                                Spacer()
                        }
                        HStack {
                                Text(verbatim: "而非去聲 soeng6")
                                Speaker("soeng6")
                                Spacer()
                        }
                }
        }
}

private struct IOSToneLabel: View {

        init(_ line: String, spacing: CGFloat) {
                let parts: [String] = line.components(separatedBy: ",")
                self.example = parts[0]
                self.syllable = String(parts[0].dropFirst(2))
                self.toneValue = parts[1]
                self.toneName = parts[2]
                self.tone = parts[3]
                self.spacing = spacing
        }

        private let example: String
        private let syllable: String
        private let toneValue: String
        private let toneName: String
        private let tone: String

        private let spacing: CGFloat

        var body: some View {
                HStack(spacing: spacing) {
                        HStack(spacing: 4) {
                                ZStack(alignment: .leading) {
                                        Text(verbatim: "法 faat3").hidden()
                                        Text(verbatim: example)
                                }
                                if syllable.isEmpty {
                                        Speaker(syllable).hidden()
                                } else {
                                        Speaker(syllable)
                                }
                        }
                        ZStack(alignment: .leading) {
                                Text(verbatim: "55/53").hidden()
                                Text(verbatim: toneValue)
                        }
                        ZStack(alignment: .leading) {
                                Text(verbatim: "高陰入").hidden()
                                Text(verbatim: toneName)
                        }
                        Text(verbatim: tone)
                }
        }
}

#endif
