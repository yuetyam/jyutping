import SwiftUI

struct InitialTable: View {

        #if os(iOS)
        @Environment(\.horizontalSizeClass) var horizontalSize
        #endif

        var body: some View {
                let dataLines: [String] = sourceText.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines).map({ $0.trimmingCharacters(in: .whitespaces) })
                #if os(macOS)
                ScrollView {
                        LazyVStack(spacing: 16) {
                                VStack {
                                        ForEach(0..<dataLines.count, id: \.self) { index in
                                                MacSyllableCell(dataLines[index])
                                        }
                                }
                                .block()
                                MacFootnoteView(text: footnote1)
                                MacFootnoteView(text: footnote2)
                                MacFootnoteView(text: footnote3)
                        }
                        .padding()
                }
                .navigationTitle("MacSidebar.NavigationTitle.JyutpingInitials")
                #else
                let spacing: CGFloat = (horizontalSize == .compact) ? 24 : 32
                List {
                        Section {
                                ForEach(0..<dataLines.count, id: \.self) { index in
                                        IOSSyllableCell(dataLines[index], spacing: spacing)
                                }
                        }
                        Section {
                                Text(verbatim: footnote1)
                                        .font(.copilot)
                                        .textSelection(.enabled)
                        } header: {
                                Text(verbatim: "註：").textCase(nil)
                        }
                        Section {
                                Text(verbatim: footnote2)
                                        .font(.copilot)
                                        .textSelection(.enabled)
                        } header: {
                                Text(verbatim: "註：").textCase(nil)
                        }
                        Section {
                                Text(verbatim: footnote3)
                                        .font(.copilot)
                                        .textSelection(.enabled)
                        } header: {
                                Text(verbatim: "註：").textCase(nil)
                        }
                }
                .navigationTitle("IOSJyutpingTab.NavigationTitle.JyutpingInitials")
                .navigationBarTitleDisplayMode(.inline)
                #endif
        }

private let sourceText: String = """
例字,國際音標,粵拼
巴 baa1,[ p ],b
趴 paa1,[ pʰ ],p
媽 maa1,[ m ],m
花 faa1,[ f ],f
打 daa2,[ t ],d
他 taa1,[ tʰ ],t
拿 naa4,[ n ],n
啦 laa1,[ l ],l
家 gaa1,[ k ],g
卡 kaa1,[ kʰ ],k
牙 ngaa4,[ ŋ ],ng
蝦 haa1,[ h ],h
瓜 gwaa1,[ kʷ ],gw
夸 kwaa1,[ kʷʰ ],kw
娃 waa1,[ w ],w
渣 zaa1,t͡s~t͡ʃ,z
叉 caa1,t͡sʰ~t͡ʃʰ,c
沙 saa1,s~ʃ,s
也 jaa5,[ j ],j
"""

private let footnote1: String = """
零聲母無標記。
"""

private let footnote2: String = """
粵語聲母 h 與普通話聲母 h 有區別。粵語 h 係喉音 [ h ]，與英語 h 類似；而普通話 h 通常係舌根音 [ x ]。
"""

private let footnote3: String = """
粵拼毋區分平翹舌，但現實中粵語人羣存在較爲複雜、混亂嘅平翹發音情況。
"""

}

#if os(macOS)
private struct MacFootnoteView: View {
        let text: String
        var body: some View {
                HStack(spacing: 1) {
                        Text(verbatim: "註")
                                .textSelection(.enabled)
                        Text.separator
                                .textSelection(.disabled)
                        Text(verbatim: text)
                                .textSelection(.enabled)
                        Spacer()
                }
                .font(.copilot)
                .block()
        }
}
#endif
