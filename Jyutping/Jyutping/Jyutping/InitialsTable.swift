import SwiftUI

struct InitialsTable: View {

        @Environment(\.horizontalSizeClass) var horizontalSize
        private let isPad: Bool = UITraitCollection.current.userInterfaceIdiom == .pad
        private let offset: CGFloat = {
                if #available(iOS 14.0, *) {
                        return 64
                } else {
                        return 32
                }
        }()
        private var width: CGFloat {
                guard isPad else {
                        return (UIScreen.main.bounds.width - offset) / 3.0
                }
                if horizontalSize == .compact {
                        return 90
                } else {
                        return 120
                }
        }

        var body: some View {
                if #available(iOS 15.0, *) {
                        List(dataSource.components(separatedBy: .newlines), id: \.self) {
                                SyllableCell($0, width: width)
                        }
                        .font(.body.monospaced())
                        .textSelection(.enabled)
                        .navigationTitle("Jyutping Initials")
                        .navigationBarTitleDisplayMode(.inline)

                } else if #available(iOS 14.0, *) {
                        List(dataSource.components(separatedBy: .newlines), id: \.self) {
                                SyllableCell($0, width: width)
                        }
                        .font(.system(.body, design: .monospaced))
                        .listStyle(.insetGrouped)
                        .navigationTitle("Jyutping Initials")
                        .navigationBarTitleDisplayMode(.inline)

                } else {
                        List(dataSource.components(separatedBy: .newlines), id: \.self) {
                                SyllableCell($0, width: width)
                        }
                        .font(.system(.body, design: .monospaced))
                        .listStyle(.grouped)
                        .navigationBarTitle("Jyutping Initials", displayMode: .inline)
                }
        }


private let dataSource: String = """
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


struct InitialsTable_Previews: PreviewProvider {
        static var previews: some View {
                InitialsTable()
        }
}
