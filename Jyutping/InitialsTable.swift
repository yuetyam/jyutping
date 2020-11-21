import SwiftUI

struct InitialsTable: View {
        
        var body: some View {
                ScrollView {
                        CellView(content: "例字,IPA,粵拼")
                                .padding(.vertical)
                        
                        ForEach(lines, id: \.self) {
                                Divider()
                                CellView(content: $0)
                        }
                        Spacer().frame(width: 1, height: 1)
                                .foregroundColor(.clear)
                                .padding(.bottom, 80)
                }
                .navigationBarTitle("Jyutping Initials", displayMode: .inline)
        }
        
        private var lines: [String] { content.components(separatedBy: "\n") }
        
        private let content: String = """
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
渣 zaa1,[t͡ʃ],z
叉 caa1,[t͡ʃʰ],c
沙 saa1,[s],s
也 jaa5,[j],j
"""
}

struct InitialsTable_Previews: PreviewProvider {
        static var previews: some View {
                InitialsTable()
        }
}

private struct CellView: View {
        
        let content: String
        private var components: [String] { content.components(separatedBy: ",") }
        
        private var exampleSize: CGFloat {
                if UITraitCollection.current.userInterfaceIdiom == .phone {
                        return (UIScreen.main.bounds.width - 32) / 3
                } else {
                        return 120
                }
        }
        
        var body: some View {
                HStack {
                        Text(components[0]).frame(minWidth: 50, idealWidth: exampleSize, maxWidth: exampleSize, alignment: .leading)
                        
                        Text(components[1]).frame(minWidth: 50, idealWidth: exampleSize, maxWidth: exampleSize, alignment: .leading)
                        
                        Text(components[2])
                        Spacer()
                }
                .font(.system(.body, design: .monospaced))
                .padding(.vertical, 5)
                .padding(.horizontal)
        }
}

struct FinalsTable: View {
        var body: some View {
                ScrollView {
                        CellView(content: "例字,IPA,粵拼")
                                .padding(.vertical)
                        
                        ForEach(lines, id: \.self) {
                                Divider()
                                CellView(content: $0)
                        }
                        Spacer().frame(width: 1, height: 1)
                                .foregroundColor(.clear)
                                .padding(.bottom, 80)
                }
                .navigationBarTitle(Text("Jyutping Finals"), displayMode: .inline)
        }
        
        private var lines: [String] { content.components(separatedBy: "\n") }
        
        private var content: String = """
渣 zaa1,[aː],aa
齋 zaai1,[aːi],aai
嘲 zaau1,[aːu],aau
站 zaam6,[aːm],aam
讚 zaan3,[aːn],aan
爭 zaang1,[aːŋ],aang
雜 zaap6,[aːp̚],aap
扎 zaat3,[aːt̚],aat
責 zaak3,[aːk̚],aak
 , ,
嘞 la3,[ɐ],a
擠 zai1,[ɐi],ai
周 zau1,[ɐu],au
針 zam1,[ɐm],am
真 zan1,[ɐn],an
增 zang1,[ɐŋ],ang
汁 zap1,[ɐp̚],ap
質 zat1,[ɐt̚],at
則 zak1,[ɐk̚],ak
 , ,
遮 ze1,[ɛː],e
悲 bei1,[ei],ei
掉 deu6,[ɛːu],eu
𦧷 lem2,[ɛːm],em
？,[en],en
鄭 zeng6,[ɛːŋ],eng
夾 gep6,[ɛːp̚],ep
坺 pet6,[ɛːt̚],et
隻 zek3,[ɛːk̚],ek
 , ,
之 zi1,[iː],i
招 ziu1,[iːu],iu
尖 zim1,[iːm],im
煎 zin1,[iːn],in
晶 zing1,[eŋ],ing
接 zip3,[iːp̚],ip
節 zit3,[iːt̚],it
即 zik1,[ek̚],ik
 , ,
左 zo2,[ɔː],o
栽 zoi1,[ɔːi],oi
租 zou1,[ou],ou
肝 gon1,[ɔːn],on
裝 zong1,[ɔːŋ],ong
喝 hot3,[ɔːt̚],ot
作 zok3,[ɔːk̚],ok
 , ,
夫 fu1,[uː],u
灰 fui1,[uːi],ui
寬 fun1,[uːn],un
封 fung1,[oŋ],ung
闊 fut3,[uːt̚],ut
福 fuk1,[ok̚],uk
 , ,
靴 hoe1,[œː],oe
香 hoeng1,[œːŋ],oeng
？,[œːt̚],oet
腳 goek3,[œːk̚],oek
 , ,
追 zeoi1,[ɵy],eoi
津 zeon1,[ɵn],eon
卒 zeot1,[ɵt̚],eot
 , ,
書 syu1,[yː],yu
酸 syun1,[yːn],yun
雪 syut3,[yːt̚],yut
 , ,
唔 m4,[m̩],m
五 ng5,[ŋ̩],ng
"""
}

struct TonesTable: View {
        var body: some View {
                ScrollView {
                        ToneCellView(content: "例字,調值,聲調,粵拼")
                                .padding(.vertical)
                        
                        ForEach(lines, id: \.self) {
                                Divider()
                                ToneCellView(content: $0)
                        }
                        Spacer().frame(width: 1, height: 1)
                                .foregroundColor(.clear)
                                .padding(.bottom, 80)
                }
                .navigationBarTitle(Text("Jyutping Tones"), displayMode: .inline)
        }
        
        private var lines: [String] { content.components(separatedBy: "\n") }
        
        private let content: String = """
分 fan1,55/53,陰平,1
粉 fan2,35,陰上,2
訓 fan3,33,陰去,3
焚 fan4,11/21,陽平,4
奮 fan5,23,陽上,5
份 fan6,22,陽去,6
忽 fat1,5,上陰入,1
法 faat3,3,下陰入,3
佛 fat6,2,陽入,6
"""
}

private struct ToneCellView: View {
        
        let content: String
        private var components: [String] { content.components(separatedBy: ",") }
        
        private var exampleSize: CGFloat {
                if UITraitCollection.current.userInterfaceIdiom == .phone {
                        return (UIScreen.main.bounds.width - 32) / 4
                } else {
                        return 120
                }
        }
        
        var body: some View {
                HStack {
                        Text(components[0]).frame(minWidth: 50, idealWidth: exampleSize, maxWidth: exampleSize, alignment: .leading)
                        
                        Text(components[1]).frame(minWidth: 50, idealWidth: exampleSize, maxWidth: exampleSize, alignment: .leading)
                        
                        Text(components[2]).frame(minWidth: 50, idealWidth: exampleSize, maxWidth: exampleSize, alignment: .leading)
                        
                        Text(components[3])
                        Spacer()
                }
                .font(.system(.body, design: .monospaced))
                .padding(.vertical, 5)
                .padding(.horizontal)
        }
}
