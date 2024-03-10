#if os(macOS)

import SwiftUI
import CommonExtensions

struct MacToneTableView: View {
        var body: some View {
                let dataLines: [String] = Constant.toneSourceText.components(separatedBy: .newlines).map({ $0.trimmingCharacters(in: .whitespaces) })
                ScrollView {
                        LazyVStack(spacing: 16) {
                                MacToneTipView()
                                VStack {
                                        ForEach(0..<dataLines.count, id: \.self) { index in
                                                MacToneLabel(dataLines[index])
                                        }
                                }
                                .block()
                                if #available(macOS 13.0, *) {
                                        HStack {
                                                MacToneGridView()
                                                Spacer()
                                        }
                                }
                        }
                        .padding()
                }
                .navigationTitle("MacSidebar.NavigationTitle.JyutpingTones")
        }
}

private struct MacToneTipView: View {
        var body: some View {
                HStack {
                        Text(verbatim: "聲調之「上」應讀上聲 soeng5")
                        Speaker("soeng5")
                        Text(verbatim: "而非去聲 soeng6")
                        Speaker("soeng6")
                        Spacer()
                }
                .font(.master)
                .textSelection(.enabled)
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(Color.textBackgroundColor, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
        }
}

@available(macOS 13.0, *)
private struct MacToneGridView: View {
        var body: some View {
                Grid(horizontalSpacing: 12, verticalSpacing: 8) {
                        GridRow {
                                Text(verbatim: "空").hidden()
                                Text(verbatim: "平")
                                Text(verbatim: "上")
                                Text(verbatim: "去")
                                Text(verbatim: "入")
                        }
                        GridRow {
                                Text(verbatim: "陰")
                                MacToneGridCell(character: "詩", syllable: "si1", tone: "˥")
                                MacToneGridCell(character: "史", syllable: "si2", tone: "˧˥")
                                MacToneGridCell(character: "試", syllable: "si3", tone: "˧")
                                VStack(spacing: 2) {
                                        HStack(spacing: 4) {
                                                Text(verbatim: "識 sik1")
                                                Speaker("sik1")
                                                Text(verbatim: "調值: ˥")
                                        }
                                        Divider()
                                        HStack(spacing: 4) {
                                                Text(verbatim: "涉 sip3")
                                                Speaker("sip3")
                                                Text(verbatim: "調值: ˧")
                                        }
                                }
                                .padding(8)
                                .background(Color.textBackgroundColor, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
                                .fixedSize()
                        }
                        GridRow {
                                Text(verbatim: "陽")
                                MacToneGridCell(character: "時", syllable: "si4", tone: "˨˩")
                                MacToneGridCell(character: "市", syllable: "si5", tone: "˩˧")
                                MacToneGridCell(character: "事", syllable: "si6", tone: "˨")
                                MacToneGridCell(character: "舌", syllable: "sit6", tone: "˨")
                        }
                }
                .font(.master)
                .textSelection(.enabled)
        }
}

private struct MacToneGridCell: View {
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
                .background(Color.textBackgroundColor, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
        }
}

private struct MacToneLabel: View {

        init(_ line: String) {
                let parts: [String] = line.components(separatedBy: ",")
                self.example = parts[0]
                self.syllable = parts[0].filter({ $0.isLowercaseBasicLatinLetter || $0.isCantoneseToneDigit })
                self.toneValue = parts[1]
                self.toneName = parts[2]
                self.tone = parts[3]
        }

        private let example: String
        private let syllable: String
        private let toneValue: String
        private let toneName: String
        private let tone: String

        var body: some View {
                HStack(spacing: 44) {
                        HStack(spacing: 8) {
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
                        Spacer()
                }
                .font(.master)
                .textSelection(.enabled)
        }
}

#endif
