#if os(iOS)

import SwiftUI

struct IOSExpressionsView: View {
        var body: some View {
                List {
                        Group {
                                Section {
                                        Text(verbatim: "第一人稱代詞").font(.headline)
                                        Label {
                                                HStack {
                                                        Text(verbatim: "單數：我")
                                                        Speaker("我")
                                                        Spacer()
                                                }
                                        } icon: {
                                                Image.checkmark.foregroundStyle(Color.green)
                                        }
                                        Label {
                                                HStack {
                                                        Text(verbatim: "複數：我哋（我等）")
                                                        Speaker("我哋")
                                                        Spacer()
                                                }
                                        } icon: {
                                                Image.checkmark.foregroundStyle(Color.green)
                                        }
                                        Label {
                                                Text(verbatim: "毋用「咱、咱們」")
                                        } icon: {
                                                Image.warning.foregroundStyle(Color.orange)
                                        }
                                }
                                Section {
                                        Text(verbatim: "第二人稱代詞").font(.headline)
                                        Label {
                                                HStack {
                                                        Text(verbatim: "單數：你")
                                                        Speaker("你")
                                                        Spacer()
                                                }
                                        } icon: {
                                                Image.checkmark.foregroundStyle(Color.green)
                                        }
                                        Label {
                                                HStack {
                                                        Text(verbatim: "複數：你哋（你等）")
                                                        Speaker("你哋")
                                                        Spacer()
                                                }
                                        } icon: {
                                                Image.checkmark.foregroundStyle(Color.green)
                                        }
                                        Label {
                                                Text(verbatim: "毋用「您」。「您」係北京方言用字，好少見於其他漢語。如果要用敬詞，粵語一般用「閣下」。")
                                        } icon: {
                                                Image.warning.foregroundStyle(Color.orange)
                                        }
                                        Label {
                                                Text(verbatim: "毋推薦用「妳」，冇必要畫蛇添足。")
                                        } icon: {
                                                Image.warning.foregroundStyle(Color.orange)
                                        }
                                }
                                Section {
                                        Text(verbatim: "第三人稱代詞").font(.headline)
                                        Label {
                                                HStack {
                                                        Text(verbatim: "單數：佢")
                                                        Speaker("佢")
                                                        Spacer()
                                                }
                                        } icon: {
                                                Image.checkmark.foregroundStyle(Color.green)
                                        }
                                        Label {
                                                HStack {
                                                        Text(verbatim: "複數：佢哋（佢等）")
                                                        Speaker("佢哋")
                                                        Spacer()
                                                }
                                        } icon: {
                                                Image.checkmark.foregroundStyle(Color.green)
                                        }
                                        Label {
                                                Text(verbatim: "毋分性別、人、物，一律用佢。")
                                        } icon: {
                                                Image.info.foregroundStyle(Color.primary)
                                        }
                                        Label {
                                                Text(verbatim: "佢亦作渠、𠍲{⿰亻渠}")
                                        } icon: {
                                                Image.info.foregroundStyle(Color.primary)
                                        }
                                }
                        }
                        Group {
                                Section {
                                        Text(verbatim: "區分【係】以及【喺】").font(.headline)
                                        HStack {
                                                Text(verbatim: "係")
                                                HStack(spacing: 2) {
                                                        Text(verbatim: "hai6").font(.fixedWidth)
                                                        Speaker("hai6")
                                                }
                                                Text(verbatim: "謂語，義同「是」。")
                                                Spacer()
                                        }
                                        HStack {
                                                Text(verbatim: "喺")
                                                HStack(spacing: 2) {
                                                        Text(verbatim: "hai2").font(.fixedWidth)
                                                        Speaker("hai2")
                                                }
                                                Text(verbatim: "表方位、時間，義同「在」。")
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
                                        Text(verbatim: "區分【諗】以及【冧】").font(.headline)
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
                                        Text(verbatim: "區分【咁】以及【噉】").font(.headline)
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
                                        Text(verbatim: "推薦【嘅/個得噉】 避免【的得地】").font(.headline)
                                        Text(verbatim: "例：我嘅細佬／我個細佬。")
                                        Text(verbatim: "例：講得好！")
                                        Text(verbatim: "例：細細聲噉講話。")
                                }

                                Section {
                                        Text(verbatim: "推薦【啩、啊嘛】 避免【吧】").font(.headline)
                                        Label {
                                                Text(verbatim: "下個禮拜會出啩。")
                                        } icon: {
                                                Image.checkmark.foregroundStyle(Color.green)
                                        }
                                        Label {
                                                Text(verbatim: "毋係啊嘛，真係冇？")
                                        } icon: {
                                                Image.checkmark.foregroundStyle(Color.green)
                                        }
                                        Label {
                                                Text(verbatim: "下個禮拜會出吧。")
                                        } icon: {
                                                Image.xmark.foregroundStyle(Color.red)
                                        }
                                        Label {
                                                Text(verbatim: "毋係吧，真係冇？")
                                        } icon: {
                                                Image.xmark.foregroundStyle(Color.red)
                                        }
                                }
                                Section {
                                        Text(verbatim: "推薦【啦、嘞】 避免【了】").font(.headline)
                                        Label {
                                                Text(verbatim: "各位，我毋客氣啦。")
                                        } icon: {
                                                Image.checkmark.foregroundStyle(Color.green)
                                        }
                                        Label {
                                                Text(verbatim: "係嘞，你試過箇間餐廳未啊？")
                                        } icon: {
                                                Image.checkmark.foregroundStyle(Color.green)
                                        }
                                        Label {
                                                Text(verbatim: "各位，我毋客氣了。")
                                        } icon: {
                                                Image.xmark.foregroundStyle(Color.red)
                                        }
                                        Label {
                                                Text(verbatim: "係了，你試過箇間餐廳未啊？")
                                        } icon: {
                                                Image.xmark.foregroundStyle(Color.red)
                                        }
                                }
                                Section {
                                        Text(verbatim: "推薦【使】 避免【駛、洗】").font(.headline)
                                        Label {
                                                Text(verbatim: "毋使驚")
                                        } icon: {
                                                Image.checkmark.foregroundStyle(Color.green)
                                        }
                                        Label {
                                                Text(verbatim: "毋駛驚")
                                        } icon: {
                                                Image.xmark.foregroundStyle(Color.red)
                                        }
                                        Label {
                                                Text(verbatim: "毋洗驚")
                                        } icon: {
                                                Image.xmark.foregroundStyle(Color.red)
                                        }
                                }
                                Section {
                                        Text(verbatim: "推薦【而家】 避免【宜家】").font(.headline)
                                        Label {
                                                Text(verbatim: "我而家食緊飯。")
                                        } icon: {
                                                Image.checkmark.foregroundStyle(Color.green)
                                        }
                                        Label {
                                                Text(verbatim: "我宜家食緊飯。")
                                        } icon: {
                                                Image.xmark.foregroundStyle(Color.red)
                                        }
                                }
                        }
                }
                .textSelection(.enabled)
                .navigationTitle("IOSCantoneseTab.NavigationTitle.CantoneseExpressions")
                .navigationBarTitleDisplayMode(.inline)
        }
}

#endif
