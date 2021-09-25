import SwiftUI

private struct CellView: View {

        init(_ content: String) {
                self.content = content
                let parts: [String] = content.components(separatedBy: ",")
                self.components = parts
                self.width = {
                        if UITraitCollection.current.userInterfaceIdiom == .phone {
                                return (UIScreen.main.bounds.width - 32) / CGFloat(parts.count)
                        } else {
                                return 120
                        }
                }()
        }

        private let content: String
        private let components: [String]
        private let width: CGFloat

        var body: some View {
                if #available(iOS 15.0, *) {
                        HStack {
                                Text(components[0]).frame(minWidth: 50, idealWidth: width, maxWidth: width, alignment: .leading)
                                Text(components[1]).frame(minWidth: 50, idealWidth: width, maxWidth: width, alignment: .leading)
                                if components.count < 4 {
                                        Text(components[2])
                                } else {
                                        Text(components[2]).frame(minWidth: 50, idealWidth: width, maxWidth: width, alignment: .leading)
                                        Text(components[3])
                                }
                                Spacer()
                        }
                        .font(.system(.body, design: .monospaced))
                        .textSelection(.enabled)
                } else {
                        HStack {
                                Text(components[0]).frame(minWidth: 50, idealWidth: width, maxWidth: width, alignment: .leading)
                                Text(components[1]).frame(minWidth: 50, idealWidth: width, maxWidth: width, alignment: .leading)
                                if components.count < 4 {
                                        Text(components[2])
                                } else {
                                        Text(components[2]).frame(minWidth: 50, idealWidth: width, maxWidth: width, alignment: .leading)
                                        Text(components[3])
                                }
                                Spacer()
                        }
                        .font(.system(.body, design: .monospaced))
                }
        }
}


struct InitialsTable: View {
        var body: some View {
                List(content.components(separatedBy: .newlines), id: \.self) {
                        CellView($0)
                }
                .navigationBarTitle("Jyutping Initials", displayMode: .inline)
        }

private let content: String = """
例字,IPA,粵拼
巴 baa1,[p],b
趴 paa1,[pʰ],p
媽 maa1,[m],m
花 faa1,[f],f
打 daa2,[t],d
他 taa1,[tʰ],t
拿 naa4,[n],n
啦 laa1,[l],l
家 gaa1,[k],g
卡 kaa1,[kʰ],k
牙 ngaa4,[ŋ],ng
蝦 haa1,[h],h
瓜 gwaa1,[kʷ],gw
夸 kwaa1,[kʷʰ],kw
娃 waa1,[w],w
渣 zaa1,t͡s~t͡ʃ,z
叉 caa1,t͡sʰ~t͡ʃʰ,c
沙 saa1,s~ʃ,s
也 jaa5,[j],j
"""
}


struct FinalsTable: View {
        var body: some View {
                List {
                        ForEach(parts, id: \.self) { block in
                                Section {
                                        ForEach(block.components(separatedBy: .newlines), id: \.self) {
                                                CellView($0)
                                        }
                                }
                        }
                }
                .navigationBarTitle("Jyutping Finals", displayMode: .inline)
        }

        private let parts: [String] = {

let content: String = """
例字,IPA,粵拼
渣 zaa1,[aː],aa
齋 zaai1,[aːi],aai
嘲 zaau1,[aːu],aau
站 zaam6,[aːm],aam
讚 zaan3,[aːn],aan
爭 zaang1,[aːŋ],aang
雜 zaap6,[aːp̚],aap
扎 zaat3,[aːt̚],aat
責 zaak3,[aːk̚],aak
.
嘞 la3,[ɐ],a
擠 zai1,[ɐi],ai
周 zau1,[ɐu],au
針 zam1,[ɐm],am
真 zan1,[ɐn],an
增 zang1,[ɐŋ],ang
汁 zap1,[ɐp̚],ap
質 zat1,[ɐt̚],at
則 zak1,[ɐk̚],ak
.
遮 ze1,[ɛː],e
悲 bei1,[ei],ei
掉 deu6,[ɛːu],eu
𦧷 lem2,[ɛːm],em
？,[en],en
鄭 zeng6,[ɛːŋ],eng
夾 gep6,[ɛːp̚],ep
坺 pet6,[ɛːt̚],et
隻 zek3,[ɛːk̚],ek
.
之 zi1,[iː],i
招 ziu1,[iːu],iu
尖 zim1,[iːm],im
煎 zin1,[iːn],in
晶 zing1,[eŋ],ing
接 zip3,[iːp̚],ip
節 zit3,[iːt̚],it
即 zik1,[ek̚],ik
.
左 zo2,[ɔː],o
栽 zoi1,[ɔːi],oi
租 zou1,[ou],ou
肝 gon1,[ɔːn],on
裝 zong1,[ɔːŋ],ong
喝 hot3,[ɔːt̚],ot
作 zok3,[ɔːk̚],ok
.
夫 fu1,[uː],u
灰 fui1,[uːi],ui
寬 fun1,[uːn],un
封 fung1,[oŋ],ung
闊 fut3,[uːt̚],ut
福 fuk1,[ok̚],uk
.
靴 hoe1,[œː],oe
香 hoeng1,[œːŋ],oeng
？,[œːt̚],oet
腳 goek3,[œːk̚],oek
.
追 zeoi1,[ɵy],eoi
津 zeon1,[ɵn],eon
卒 zeot1,[ɵt̚],eot
.
書 syu1,[yː],yu
酸 syun1,[yːn],yun
雪 syut3,[yːt̚],yut
.
唔 m4,[m̩],m
五 ng5,[ŋ̩],ng
"""

                return content.components(separatedBy: ".").map({ $0.trimmingCharacters(in: .newlines)})
}()

}


struct TonesTable: View {
        var body: some View {
                List(content.components(separatedBy: .newlines), id: \.self) {
                        CellView($0)
                }
                .navigationBarTitle("Jyutping Tones", displayMode: .inline)
        }

private let content: String = """
例字,調值,聲調,粵拼
分 fan1,55/53,陰平,1
粉 fan2,35,陰上,2
訓 fan3,33,陰去,3
焚 fan4,11/21,陽平,4
奮 fan5,23,陽上,5
份 fan6,22,陽去,6
忽 fat1,5,高陰入,1
法 faat3,3,低陰入,3
佛 fat6,2,陽入,6
"""
}

