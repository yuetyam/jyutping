#if os(iOS)

import SwiftUI
import CommonExtensions

struct IOSToneTableView: View {

        @Environment(\.horizontalSizeClass) var horizontalSize

        var body: some View {
                let dataLines: [String] = Constant.toneSourceText.components(separatedBy: .newlines).map({ $0.trimmingCharacters(in: .whitespaces) })
                let spacing: CGFloat = (horizontalSize == .compact) ? 18 : 32
                List {
                        Section {
                                IOSToneTipView()
                        }
                        Section {
                                ForEach(0..<dataLines.count, id: \.self) { index in
                                        IOSToneLabel(dataLines[index], spacing: spacing)
                                }
                        }
                        if #available(iOS 16.0, *) {
                                Section {
                                        IOSToneGridView()
                                }
                                .listRowBackground(Color.clear)
                        }
                }
                .textSelection(.enabled)
                .navigationTitle("IOSJyutpingTab.NavigationTitle.JyutpingTones")
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
                self.syllable = parts[0].filter({ $0.isLowercaseBasicLatinLetter || $0.isCantoneseToneDigit })
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

@available(iOS 16.0, *)
private struct IOSToneGridView: View {
        var body: some View {
                Grid(horizontalSpacing: 14, verticalSpacing: 14) {
                        GridRow {
                                Text(verbatim: "空").hidden()
                                Text(verbatim: "陰")
                                Text(verbatim: "陽")
                        }
                        GridRow {
                                Text(verbatim: "平")
                                IOSToneGridCell(character: "詩", syllable: "si1", tone: "˥")
                                IOSToneGridCell(character: "時", syllable: "si4", tone: "˨˩")
                        }
                        GridRow {
                                Text(verbatim: "上")
                                IOSToneGridCell(character: "史", syllable: "si2", tone: "˧˥")
                                IOSToneGridCell(character: "市", syllable: "si5", tone: "˩˧")
                        }
                        GridRow {
                                Text(verbatim: "去")
                                IOSToneGridCell(character: "試", syllable: "si3", tone: "˧")
                                IOSToneGridCell(character: "事", syllable: "si6", tone: "˨")
                        }
                        GridRow {
                                Text(verbatim: "入")
                                VStack(spacing: 2) {
                                        VStack(alignment: .leading, spacing: 0) {
                                                HStack {
                                                        Text(verbatim: "識 sik1")
                                                        Speaker("sik1")
                                                }
                                                Text(verbatim: "調值: ˥")
                                        }
                                        Divider()
                                        VStack(alignment: .leading, spacing: 0) {
                                                HStack {
                                                        Text(verbatim: "涉 sip3")
                                                        Speaker("sip3")
                                                }
                                                Text(verbatim: "調值: ˧")
                                        }
                                }
                                .padding(4)
                                .background(.background, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
                                .fixedSize()
                                IOSToneGridCell(character: "舌", syllable: "sit6", tone: "˨")
                        }
                }
        }
}

private struct IOSToneGridCell: View {
        let character: String
        let syllable: String
        let tone: String
        var body: some View {
                VStack(alignment: .leading) {
                        HStack {
                                Text(verbatim: "\(character) \(syllable)")
                                Speaker(syllable)
                        }
                        Text(verbatim: "調值 :  \(tone)")
                }
                .padding(8)
                .background(.background, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
        }
}

#endif
