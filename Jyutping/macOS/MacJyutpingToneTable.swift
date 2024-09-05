#if os(macOS)

import SwiftUI

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
                .padding(8)
                .background(Color.textBackgroundColor, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
        }
}

struct MacJyutpingToneTable: View {
        var body: some View {
                ScrollView {
                        LazyVStack(alignment: .leading, spacing: 16) {
                                MacToneTipView()
                                VStack(spacing: 2) {
                                        HStack(spacing: 40) {
                                                HStack {
                                                        ZStack(alignment: .leading) {
                                                                Text(verbatim: "法 faat3").hidden()
                                                                Text(verbatim: "例字")
                                                        }
                                                        Speaker().hidden()
                                                }
                                                ZStack(alignment: .leading) {
                                                        Text(verbatim: "55/53").hidden()
                                                        Text(verbatim: "調值")
                                                }
                                                ZStack(alignment: .leading) {
                                                        Text(verbatim: "高陰入").hidden()
                                                        Text(verbatim: "聲調")
                                                }
                                                Text(verbatim: "粵拼")
                                                Spacer()
                                        }
                                        .padding(.horizontal, 8)
                                        VStack {
                                                MacToneLabel(word: "芬", syllable: "fan1", value: "55/53", name: "陰平", jyutping: "1")
                                                MacToneLabel(word: "粉", syllable: "fan2", value: "35", name: "陰上", jyutping: "2")
                                                MacToneLabel(word: "訓", syllable: "fan3", value: "33", name: "陰去", jyutping: "3")
                                                MacToneLabel(word: "焚", syllable: "fan4", value: "21/11", name: "陽平", jyutping: "4")
                                                MacToneLabel(word: "憤", syllable: "fan5", value: "13/23", name: "陽上", jyutping: "5")
                                                MacToneLabel(word: "份", syllable: "fan6", value: "22", name: "陽去", jyutping: "6")
                                                MacToneLabel(word: "忽", syllable: "fat1", value: "5", name: "高陰入", jyutping: "1")
                                                MacToneLabel(word: "法", syllable: "faat3", value: "3", name: "低陰入", jyutping: "3")
                                                MacToneLabel(word: "罰", syllable: "fat6", value: "2", name: "陽入", jyutping: "6")
                                        }
                                        .block()
                                }
                                .font(.master)
                                .textSelection(.enabled)
                                if #available(macOS 13.0, *) {
                                        MacToneGridView()
                                }
                        }
                        .padding()
                }
                .navigationTitle("MacSidebar.NavigationTitle.JyutpingTones")
        }
}

private struct MacToneLabel: View {

        let word: String
        let syllable: String
        let value: String
        let name: String
        let jyutping: String

        var body: some View {
                HStack(spacing: 40) {
                        HStack {
                                ZStack(alignment: .leading) {
                                        Text(verbatim: "法 faat3").hidden()
                                        Text(verbatim: "\(word) \(syllable)")
                                }
                                Speaker(syllable)
                        }
                        ZStack(alignment: .leading) {
                                Text(verbatim: "55/53").hidden()
                                Text(verbatim: value)
                        }
                        ZStack(alignment: .leading) {
                                Text(verbatim: "高陰入").hidden()
                                Text(verbatim: name)
                        }
                        Text(verbatim: jyutping)
                        Spacer()
                }
        }
}

@available(macOS 13.0, *)
private struct MacToneGridView: View {
        var body: some View {
                Grid(horizontalSpacing: 8, verticalSpacing: 4) {
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

#endif
