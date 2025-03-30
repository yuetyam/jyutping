#if os(macOS)

import SwiftUI

struct MacJyutpingFinalTable: View {
        var body: some View {
                ScrollView {
                        LazyVStack(spacing: 12) {
                                VStack(spacing: 2) {
                                        HStack(spacing: 44) {
                                                HStack {
                                                        ZStack(alignment: .leading) {
                                                                Text(verbatim: "佔 gaang4").hidden()
                                                                Text(verbatim: "例字")
                                                        }
                                                        Speaker().hidden()
                                                }
                                                ZStack(alignment: .leading) {
                                                        Text(verbatim: "gaang").hidden()
                                                        Text(verbatim: "韻母")
                                                }
                                                Text(verbatim: "國際音標")
                                                Spacer()
                                        }
                                        .font(.master)
                                        .padding(.horizontal, 8)
                                        VStack {
                                                MacFinalLabel(word: "駕", syllable: "gaa3", jyutping: "aa", ipa: "[ aː ]")
                                                MacFinalLabel(word: "界", syllable: "gaai3", jyutping: "aai", ipa: "[ aːi ]")
                                                MacFinalLabel(word: "教", syllable: "gaau3", jyutping: "aau", ipa: "[ aːu ]")
                                                MacFinalLabel(word: "鑑", syllable: "gaam3", jyutping: "aam", ipa: "[ aːm ]")
                                                MacFinalLabel(word: "諫", syllable: "gaan3", jyutping: "aan", ipa: "[ aːn ]")
                                                MacFinalLabel(word: "耕", syllable: "gaang1", jyutping: "aang", ipa: "[ aːŋ ]")
                                                MacFinalLabel(word: "甲", syllable: "gaap3", jyutping: "aap", ipa: "[ aːp̚ ]")
                                                MacFinalLabel(word: "戛", syllable: "gaat3", jyutping: "aat", ipa: "[ aːt̚ ]")
                                                MacFinalLabel(word: "格", syllable: "gaak3", jyutping: "aak", ipa: "[ aːk̚ ]")
                                        }
                                        .block()
                                }
                                VStack {
                                        MacFinalLabel(word: "㗎", syllable: "ga3", pronunciation: "kɐ˧", jyutping: "a", ipa: "[ ɐ ]")
                                        MacFinalLabel(word: "計", syllable: "gai3", jyutping: "ai", ipa: "[ ɐi ]")
                                        MacFinalLabel(word: "救", syllable: "gau3", jyutping: "au", ipa: "[ ɐu ]")
                                        MacFinalLabel(word: "禁", syllable: "gam3", jyutping: "am", ipa: "[ ɐm ]")
                                        MacFinalLabel(word: "斤", syllable: "gan1", jyutping: "an", ipa: "[ ɐn ]")
                                        MacFinalLabel(word: "庚", syllable: "gang1", jyutping: "ang", ipa: "[ ɐŋ ]")
                                        MacFinalLabel(word: "急", syllable: "gap1", jyutping: "ap", ipa: "[ ɐp̚ ]")
                                        MacFinalLabel(word: "吉", syllable: "gat1", jyutping: "at", ipa: "[ ɐt̚ ]")
                                        MacFinalLabel(word: "北", syllable: "bak1", jyutping: "ak", ipa: "[ ɐk̚ ]")
                                }
                                .block()
                                VStack(alignment: .leading, spacing: 2) {
                                        VStack {
                                                MacFinalLabel(word: "嘅", syllable: "ge3", jyutping: "e", ipa: "[ ɛː ]")
                                                MacFinalLabel(word: "記", syllable: "gei3", jyutping: "ei", ipa: "[ ei ]")
                                                MacFinalLabel(word: "掉", syllable: "deu6", jyutping: "eu", ipa: "[ ɛːu ]")
                                                MacFinalLabel(word: "𦧷", syllable: "lem2", jyutping: "em", ipa: "[ ɛːm ]")
                                                MacFinalLabel(word: "鏡", syllable: "geng3", jyutping: "eng", ipa: "[ ɛːŋ ]")
                                                MacFinalLabel(word: "夾", syllable: "gep6", jyutping: "ep", ipa: "[ ɛːp̚ ]")
                                                MacFinalLabel(word: "坺", syllable: "pet6", pronunciation: "pʰɛːt̚˨", jyutping: "et", ipa: "[ ɛːt̚ ]")
                                                MacFinalLabel(word: "踢", syllable: "tek3", jyutping: "ek", ipa: "[ ɛːk̚ ]")
                                        }
                                        .block()
                                        Text(verbatim: "韻母 -eu, -em, -ep, -et 通常只見於口語白讀。韻母 -ing/-eng, -ik/-ek 部分字音係文白異讀關係。")
                                                .font(.copilot)
                                                .foregroundStyle(Color.secondary)
                                                .padding(.horizontal, 8)
                                }
                                VStack {
                                        MacFinalLabel(word: "意", syllable: "ji3", jyutping: "i", ipa: "[ iː ]")
                                        MacFinalLabel(word: "叫", syllable: "giu3", jyutping: "iu", ipa: "[ iːu ]")
                                        MacFinalLabel(word: "劍", syllable: "gim3", jyutping: "im", ipa: "[ iːm ]")
                                        MacFinalLabel(word: "見", syllable: "gin3", jyutping: "in", ipa: "[ iːn ]")
                                        MacFinalLabel(word: "敬", syllable: "ging3", jyutping: "ing", ipa: "[ eŋ ]")
                                        MacFinalLabel(word: "劫", syllable: "gip3", jyutping: "ip", ipa: "[ iːp̚ ]")
                                        MacFinalLabel(word: "結", syllable: "git3", jyutping: "it", ipa: "[ iːt̚ ]")
                                        MacFinalLabel(word: "極", syllable: "gik6", jyutping: "ik", ipa: "[ ek̚ ]")
                                }
                                .block()
                                VStack {
                                        MacFinalLabel(word: "個", syllable: "go3", jyutping: "o", ipa: "[ ɔː ]")
                                        MacFinalLabel(word: "蓋", syllable: "goi3", jyutping: "oi", ipa: "[ ɔːi ]")
                                        MacFinalLabel(word: "告", syllable: "gou3", jyutping: "ou", ipa: "[ ou ]")
                                        MacFinalLabel(word: "幹", syllable: "gon3", jyutping: "on", ipa: "[ ɔːn ]")
                                        MacFinalLabel(word: "鋼", syllable: "gong3", jyutping: "ong", ipa: "[ ɔːŋ ]")
                                        MacFinalLabel(word: "割", syllable: "got3", jyutping: "ot", ipa: "[ ɔːt̚ ]")
                                        MacFinalLabel(word: "各", syllable: "gok3", jyutping: "ok", ipa: "[ ɔːk̚ ]")
                                }
                                .block()
                                VStack {
                                        MacFinalLabel(word: "夫", syllable: "fu1", jyutping: "u", ipa: "[ uː ]")
                                        MacFinalLabel(word: "灰", syllable: "fui1", jyutping: "ui", ipa: "[ uːi ]")
                                        MacFinalLabel(word: "寬", syllable: "fun1", jyutping: "un", ipa: "[ uːn ]")
                                        MacFinalLabel(word: "封", syllable: "fung1", jyutping: "ung", ipa: "[ oŋ ]")
                                        MacFinalLabel(word: "闊", syllable: "fut3", jyutping: "ut", ipa: "[ uːt̚ ]")
                                        MacFinalLabel(word: "福", syllable: "fuk1", jyutping: "uk", ipa: "[ ok̚ ]")
                                }
                                .block()
                                VStack(alignment: .leading, spacing: 2) {
                                        VStack {
                                                MacFinalLabel(word: "鋸", syllable: "goe3", jyutping: "oe", ipa: "[ œː ]")
                                                MacFinalLabel(word: "姜", syllable: "goeng1", jyutping: "oeng", ipa: "[ œːŋ ]")
                                                MacFinalLabel(word: "*", syllable: "goet4", pronunciation: "kœːt̚˨˩", jyutping: "oet", ipa: "[ œːt̚ ]")
                                                MacFinalLabel(word: "腳", syllable: "goek3", jyutping: "oek", ipa: "[ œːk̚ ]")
                                        }
                                        .block()
                                        Text(verbatim: "韻母 -oet 通常只見於口語擬聲詞。")
                                                .font(.copilot)
                                                .foregroundStyle(Color.secondary)
                                                .padding(.horizontal, 8)
                                }
                                VStack(alignment: .leading, spacing: 2) {
                                        VStack {
                                                MacFinalLabel(word: "歲", syllable: "seoi3", jyutping: "eoi", ipa: "[ ɵy ]")
                                                MacFinalLabel(word: "信", syllable: "seon3", jyutping: "eon", ipa: "[ ɵn ]")
                                                MacFinalLabel(word: "術", syllable: "seot6", jyutping: "eot", ipa: "[ ɵt̚ ]")
                                        }
                                        .block()
                                        Text(verbatim: "韻腹 -oe-, -eo- 通常係音節互補關係，打字時可以混用。")
                                                .font(.copilot)
                                                .foregroundStyle(Color.secondary)
                                                .padding(.horizontal, 8)
                                }
                                VStack {
                                        MacFinalLabel(word: "恕", syllable: "syu3", jyutping: "yu", ipa: "[ yː ]")
                                        MacFinalLabel(word: "算", syllable: "syun3", jyutping: "yun", ipa: "[ yːn ]")
                                        MacFinalLabel(word: "雪", syllable: "syut3", jyutping: "yut", ipa: "[ yːt̚ ]")
                                }
                                .block()
                                VStack(alignment: .leading, spacing: 2) {
                                        Text(verbatim: "鼻音單獨成韻")
                                                .font(.copilot)
                                                .foregroundStyle(Color.secondary)
                                                .padding(.horizontal, 8)
                                        VStack {
                                                MacFinalLabel(word: "唔", syllable: "m4", jyutping: "m", ipa: "[ \u{6D}\u{329} ]") // { m̩ }
                                                MacFinalLabel(word: "吳", syllable: "ng4", jyutping: "ng", ipa: "[ \u{14B}\u{329} ]") // { ŋ̩ }
                                        }
                                        .block()
                                }
                        }
                        .textSelection(.enabled)
                        .padding()
                }
                .navigationTitle("MacSidebar.NavigationTitle.JyutpingFinals")
        }
}

private struct MacFinalLabel: View {

        init(word: String, syllable: String, pronunciation: String? = nil, jyutping: String, ipa: String) {
                self.word = word
                self.syllable = syllable
                self.pronunciation = pronunciation
                self.jyutping = jyutping
                self.ipa = ipa
        }

        private let word: String
        private let syllable: String
        private let pronunciation: String?
        private let jyutping: String
        private let ipa: String

        var body: some View {
                HStack(spacing: 44) {
                        HStack {
                                ZStack(alignment: .leading) {
                                        Text(verbatim: "佔 gaang4").hidden()
                                        Text(verbatim: "\(word) \(syllable)")
                                }
                                Speaker {
                                        if let pronunciation {
                                                Speech.speak(text: word, ipa: pronunciation)
                                        } else {
                                                Speech.speak(syllable)
                                        }
                                }
                        }
                        ZStack(alignment: .leading) {
                                Text(verbatim: "gaang").hidden()
                                Text(verbatim: jyutping).font(.fixedWidth)
                        }
                        Text(verbatim: ipa)
                        Spacer()
                }
                .font(.master)
        }
}

#endif
