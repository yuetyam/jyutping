#if os(macOS)

import SwiftUI

struct MacJyutpingInitialTable: View {
        var body: some View {
                ScrollView {
                        LazyVStack(spacing: 12) {
                                VStack(spacing: 2) {
                                        HStack(spacing: 44) {
                                                HStack {
                                                        ZStack(alignment: .leading) {
                                                                Text(verbatim: "牙 ngaa4").hidden()
                                                                Text(verbatim: "例字")
                                                        }
                                                        Speaker().hidden()
                                                }
                                                Text(verbatim: "聲母")
                                                Text(verbatim: "國際音標")
                                                Spacer()
                                        }
                                        .font(.master)
                                        .padding(.horizontal, 8)
                                        VStack {
                                                MacInitialLabel(word: "巴", syllable: "baa1", jyutping: "b", ipa: "[ p ]")
                                                MacInitialLabel(word: "趴", syllable: "paa1", jyutping: "p", ipa: "[ pʰ ]")
                                                MacInitialLabel(word: "媽", syllable: "maa1", jyutping: "m", ipa: "[ m ]")
                                                MacInitialLabel(word: "花", syllable: "faa1", jyutping: "f", ipa: "[ f ]")
                                        }
                                        .block()
                                }
                                VStack {
                                        MacInitialLabel(word: "打", syllable: "daa2", jyutping: "d", ipa: "[ t ]")
                                        MacInitialLabel(word: "他", syllable: "taa1", jyutping: "t", ipa: "[ tʰ ]")
                                        MacInitialLabel(word: "拿", syllable: "naa4", jyutping: "n", ipa: "[ n ]")
                                        MacInitialLabel(word: "啦", syllable: "laa1", jyutping: "l", ipa: "[ l ]")
                                }
                                .block()
                                VStack(alignment: .leading, spacing: 2) {
                                        VStack {
                                                MacInitialLabel(word: "家", syllable: "gaa1", jyutping: "g", ipa: "[ k ]")
                                                MacInitialLabel(word: "卡", syllable: "kaa1", jyutping: "k", ipa: "[ kʰ ]")
                                                MacInitialLabel(word: "蝦", syllable: "haa1", jyutping: "h", ipa: "[ h ]")
                                        }
                                        .block()
                                        Text(verbatim: "聲母 h 與普通話聲母 h 有區別。粵語 h 係喉音 [ h ]，與英語 h 類似；而普通話 h 通常係舌根音 [ x ]。")
                                                .font(.copilot)
                                                .foregroundStyle(Color.secondary)
                                                .padding(.horizontal, 8)
                                }
                                VStack(alignment: .leading, spacing: 2) {
                                        MacInitialLabel(word: "牙", syllable: "ngaa4", jyutping: "ng", ipa: "[ ŋ ]").block()
                                        Text(verbatim: "聲母 ng 又稱「疑母」，零聲母又稱「影母」。現實中常有疑影不分，例如【我 ngo5】讀成 o5；【愛 oi3】讀成 ngoi3。理論上可依照聲調區分疑影，1、2、3 調通常搭配零聲母；4、5、6 調通常搭配疑母。")
                                                .font(.copilot)
                                                .foregroundStyle(Color.secondary)
                                                .padding(.horizontal, 8)
                                }
                                VStack {
                                        MacInitialLabel(word: "瓜", syllable: "gwaa1", jyutping: "gw", ipa: "[ kʷ ]")
                                        MacInitialLabel(word: "夸", syllable: "kwaa1", jyutping: "kw", ipa: "[ kʷʰ ]")
                                }
                                .block()
                                VStack(alignment: .leading, spacing: 2) {
                                        VStack {
                                                MacInitialLabel(word: "渣", syllable: "zaa1", jyutping: "z", ipa: "t͡s ~ t͡ʃ")
                                                MacInitialLabel(word: "叉", syllable: "caa1", jyutping: "c", ipa: "t͡sʰ ~ t͡ʃʰ")
                                                MacInitialLabel(word: "沙", syllable: "saa1", jyutping: "s", ipa: "s ~ ʃ")
                                        }
                                        .block()
                                        Text(verbatim: "粵拼毋區分平翹舌，現實中粵語人羣存在較爲複雜、混亂嘅舌尖／舌葉音發音情況。")
                                                .font(.copilot)
                                                .foregroundStyle(Color.secondary)
                                                .padding(.horizontal, 8)
                                }
                                VStack(alignment: .leading, spacing: 2) {
                                        VStack {
                                                MacInitialLabel(word: "蛙", syllable: "waa1", jyutping: "w", ipa: "[ w ]")
                                                MacInitialLabel(word: "也", syllable: "jaa5", jyutping: "j", ipa: "[ j ]")
                                        }
                                        .block()
                                        Text(verbatim: "聲母 j 相當於其他拼音方案嘅聲母 y。粵拼輸入法兼容 y。 ")
                                                .font(.copilot)
                                                .foregroundStyle(Color.secondary)
                                                .padding(.horizontal, 8)
                                }
                        }
                        .textSelection(.enabled)
                        .padding()
                }
                .navigationTitle("MacSidebar.NavigationTitle.JyutpingInitials")
        }
}

private struct MacInitialLabel: View {

        let word: String
        let syllable: String
        let jyutping: String
        let ipa: String

        var body: some View {
                HStack(spacing: 44) {
                        HStack {
                                ZStack(alignment: .leading) {
                                        Text(verbatim: "牙 ngaa4").hidden()
                                        Text(verbatim: "\(word) \(syllable)")
                                }
                                Speaker(syllable)
                        }
                        ZStack {
                                Text(verbatim: "聲母").hidden()
                                Text(verbatim: jyutping).font(.fixedWidth)
                        }
                        Text(verbatim: ipa).font(.body)
                        Spacer()
                }
                .font(.master)
        }
}

#endif
