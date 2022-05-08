import SwiftUI

struct MacExpressionsView: View {
        var body: some View {
                ScrollView {
                        LazyVStack {
                                HStack {
                                        VStack(alignment: .leading, spacing: 10) {
                                                Text(verbatim: "第二人稱代詞").font(.title3)
                                                Label {
                                                        Text(verbatim: "單數：你")
                                                } icon: {
                                                        Image(systemName: "checkmark.circle").foregroundColor(.green)
                                                }
                                                Label {
                                                        Text(verbatim: "複數：你哋／你等")
                                                } icon: {
                                                        Image(systemName: "checkmark.circle").foregroundColor(.green)
                                                }
                                                Label {
                                                        Text(verbatim: "毋用「您」。「您」係北京方言用字，好少見於其他漢語。如果要用敬詞，粵語一般用「閣下」")
                                                } icon: {
                                                        Image(systemName: "exclamationmark.circle").foregroundColor(.orange)
                                                }
                                                Label {
                                                        Text(verbatim: "毋推薦用「妳」，冇必要畫蛇添足")
                                                } icon: {
                                                        Image(systemName: "exclamationmark.circle").foregroundColor(.orange)
                                                }
                                        }
                                        Spacer()
                                }
                                .block()
                                HStack {
                                        VStack(alignment: .leading, spacing: 10) {
                                                Text(verbatim: "第三人稱代詞").font(.title3)
                                                Label {
                                                        Text(verbatim: "單數：佢")
                                                } icon: {
                                                        Image(systemName: "checkmark.circle").foregroundColor(.green)
                                                }
                                                Label {
                                                        Text(verbatim: "複數：佢哋／佢等")
                                                } icon: {
                                                        Image(systemName: "checkmark.circle").foregroundColor(.green)
                                                }
                                                Label {
                                                        Text(verbatim: "避免：他、她、它、他們、她們")
                                                } icon: {
                                                        Image(systemName: "exclamationmark.circle").foregroundColor(.orange)
                                                }
                                                Label {
                                                        Text(verbatim: "佢亦作渠、⿰亻渠、其")
                                                } icon: {
                                                        Image(systemName: "info.circle").foregroundColor(.primary)
                                                }
                                        }
                                        Spacer()
                                }
                                .block()
                                HStack {
                                        VStack(alignment: .leading, spacing: 10) {
                                                Text("區分 **係** 同 **喺**").font(.title3)
                                                HStack {
                                                        Text(verbatim: "係")
                                                        Text(verbatim: "讀音 hai6")
                                                        Speaker("hai6")
                                                        Text(verbatim: "謂語，義同是。")
                                                }
                                                HStack {
                                                        Text(verbatim: "喺")
                                                        Text(verbatim: "讀音 hai2")
                                                        Speaker("hai2")
                                                        Text(verbatim: "表方位、時間，義同在。")
                                                }
                                                HStack {
                                                        Text(verbatim: "例：")
                                                        Text(verbatim: "我係曹阿瞞。我喺天后站落車。")
                                                        Speaker("我係曹阿瞞。我喺天后站落車。")
                                                }
                                        }
                                        Spacer()
                                }
                                .block()
                        }
                        .padding(32)
                }
                .textSelection(.enabled)
                .navigationTitle("title.expressions")
        }
}

