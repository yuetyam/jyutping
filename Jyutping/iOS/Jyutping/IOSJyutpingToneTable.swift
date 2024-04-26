#if os(iOS)

import SwiftUI

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

struct IOSJyutpingToneTable: View {

        @Environment(\.horizontalSizeClass) var horizontalSize

        var body: some View {
                let spacing: CGFloat = (horizontalSize == .compact) ? 18 : 32
                List {
                        Section {
                                IOSToneTipView()
                        }
                        Section {
                                IOSToneLabel(spacing: spacing, word: "芬", syllable: "fan1", value: "55/53", name: "陰平", jyutping: "1")
                                IOSToneLabel(spacing: spacing, word: "粉", syllable: "fan2", value: "35", name: "陰上", jyutping: "2")
                                IOSToneLabel(spacing: spacing, word: "訓", syllable: "fan3", value: "33", name: "陰去", jyutping: "3")
                                IOSToneLabel(spacing: spacing, word: "焚", syllable: "fan4", value: "21/11", name: "陽平", jyutping: "4")
                                IOSToneLabel(spacing: spacing, word: "奮", syllable: "fan5", value: "13/23", name: "陽上", jyutping: "5")
                                IOSToneLabel(spacing: spacing, word: "份", syllable: "fan6", value: "22", name: "陽去", jyutping: "6")
                                IOSToneLabel(spacing: spacing, word: "忽", syllable: "fat1", value: "5", name: "高陰入", jyutping: "1")
                                IOSToneLabel(spacing: spacing, word: "法", syllable: "faat3", value: "3", name: "低陰入", jyutping: "3")
                                IOSToneLabel(spacing: spacing, word: "罰", syllable: "fat6", value: "2", name: "陽入", jyutping: "6")      
                        } header: {
                                HStack(spacing: spacing) {
                                        HStack(spacing: 2) {
                                                ZStack(alignment: .leading) {
                                                        Text(verbatim: "法 faat3").font(.body).hidden()
                                                        Text(verbatim: "例字")
                                                }
                                                Speaker().hidden()
                                        }
                                        ZStack(alignment: .leading) {
                                                Text(verbatim: "55/53").font(.body).hidden()
                                                Text(verbatim: "調值")
                                        }
                                        ZStack(alignment: .leading) {
                                                Text(verbatim: "高陰入").font(.body).hidden()
                                                Text(verbatim: "聲調")
                                        }
                                        Text(verbatim: "粵拼")
                                }
                                .textCase(nil)
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

private struct IOSToneLabel: View {

        let spacing: CGFloat
        let word: String
        let syllable: String
        let value: String
        let name: String
        let jyutping: String

        var body: some View {
                HStack(spacing: spacing) {
                        HStack(spacing: 2) {
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
