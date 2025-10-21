#if os(iOS)

import SwiftUI

struct IOSJyutpingToneTable: View {

        @Environment(\.horizontalSizeClass) var horizontalSize

        var body: some View {
                let spacing: CGFloat = (horizontalSize == .compact) ? 14 : 32
                List {
                        Section {
                                IOSToneLabel(spacing: spacing, word: "芬", syllable: "fan1", toneName: "陰平", toneValue: "55/53")
                                IOSToneLabel(spacing: spacing, word: "粉", syllable: "fan2", toneName: "陰上", toneValue: "35")
                                IOSToneLabel(spacing: spacing, word: "糞", syllable: "fan3", toneName: "陰去", toneValue: "33")
                                IOSToneLabel(spacing: spacing, word: "焚", syllable: "fan4", toneName: "陽平", toneValue: "21/11")
                                IOSToneLabel(spacing: spacing, word: "憤", syllable: "fan5", toneName: "陽上", toneValue: "13/23")
                                IOSToneLabel(spacing: spacing, word: "份", syllable: "fan6", toneName: "陽去", toneValue: "22")
                                IOSToneLabel(spacing: spacing, word: "弗", syllable: "fat1", toneName: "高陰入", toneValue: "5")
                                IOSToneLabel(spacing: spacing, word: "法", syllable: "faat3", toneName: "低陰入", toneValue: "3")
                                IOSToneLabel(spacing: spacing, word: "佛", syllable: "fat6", toneName: "陽入", toneValue: "2")
                        } header: {
                                HStack(spacing: spacing) {
                                        ZStack(alignment: .leading) {
                                                Text(verbatim: "例字").font(.body).hidden()
                                                Text(verbatim: "例字")
                                        }
                                        HStack(spacing: 0) {
                                                ZStack(alignment: .leading) {
                                                        Text(verbatim: "faat3x").font(.body).hidden()
                                                        Text(verbatim: "粵拼")
                                                }
                                                Speaker().hidden()
                                                Spacer().frame(width: 8)
                                        }
                                        ZStack(alignment: .leading) {
                                                Text(verbatim: "高陰入").font(.body).hidden()
                                                Text(verbatim: "聲調")
                                        }
                                        ZStack(alignment: .leading) {
                                                Text(verbatim: "55/53").font(.body).hidden()
                                                Text(verbatim: "調值")
                                        }
                                }
                                .textCase(nil)
                        }
                        if #available(iOS 16.0, *) {
                                Section {
                                        if horizontalSize == .compact {
                                                IOSToneCompactGridView()
                                        } else {
                                                IOSToneGridView()
                                        }
                                }
                                .listRowBackground(Color.clear)
                        }
                        Section {
                                ToneChartView()
                                        .padding(.vertical, 8)
                                        .frame(height: 234)
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
        let toneName: String
        let toneValue: String
        var body: some View {
                HStack(spacing: spacing) {
                        ZStack(alignment: .leading) {
                                Text(verbatim: "例字").hidden()
                                Text(verbatim: word)
                        }
                        HStack(spacing: 0) {
                                ZStack(alignment: .leading) {
                                        Text(verbatim: "faat3x").hidden()
                                        Text(verbatim: syllable)
                                }
                                Speaker(syllable)
                                Spacer().frame(width: 8)
                        }
                        ZStack(alignment: .leading) {
                                Text(verbatim: "高陰入").hidden()
                                Text(verbatim: toneName)
                        }
                        ZStack(alignment: .leading) {
                                Text(verbatim: "55/53").hidden()
                                Text(verbatim: toneValue)
                        }
                }
        }
}

@available(iOS 16.0, *)
private struct IOSToneCompactGridView: View {
        @Environment(\.colorScheme) private var colorScheme
        var body: some View {
                Grid(horizontalSpacing: 8, verticalSpacing: 8) {
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
                                                HStack(spacing: 2) {
                                                        Text(verbatim: "調值")
                                                        Text.separator
                                                        Text(verbatim: "˥").font(.ipa)
                                                }
                                        }
                                        Divider()
                                        VStack(alignment: .leading, spacing: 0) {
                                                HStack {
                                                        Text(verbatim: "涉 sip3")
                                                        Speaker("sip3")
                                                }
                                                HStack(spacing: 2) {
                                                        Text(verbatim: "調值")
                                                        Text.separator
                                                        Text(verbatim: "˧").font(.ipa)
                                                }
                                        }
                                }
                                .padding(4)
                                .stack(colorScheme: colorScheme)
                                .fixedSize()
                                IOSToneGridCell(character: "舌", syllable: "sit6", tone: "˨")
                        }
                }
        }
}

@available(iOS 16.0, *)
private struct IOSToneGridView: View {
        @Environment(\.colorScheme) private var colorScheme
        var body: some View {
                Grid(horizontalSpacing: 8, verticalSpacing: 8) {
                        GridRow {
                                Text(verbatim: "空").hidden()
                                Text(verbatim: "平")
                                Text(verbatim: "上")
                                Text(verbatim: "去")
                                Text(verbatim: "入")
                        }
                        GridRow {
                                Text(verbatim: "陰")
                                IOSToneGridCell(character: "詩", syllable: "si1", tone: "˥")
                                IOSToneGridCell(character: "史", syllable: "si2", tone: "˧˥")
                                IOSToneGridCell(character: "試", syllable: "si3", tone: "˧")
                                VStack(spacing: 2) {
                                        HStack {
                                                Text(verbatim: "識 sik1")
                                                Speaker("sik1")
                                                HStack(spacing: 2) {
                                                        Text(verbatim: "調值")
                                                        Text.separator
                                                        Text(verbatim: "˥").font(.ipa)
                                                }
                                        }
                                        Divider()
                                        HStack {
                                                Text(verbatim: "涉 sip3")
                                                Speaker("sip3")
                                                HStack(spacing: 2) {
                                                        Text(verbatim: "調值")
                                                        Text.separator
                                                        Text(verbatim: "˧").font(.ipa)
                                                }
                                        }
                                }
                                .padding(4)
                                .stack(colorScheme: colorScheme)
                                .fixedSize()
                        }
                        GridRow {
                                Text(verbatim: "陽")
                                IOSToneGridCell(character: "時", syllable: "si4", tone: "˨˩")
                                IOSToneGridCell(character: "市", syllable: "si5", tone: "˩˧")
                                IOSToneGridCell(character: "事", syllable: "si6", tone: "˨")
                                IOSToneGridCell(character: "舌", syllable: "sit6", tone: "˨")
                        }
                }
        }
}

private struct IOSToneGridCell: View {
        @Environment(\.colorScheme) private var colorScheme
        let character: String
        let syllable: String
        let tone: String
        var body: some View {
                VStack(alignment: .leading) {
                        HStack {
                                Text(verbatim: "\(character) \(syllable)")
                                Speaker(syllable)
                        }
                        HStack(spacing: 2) {
                                Text(verbatim: "調值")
                                Text.separator
                                Text(verbatim: tone).font(.ipa)
                        }
                }
                .padding(8)
                .stack(colorScheme: colorScheme)
        }
}

#endif
