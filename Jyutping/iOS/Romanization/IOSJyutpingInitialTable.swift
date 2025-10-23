#if os(iOS)

import SwiftUI

struct IOSJyutpingInitialTable: View {

        @Environment(\.horizontalSizeClass) var horizontalSize

        var body: some View {
                List {
                        Section {
                                IOSInitialLabel(word: "巴", syllable: "baa1", jyutping: "b", ipa: "[ p ]")
                                IOSInitialLabel(word: "趴", syllable: "paa1", jyutping: "p", ipa: "[ pʰ ]")
                                IOSInitialLabel(word: "媽", syllable: "maa1", jyutping: "m", ipa: "[ m ]")
                                IOSInitialLabel(word: "花", syllable: "faa1", jyutping: "f", ipa: "[ f ]")
                        } header: {
                                HStack(spacing: 32) {
                                        HStack(spacing: 0) {
                                                ZStack(alignment: .leading) {
                                                        Text(verbatim: "牙 ngaa4").font(.body).hidden()
                                                        Text(verbatim: "例字")
                                                }
                                                Speaker().hidden()
                                        }
                                        ZStack {
                                                Text(verbatim: "聲母").font(.body).hidden()
                                                Text(verbatim: "聲母")
                                        }
                                        Text(verbatim: "國際音標")
                                        Spacer()
                                }
                                .textCase(nil)
                        }
                        Section {
                                IOSInitialLabel(word: "打", syllable: "daa2", jyutping: "d", ipa: "[ t ]")
                                IOSInitialLabel(word: "他", syllable: "taa1", jyutping: "t", ipa: "[ tʰ ]")
                                IOSInitialLabel(word: "拿", syllable: "naa4", jyutping: "n", ipa: "[ n ]")
                                IOSInitialLabel(word: "啦", syllable: "laa1", jyutping: "l", ipa: "[ l ]")
                        }
                        Section {
                                IOSInitialLabel(word: "家", syllable: "gaa1", jyutping: "g", ipa: "[ k ]")
                                IOSInitialLabel(word: "卡", syllable: "kaa1", jyutping: "k", ipa: "[ kʰ ]")
                                IOSInitialLabel(word: "蝦", syllable: "haa1", jyutping: "h", ipa: "[ h ]")
                        } footer: {
                                Text(verbatim: "聲母 h 與普通話聲母 h 有區別。粵語 h 係喉音 [ h ]，與英語 h 類似；而普通話 h 通常係舌根音 [ x ]。").textCase(nil)
                        }
                        Section {
                                IOSInitialLabel(word: "牙", syllable: "ngaa4", jyutping: "ng", ipa: "[ ŋ ]")
                        } footer: {
                                Text(verbatim: "聲母 ng 又稱「疑母」，零聲母又稱「影母」。現實中常有疑影不分，例如【我 ngo5】讀成 o5；【愛 oi3】讀成 ngoi3。理論上可依照聲調區分疑影，1、2、3 調通常搭配零聲母；4、5、6 調通常搭配疑母 ng。").textCase(nil)
                        }
                        Section {
                                IOSInitialLabel(word: "瓜", syllable: "gwaa1", jyutping: "gw", ipa: "[ kʷ ]")
                                IOSInitialLabel(word: "夸", syllable: "kwaa1", jyutping: "kw", ipa: "[ kʷʰ ]")
                        }
                        Section {
                                IOSInitialLabel(word: "渣", syllable: "zaa1", jyutping: "z", ipa: "t͡s~t͡ʃ")
                                IOSInitialLabel(word: "叉", syllable: "caa1", jyutping: "c", ipa: "t͡sʰ~t͡ʃʰ")
                                IOSInitialLabel(word: "沙", syllable: "saa1", jyutping: "s", ipa: "s~ʃ")
                        } footer: {
                                Text(verbatim: "粵拼不分平翹舌，現實中粵語人羣存在較爲複雜、混亂嘅舌尖／舌葉音發音情況。").textCase(nil)
                        }
                        Section {
                                IOSInitialLabel(word: "蛙", syllable: "waa1", jyutping: "w", ipa: "[ w ]")
                                IOSInitialLabel(word: "也", syllable: "jaa5", jyutping: "j", ipa: "[ j ]")
                        } footer: {
                                Text(verbatim: "聲母 j 相當於其他拼音方案嘅聲母 y。粵拼輸入法兼容 y。 ").textCase(nil)
                        }
                        if horizontalSize == .compact {
                                Section {
                                        CompactOnsetGridView()
                                }
                                .listRowBackground(Color.clear)
                                .listRowInsets(EdgeInsets(top: 32, leading: 0, bottom: 32, trailing: 0))
                        } else {
                                Section {
                                        OnsetGridView()
                                }
                                .listRowBackground(Color.clear)
                                .listRowInsets(EdgeInsets(top: 16, leading: 0, bottom: 32, trailing: 0))
                        }
                }
                .textSelection(.enabled)
                .navigationTitle("IOSJyutpingTab.NavigationTitle.JyutpingInitials")
                .navigationBarTitleDisplayMode(.inline)
        }
}

private struct IOSInitialLabel: View {

        let word: String
        let syllable: String
        let jyutping: String
        let ipa: String

        var body: some View {
                HStack(spacing: 32) {
                        HStack(spacing: 0) {
                                ZStack(alignment: .leading) {
                                        Text(verbatim: "牙 ngaa4").hidden()
                                        Text(verbatim: "\(word) \(syllable)")
                                }
                                Speaker(syllable)
                        }
                        ZStack {
                                Text(verbatim: "聲母").hidden()
                                Text(verbatim: jyutping).monospaced()
                        }
                        Text(verbatim: ipa)
                        Spacer()
                }
        }
}

#endif
