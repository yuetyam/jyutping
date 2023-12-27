import SwiftUI

struct InitialTable: View {

        #if os(iOS)
        @Environment(\.horizontalSizeClass) var horizontalSize
        #endif

        private let footnote: String = "註：零聲母無標記"

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
                                HStack {
                                        Text(verbatim: footnote).font(.copilot).textSelection(.enabled)
                                        Spacer()
                                }
                                .block()
                        }
                        .padding()
                }
                .navigationTitle("Jyutping Initials")
                #else
                let spacing: CGFloat = (horizontalSize == .compact) ? 24 : 32
                List {
                        Section {
                                ForEach(0..<dataLines.count, id: \.self) { index in
                                        IOSSyllableCell(dataLines[index], spacing: spacing)
                                }
                        }
                        Section {
                                Text(verbatim: footnote)
                        }
                }
                .navigationTitle("Jyutping Initials")
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

}
