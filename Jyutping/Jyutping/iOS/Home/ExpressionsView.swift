#if os(iOS)

import SwiftUI

struct ExpressionsView: View {
        var body: some View {
                List {
                        Group {
                                Section {
                                        Text(verbatim: "第二人稱代詞").font(.significant)

                                        Label {
                                                Text(verbatim: "單數：你")
                                        } icon: {
                                                Image.checkmark.foregroundColor(.green)
                                        }
                                        Label {
                                                Text(verbatim: "複數：你哋／你等")
                                        } icon: {
                                                Image.checkmark.foregroundColor(.green)
                                        }
                                        Label {
                                                Text(verbatim: "毋用「您」。「您」係北京方言用字，好少見於其他漢語。如果要用敬詞，粵語一般用「閣下」")
                                        } icon: {
                                                Image.warning.foregroundColor(.orange)
                                        }
                                        Label {
                                                Text(verbatim: "毋推薦用「妳」，冇必要畫蛇添足")
                                        } icon: {
                                                Image.warning.foregroundColor(.orange)
                                        }
                                }
                                Section {
                                        Text(verbatim: "第三人稱代詞").font(.significant)

                                        Label {
                                                Text(verbatim: "單數：佢")
                                        } icon: {
                                                Image.checkmark.foregroundColor(.green)
                                        }
                                        Label {
                                                Text(verbatim: "複數：佢哋／佢等")
                                        } icon: {
                                                Image.checkmark.foregroundColor(.green)
                                        }
                                        Label {
                                                Text(verbatim: "避免：他、她、它、他們、她們")
                                        } icon: {
                                                Image.warning.foregroundColor(.orange)
                                        }
                                        Label {
                                                Text(verbatim: "佢亦作渠、⿰亻渠")
                                        } icon: {
                                                Image(systemName: "info.circle").foregroundColor(.primary)
                                        }
                                }
                        }
                        Group {
                                Section {
                                        Text(verbatim: "區分「係」同「喺」").font(.significant)
                                        HStack {
                                                Text(verbatim: "係")
                                                HStack(spacing: 2) {
                                                        Text(verbatim: "hai6").font(.fixedWidth)
                                                        Speaker("hai6")
                                                }
                                                Text(verbatim: "謂語，義同是")
                                                Spacer()
                                        }
                                        HStack {
                                                Text(verbatim: "喺")
                                                HStack(spacing: 2) {
                                                        Text(verbatim: "hai2").font(.fixedWidth)
                                                        Speaker("hai2")
                                                }
                                                Text(verbatim: "表方位、時間，義同在")
                                                Spacer()
                                        }
                                        HStack {
                                                Text(verbatim: "例：我係曹阿瞞。")
                                                Speaker("我係曹阿瞞。")
                                                Spacer()
                                        }
                                        HStack {
                                                Text(verbatim: "例：我喺天后站落車。")
                                                Speaker("我喺天后站落車。")
                                                Spacer()
                                        }
                                }
                                Section {
                                        Text(verbatim: "區分「諗」同「冧」").font(.significant)
                                        HStack(spacing: 16) {
                                                Text(verbatim: "諗")
                                                HStack(spacing: 2) {
                                                        Text(verbatim: "nam2").font(.fixedWidth)
                                                        Speaker("nam2")
                                                }
                                                Text(verbatim: "想、思考、覺得")
                                                Spacer()
                                        }
                                        HStack(spacing: 16) {
                                                Text(verbatim: "冧")
                                                HStack(spacing: 2) {
                                                        Text(verbatim: "lam3").font(.fixedWidth)
                                                        Speaker("lam3")
                                                }
                                                Text(verbatim: "表示倒塌、倒下")
                                                Spacer()
                                        }
                                        HStack {
                                                Text(verbatim: "例：我諗緊今晚食咩。")
                                                Speaker("我諗緊今晚食咩。")
                                                Spacer()
                                        }
                                        HStack {
                                                Text(verbatim: "例：佢畀人㨃冧咗。")
                                                Speaker("佢畀人㨃冧咗。")
                                                Spacer()
                                        }
                                }
                                Section {
                                        Text(verbatim: "區分「咁」同「噉」").font(.significant)
                                        HStack(spacing: 16) {
                                                Text(verbatim: "咁")
                                                HStack(spacing: 2) {
                                                        Text(verbatim: "gam3").font(.fixedWidth)
                                                        Speaker("gam3")
                                                }
                                                Text(verbatim: "音同「禁」")
                                                Spacer()
                                        }
                                        HStack(spacing: 16) {
                                                Text(verbatim: "噉")
                                                HStack(spacing: 2) {
                                                        Text(verbatim: "gam2").font(.fixedWidth)
                                                        Speaker("gam2")
                                                }
                                                Text(verbatim: "音同「感」")
                                                Spacer()
                                        }
                                        HStack {
                                                Text(verbatim: "例：我生得咁靚仔。")
                                                Speaker("我生得咁靚仔。")
                                                Spacer()
                                        }
                                        HStack {
                                                Text(verbatim: "例：噉又未必。")
                                                Speaker("gam2 又未必。")
                                                Spacer()
                                        }
                                }
                        }
                        Group {
                                Section {
                                        HStack {
                                                Text(verbatim: "推薦")
                                                Text(verbatim: "嘅／個得噉。").fontWeight(.medium)
                                                Text(verbatim: "避免")
                                                Text(verbatim: "的得地").fontWeight(.medium)
                                                Spacer()
                                        }
                                        Text(verbatim: "例：我嘅細佬／我個細佬。")
                                        Text(verbatim: "例：講得好！")
                                        Text(verbatim: "例：細細聲噉講話。")
                                }

                                Section {
                                        HStack {
                                                Text(verbatim: "推薦")
                                                Text(verbatim: "啩、啊嘛。").fontWeight(.medium)
                                                Text(verbatim: "避免")
                                                Text(verbatim: "吧").fontWeight(.medium)
                                                Spacer()
                                        }
                                        Label {
                                                Text(verbatim: "下個禮拜會出啩。")
                                        } icon: {
                                                Image.checkmark.foregroundColor(.green)
                                        }
                                        Label {
                                                Text(verbatim: "毋係啊嘛，真係冇？")
                                        } icon: {
                                                Image.checkmark.foregroundColor(.green)
                                        }
                                        Label {
                                                Text(verbatim: "下個禮拜會出吧。")
                                        } icon: {
                                                Image.xmark.foregroundColor(.red)
                                        }
                                        Label {
                                                Text(verbatim: "毋係吧，真係冇？")
                                        } icon: {
                                                Image.xmark.foregroundColor(.red)
                                        }
                                }
                                Section {
                                        HStack {
                                                Text(verbatim: "推薦")
                                                Text(verbatim: "啦、嘞。").fontWeight(.medium)
                                                Text(verbatim: "避免")
                                                Text(verbatim: "了").fontWeight(.medium)
                                                Spacer()
                                        }
                                        Label {
                                                Text(verbatim: "各位，我毋客氣啦。")
                                        } icon: {
                                                Image.checkmark.foregroundColor(.green)
                                        }
                                        Label {
                                                Text(verbatim: "係嘞，你試過箇間餐廳未啊？")
                                        } icon: {
                                                Image.checkmark.foregroundColor(.green)
                                        }
                                        Label {
                                                Text(verbatim: "各位，我毋客氣了。")
                                        } icon: {
                                                Image.xmark.foregroundColor(.red)
                                        }
                                        Label {
                                                Text(verbatim: "係了，你試過箇間餐廳未啊？")
                                        } icon: {
                                                Image.xmark.foregroundColor(.red)
                                        }
                                }
                                Section {
                                        HStack {
                                                Text(verbatim: "推薦")
                                                Text(verbatim: "使。").fontWeight(.medium)
                                                Text(verbatim: "避免")
                                                Text(verbatim: "駛、洗").fontWeight(.medium)
                                                Spacer()
                                        }
                                        Label {
                                                Text(verbatim: "毋使驚")
                                        } icon: {
                                                Image.checkmark.foregroundColor(.green)
                                        }
                                        Label {
                                                Text(verbatim: "毋駛驚")
                                        } icon: {
                                                Image.xmark.foregroundColor(.red)
                                        }
                                        Label {
                                                Text(verbatim: "毋洗驚")
                                        } icon: {
                                                Image.xmark.foregroundColor(.red)
                                        }
                                }
                                Section {
                                        HStack {
                                                Text(verbatim: "推薦")
                                                Text(verbatim: "而家／而今。").fontWeight(.medium)
                                                Text(verbatim: "避免")
                                                Text(verbatim: "宜家").fontWeight(.medium)
                                                Spacer()
                                        }
                                        Label {
                                                Text(verbatim: "我而家食緊飯。")
                                        } icon: {
                                                Image.checkmark.foregroundColor(.green)
                                        }
                                        Label {
                                                Text(verbatim: "我宜家食緊飯。")
                                        } icon: {
                                                Image.xmark.foregroundColor(.red)
                                        }
                                }
                        }
                }
                .textSelection(.enabled)
                .navigationTitle("title.expressions")
                .navigationBarTitleDisplayMode(.inline)
        }
}

#endif
