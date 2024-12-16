#if os(iOS)

import SwiftUI

struct IOSJyutpingFinalTable: View {
        var body: some View {
                List {
                        Section {
                                IOSFinalLabel(word: "駕", syllable: "gaa3", jyutping: "aa", ipa: "[ aː ]")
                                IOSFinalLabel(word: "界", syllable: "gaai3", jyutping: "aai", ipa: "[ aːi ]")
                                IOSFinalLabel(word: "教", syllable: "gaau3", jyutping: "aau", ipa: "[ aːu ]")
                                IOSFinalLabel(word: "鑑", syllable: "gaam3", jyutping: "aam", ipa: "[ aːm ]")
                                IOSFinalLabel(word: "諫", syllable: "gaan3", jyutping: "aan", ipa: "[ aːn ]")
                                IOSFinalLabel(word: "耕", syllable: "gaang1", jyutping: "aang", ipa: "[ aːŋ ]")
                                IOSFinalLabel(word: "甲", syllable: "gaap3", jyutping: "aap", ipa: "[ aːp̚ ]")
                                IOSFinalLabel(word: "戛", syllable: "gaat3", jyutping: "aat", ipa: "[ aːt̚ ]")
                                IOSFinalLabel(word: "格", syllable: "gaak3", jyutping: "aak", ipa: "[ aːk̚ ]")
                        } header: {
                                HStack(spacing: 28) {
                                        HStack(spacing: 0) {
                                                ZStack(alignment: .leading) {
                                                        Text(verbatim: "佔 gaang4").font(.body).hidden()
                                                        Text(verbatim: "例字")
                                                }
                                                Speaker().hidden()
                                        }
                                        ZStack(alignment: .leading) {
                                                Text(verbatim: "gaang").font(.body).hidden()
                                                Text(verbatim: "韻母")
                                        }
                                        Text(verbatim: "國際音標")
                                        Spacer()
                                }
                                .textCase(nil)
                        }
                        Section {
                                IOSFinalLabel(word: "㗎", syllable: "ga3", pronunciation: "kɐ˧", jyutping: "a", ipa: "[ ɐ ]")
                                IOSFinalLabel(word: "計", syllable: "gai3", jyutping: "ai", ipa: "[ ɐi ]")
                                IOSFinalLabel(word: "救", syllable: "gau3", jyutping: "au", ipa: "[ ɐu ]")
                                IOSFinalLabel(word: "禁", syllable: "gam3", jyutping: "am", ipa: "[ ɐm ]")
                                IOSFinalLabel(word: "斤", syllable: "gan1", jyutping: "an", ipa: "[ ɐn ]")
                                IOSFinalLabel(word: "庚", syllable: "gang1", jyutping: "ang", ipa: "[ ɐŋ ]")
                                IOSFinalLabel(word: "急", syllable: "gap1", jyutping: "ap", ipa: "[ ɐp̚ ]")
                                IOSFinalLabel(word: "吉", syllable: "gat1", jyutping: "at", ipa: "[ ɐt̚ ]")
                                IOSFinalLabel(word: "北", syllable: "bak1", jyutping: "ak", ipa: "[ ɐk̚ ]")
                        }
                        Section {
                                IOSFinalLabel(word: "嘅", syllable: "ge3", jyutping: "e", ipa: "[ ɛː ]")
                                IOSFinalLabel(word: "記", syllable: "gei3", jyutping: "ei", ipa: "[ ei ]")
                                IOSFinalLabel(word: "掉", syllable: "deu6", jyutping: "eu", ipa: "[ ɛːu ]")
                                IOSFinalLabel(word: "𦧷", syllable: "lem2", jyutping: "em", ipa: "[ ɛːm ]")
                                IOSFinalLabel(word: "鏡", syllable: "geng3", jyutping: "eng", ipa: "[ ɛːŋ ]")
                                IOSFinalLabel(word: "夾", syllable: "gep6", jyutping: "ep", ipa: "[ ɛːp̚ ]")
                                IOSFinalLabel(word: "坺", syllable: "pet6", pronunciation: "pʰɛːt̚˨", jyutping: "et", ipa: "[ ɛːt̚ ]")
                                IOSFinalLabel(word: "踢", syllable: "tek3", jyutping: "ek", ipa: "[ ɛːk̚ ]")
                        } footer: {
                                Text(verbatim: "韻母 -eu, -em, -ep, -et 通常只見於口語白讀。韻母 -ing/-eng, -ik/-ek 部分字音係文白異讀關係。").textCase(nil)
                        }
                        Section {
                                IOSFinalLabel(word: "意", syllable: "ji3", jyutping: "i", ipa: "[ iː ]")
                                IOSFinalLabel(word: "叫", syllable: "giu3", jyutping: "iu", ipa: "[ iːu ]")
                                IOSFinalLabel(word: "劍", syllable: "gim3", jyutping: "im", ipa: "[ iːm ]")
                                IOSFinalLabel(word: "見", syllable: "gin3", jyutping: "in", ipa: "[ iːn ]")
                                IOSFinalLabel(word: "敬", syllable: "ging3", jyutping: "ing", ipa: "[ eŋ ]")
                                IOSFinalLabel(word: "劫", syllable: "gip3", jyutping: "ip", ipa: "[ iːp̚ ]")
                                IOSFinalLabel(word: "結", syllable: "git3", jyutping: "it", ipa: "[ iːt̚ ]")
                                IOSFinalLabel(word: "極", syllable: "gik6", jyutping: "ik", ipa: "[ ek̚ ]")
                        }
                        Section {
                                IOSFinalLabel(word: "個", syllable: "go3", jyutping: "o", ipa: "[ ɔː ]")
                                IOSFinalLabel(word: "蓋", syllable: "goi3", jyutping: "oi", ipa: "[ ɔːi ]")
                                IOSFinalLabel(word: "告", syllable: "gou3", jyutping: "ou", ipa: "[ ou ]")
                                IOSFinalLabel(word: "幹", syllable: "gon3", jyutping: "on", ipa: "[ ɔːn ]")
                                IOSFinalLabel(word: "鋼", syllable: "gong3", jyutping: "ong", ipa: "[ ɔːŋ ]")
                                IOSFinalLabel(word: "割", syllable: "got3", jyutping: "ot", ipa: "[ ɔːt̚ ]")
                                IOSFinalLabel(word: "各", syllable: "gok3", jyutping: "ok", ipa: "[ ɔːk̚ ]")
                        }
                        Section {
                                IOSFinalLabel(word: "夫", syllable: "fu1", jyutping: "u", ipa: "[ uː ]")
                                IOSFinalLabel(word: "灰", syllable: "fui1", jyutping: "ui", ipa: "[ uːi ]")
                                IOSFinalLabel(word: "寬", syllable: "fun1", jyutping: "un", ipa: "[ uːn ]")
                                IOSFinalLabel(word: "封", syllable: "fung1", jyutping: "ung", ipa: "[ oŋ ]")
                                IOSFinalLabel(word: "闊", syllable: "fut3", jyutping: "ut", ipa: "[ uːt̚ ]")
                                IOSFinalLabel(word: "福", syllable: "fuk1", jyutping: "uk", ipa: "[ ok̚ ]")
                        }
                        Section {
                                IOSFinalLabel(word: "鋸", syllable: "goe3", jyutping: "oe", ipa: "[ œː ]")
                                IOSFinalLabel(word: "姜", syllable: "goeng1", jyutping: "oeng", ipa: "[ œːŋ ]")
                                IOSFinalLabel(word: "*", syllable: "goet4", pronunciation: "kœːt̚˨˩", jyutping: "oet", ipa: "[ œːt̚ ]")
                                IOSFinalLabel(word: "腳", syllable: "goek3", jyutping: "oek", ipa: "[ œːk̚ ]")
                        } footer: {
                                Text(verbatim: "韻母 -oet 通常只見於口語擬聲詞。").textCase(nil)
                        }
                        Section {
                                IOSFinalLabel(word: "歲", syllable: "seoi3", jyutping: "eoi", ipa: "[ ɵy ]")
                                IOSFinalLabel(word: "信", syllable: "seon3", jyutping: "eon", ipa: "[ ɵn ]")
                                IOSFinalLabel(word: "術", syllable: "seot6", jyutping: "eot", ipa: "[ ɵt̚ ]")
                        } footer: {
                                Text(verbatim: "韻腹 -oe-、-eo- 通常係音節互補關係，打字時可以混用。").textCase(nil)
                        }
                        Section {
                                IOSFinalLabel(word: "恕", syllable: "syu3", jyutping: "yu", ipa: "[ yː ]")
                                IOSFinalLabel(word: "算", syllable: "syun3", jyutping: "yun", ipa: "[ yːn ]")
                                IOSFinalLabel(word: "雪", syllable: "syut3", jyutping: "yut", ipa: "[ yːt̚ ]")
                        }
                        Section {
                                IOSFinalLabel(word: "毋", syllable: "m4", jyutping: "m", ipa: "[ \u{6D}\u{329} ]") // { m̩ }
                                IOSFinalLabel(word: "吳", syllable: "ng4", jyutping: "ng", ipa: "[ \u{14B}\u{329} ]") // { ŋ̩ }
                        } header: {
                                Text(verbatim: "鼻音單獨成韻").textCase(nil)
                        }
                }
                .navigationTitle("IOSJyutpingTab.NavigationTitle.JyutpingFinals")
                .navigationBarTitleDisplayMode(.inline)
        }
}

private struct IOSFinalLabel: View {

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
                HStack(spacing: 28) {
                        HStack(spacing: 0) {
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
        }
}

#endif
