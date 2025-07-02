#if os(macOS)

import SwiftUI

struct MacJyutpingToneTable: View {
        var body: some View {
                ScrollView {
                        LazyVStack(alignment: .leading, spacing: 16) {
                                VStack(alignment: .leading, spacing: 2) {
                                        HStack(spacing: 32) {
                                                ZStack(alignment: .leading) {
                                                        Text(verbatim: "例字").hidden()
                                                        Text(verbatim: "例字")
                                                }
                                                ZStack(alignment: .leading) {
                                                        HStack(spacing: 2) {
                                                                Text(verbatim: "faat3")
                                                                Speaker()
                                                        }
                                                        .hidden()
                                                        Text(verbatim: "粵拼")
                                                }
                                                ZStack(alignment: .leading) {
                                                        Text(verbatim: "高陰入").hidden()
                                                        Text(verbatim: "聲調")
                                                }
                                                ZStack(alignment: .leading) {
                                                        Text(verbatim: "55/53").hidden()
                                                        Text(verbatim: "調值")
                                                }
                                                Spacer()
                                        }
                                        .padding(.horizontal, 8)
                                        VStack(alignment: .leading) {
                                                MacToneLabel(word: "芬", syllable: "fan1", toneName: "陰平", toneValue: "55/53")
                                                MacToneLabel(word: "粉", syllable: "fan2", toneName: "陰上", toneValue: "35")
                                                MacToneLabel(word: "糞", syllable: "fan3", toneName: "陰去", toneValue: "33")
                                                MacToneLabel(word: "焚", syllable: "fan4", toneName: "陽平", toneValue: "21/11")
                                                MacToneLabel(word: "憤", syllable: "fan5", toneName: "陽上", toneValue: "13/23")
                                                MacToneLabel(word: "份", syllable: "fan6", toneName: "陽去", toneValue: "22")
                                                MacToneLabel(word: "弗", syllable: "fat1", toneName: "高陰入", toneValue: "5")
                                                MacToneLabel(word: "法", syllable: "faat3", toneName: "低陰入", toneValue: "3")
                                                MacToneLabel(word: "佛", syllable: "fat6", toneName: "陽入", toneValue: "2")
                                        }
                                        .block()
                                }
                                .font(.master)
                                .textSelection(.enabled)
                                if #available(macOS 13.0, *) {
                                        MacToneGridView()
                                }
                                ToneChartView()
                                        .frame(height: 200)
                                        .padding(8)
                                        .block()
                                        .padding(.vertical)
                        }
                        .padding()
                }
                .navigationTitle("MacSidebar.NavigationTitle.JyutpingTones")
        }
}

private struct MacToneLabel: View {
        let word: String
        let syllable: String
        let toneName: String
        let toneValue: String
        var body: some View {
                HStack(spacing: 32) {
                        ZStack(alignment: .leading) {
                                Text(verbatim: "例字").hidden()
                                Text(verbatim: word)
                        }
                        HStack(spacing: 2) {
                                ZStack(alignment: .leading) {
                                        Text(verbatim: "faat3").hidden()
                                        Text(verbatim: syllable)
                                }
                                Speaker(syllable)
                        }
                        ZStack(alignment: .leading) {
                                Text(verbatim: "高陰入").hidden()
                                Text(verbatim: toneName)
                        }
                        ZStack(alignment: .leading) {
                                Text(verbatim: "55/53").hidden()
                                Text(verbatim: toneValue)
                        }
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
                                .background(Color.textBackgroundColor, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
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
                .background(Color.textBackgroundColor, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
        }
}

#endif
