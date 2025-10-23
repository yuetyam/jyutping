#if os(iOS)

import SwiftUI

struct IOSExpressionsView: View {
        var body: some View {
                List {
                        Group {
                                Section {
                                        Text(verbatim: "第一人稱代詞").font(.headline)
                                        Label {
                                                Text(verbatim: "單數：我")
                                        } icon: {
                                                Image.checkmark.foregroundStyle(Color.green)
                                        }
                                        Label {
                                                Text(verbatim: "複數：我哋")
                                        } icon: {
                                                Image.checkmark.foregroundStyle(Color.green)
                                        }
                                        Label {
                                                Text(verbatim: "咱、咱們")
                                        } icon: {
                                                Image.xmark.foregroundStyle(Color.red)
                                        }
                                }
                                Section {
                                        Text(verbatim: "第二人稱代詞").font(.headline)
                                        Label {
                                                Text(verbatim: "單數：你")
                                        } icon: {
                                                Image.checkmark.foregroundStyle(Color.green)
                                        }
                                        Label {
                                                Text(verbatim: "複數：你哋")
                                        } icon: {
                                                Image.checkmark.foregroundStyle(Color.green)
                                        }
                                        Label {
                                                Text(verbatim: "「您」係北京方言用字，好少見於其他漢語。如果要用敬詞，粵語一般用「閣下」。")
                                        } icon: {
                                                Image.warning.foregroundStyle(Color.orange)
                                        }
                                        Label {
                                                Text(verbatim: "冇必要畫蛇添足用「妳」。")
                                        } icon: {
                                                Image.warning.foregroundStyle(Color.orange)
                                        }
                                }
                                Section {
                                        Text(verbatim: "第三人稱代詞").font(.headline)
                                        Label {
                                                Text(verbatim: "單數：佢")
                                        } icon: {
                                                Image.checkmark.foregroundStyle(Color.green)
                                        }
                                        Label {
                                                Text(verbatim: "複數：佢哋")
                                        } icon: {
                                                Image.checkmark.foregroundStyle(Color.green)
                                        }
                                        Label {
                                                Text(verbatim: "無論性別、人、物，一律用佢。")
                                        } icon: {
                                                Image.info.foregroundStyle(Color.primary)
                                        }
                                        Label {
                                                Text(verbatim: "佢 亦作 渠、𠍲{⿰亻渠}")
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
                                                        Text(verbatim: "hai6").monospaced()
                                                        Speaker("hai6")
                                                }
                                                Text(verbatim: "謂語，義同「是」。")
                                                Spacer()
                                        }
                                        HStack {
                                                Text(verbatim: "喺")
                                                HStack(spacing: 2) {
                                                        Text(verbatim: "hai2").monospaced()
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
                                                Text(verbatim: "例：我喺赤壁遊山玩水。")
                                                Speaker("我喺赤壁遊山玩水。")
                                                Spacer()
                                        }
                                }
                                Section {
                                        Text(verbatim: "區分【諗】以及【冧】").font(.headline)
                                        HStack(spacing: 16) {
                                                Text(verbatim: "諗")
                                                HStack(spacing: 2) {
                                                        Text(verbatim: "nam2").monospaced()
                                                        Speaker("nam2")
                                                }
                                                Text(verbatim: "想、思考、覺得")
                                                Spacer()
                                        }
                                        HStack(spacing: 16) {
                                                Text(verbatim: "冧")
                                                HStack(spacing: 2) {
                                                        Text(verbatim: "lam3").monospaced()
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
                                                        Text(verbatim: "gam3").monospaced()
                                                        Speaker("gam3")
                                                }
                                                Text(verbatim: "音同「禁」")
                                                Spacer()
                                        }
                                        HStack(spacing: 16) {
                                                Text(verbatim: "噉")
                                                HStack(spacing: 2) {
                                                        Text(verbatim: "gam2").monospaced()
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
                                Section {
                                        Text(verbatim: "區分【會】以及【識】").font(.headline)
                                        Text(verbatim: "會：位於動詞前，將要做某事。")
                                        Text(verbatim: "識：識得；曉得；懂得；明白。")
                                        Text(verbatim: "例：我會煮飯。（我將要煮飯。）")
                                        Text(verbatim: "例：我識煮飯。（我懂得如何煮飯。）")
                                }
                        }
                        Group {
                                Section {
                                        Text(verbatim: "啩、啊嘛").font(.headline)
                                        Label {
                                                Text(verbatim: "下個禮拜會出啩。")
                                        } icon: {
                                                Image.checkmark.foregroundStyle(Color.green)
                                        }
                                        Label {
                                                Text(verbatim: "唔係啊嘛，真係冇？")
                                        } icon: {
                                                Image.checkmark.foregroundStyle(Color.green)
                                        }
                                        Label {
                                                Text(verbatim: "下個禮拜會出吧。")
                                        } icon: {
                                                Image.xmark.foregroundStyle(Color.red)
                                        }
                                        Label {
                                                Text(verbatim: "唔係吧，真係冇？")
                                        } icon: {
                                                Image.xmark.foregroundStyle(Color.red)
                                        }
                                }
                                Section {
                                        Text(verbatim: "喇、嘞").font(.headline)
                                        Label {
                                                Text(verbatim: "我識用粵拼打字喇！")
                                        } icon: {
                                                Image.checkmark.foregroundStyle(Color.green)
                                        }
                                        Label {
                                                Text(verbatim: "係嘞，你試過粵拼輸入法未啊？")
                                        } icon: {
                                                Image.checkmark.foregroundStyle(Color.green)
                                        }
                                        Label {
                                                Text(verbatim: "我識用粵拼打字了！")
                                        } icon: {
                                                Image.xmark.foregroundStyle(Color.red)
                                        }
                                        Label {
                                                Text(verbatim: "係了，你試過粵拼輸入法未啊？")
                                        } icon: {
                                                Image.xmark.foregroundStyle(Color.red)
                                        }
                                }
                                Section {
                                        Text(verbatim: "使").font(.headline)
                                        Label {
                                                Text(verbatim: "唔使驚")
                                        } icon: {
                                                Image.checkmark.foregroundStyle(Color.green)
                                        }
                                        Label {
                                                Text(verbatim: "唔駛驚")
                                        } icon: {
                                                Image.xmark.foregroundStyle(Color.red)
                                        }
                                        Label {
                                                Text(verbatim: "唔洗驚")
                                        } icon: {
                                                Image.xmark.foregroundStyle(Color.red)
                                        }
                                }
                                Section {
                                        Text(verbatim: "而家").font(.headline)
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
                                Section {
                                        Text(verbatim: "甲（形容詞）過乙").font(.headline)
                                        Label {
                                                Text(verbatim: "苦過黃連。")
                                        } icon: {
                                                Image.checkmark.foregroundStyle(Color.green)
                                        }
                                        Label {
                                                Text(verbatim: "狼過華秀隻狗。")
                                        } icon: {
                                                Image.checkmark.foregroundStyle(Color.green)
                                        }
                                        Label {
                                                Text(verbatim: "比黃連苦。")
                                        } icon: {
                                                Image.xmark.foregroundStyle(Color.red)
                                        }
                                        Label {
                                                Text(verbatim: "比華秀隻狗更狼。")
                                        } icon: {
                                                Image.xmark.foregroundStyle(Color.red)
                                        }
                                }
                                Section {
                                        Text(verbatim: "兩樣都得").font(.headline)
                                        Label {
                                                Text(verbatim: "甲：「你飲茶定係飲咖啡？」")
                                        } icon: {
                                                Image.info.foregroundStyle(Color.primary)
                                        }
                                        Label {
                                                Text(verbatim: "乙：「兩樣都得。」")
                                        } icon: {
                                                Image.checkmark.foregroundStyle(Color.green)
                                        }
                                        Label {
                                                Text(verbatim: "乙：「都得。」")
                                        } icon: {
                                                Image.xmark.foregroundStyle(Color.red)
                                        }
                                }
                                Section {
                                        Text(verbatim: PresetConstant.etymologyNote)
                                                .font(.copilot)
                                                .lineLimit(nil)
                                                .lineSpacing(6)
                                }
                                .listRowBackground(Color.clear)
                        }
                }
                .textSelection(.enabled)
                .navigationTitle("IOSCantoneseTab.NavigationTitle.CantoneseExpressions")
                .navigationBarTitleDisplayMode(.inline)
        }
}

#endif
