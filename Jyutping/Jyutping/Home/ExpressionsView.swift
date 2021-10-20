import SwiftUI

@available(iOS 14.0, *)
struct ExpressionsView: View {
        var body: some View {
                List {
                        Group {
                                Section {
                                        Label {
                                                Text(verbatim: "第二人稱代詞")
                                        } icon: {
                                                Image(systemName: "1.circle")
                                        }
                                        .font(.headline)

                                        Label {
                                                Text(verbatim: "單數：你      複數：你哋／你等")
                                        } icon: {
                                                Image(systemName: "checkmark.circle").foregroundColor(.green)
                                        }
                                        Label {
                                                Text(verbatim: "毋用〔您、您們〕。「您」係北京方言用字，好少見於其他漢語。如果要用敬語，粵語一般用「閣下」")
                                        } icon: {
                                                Image(systemName: "exclamationmark.circle").foregroundColor(.orange)
                                        }
                                        Label {
                                                Text(verbatim: "毋推薦用「妳」，冇必要畫蛇添足")
                                        } icon: {
                                                Image(systemName: "exclamationmark.circle").foregroundColor(.orange)
                                        }
                                }
                                Section {
                                        Label {
                                                Text(verbatim: "第三人稱代詞")
                                        } icon: {
                                                Image(systemName: "2.circle")
                                        }
                                        .font(.headline)

                                        Label {
                                                Text(verbatim: "單數：佢      複數：佢哋／佢等")
                                        } icon: {
                                                Image(systemName: "checkmark.circle").foregroundColor(.green)
                                        }
                                        Label {
                                                Text(verbatim: "避免：他、她、它、他們、她們")
                                        } icon: {
                                                Image(systemName: "exclamationmark.circle").foregroundColor(.orange)
                                        }
                                        Label {
                                                Text(verbatim: "佢亦作渠、𠍲、其")
                                        } icon: {
                                                Image(systemName: "info.circle").foregroundColor(.primary)
                                        }
                                }
                        }
                        Group {
                                Section {
                                        Label {
                                                Text(verbatim: "區分「係」同「喺」")
                                        } icon: {
                                                Image(systemName: "3.circle")
                                        }
                                        .font(.headline)
                                        Label {
                                                Text(verbatim: """
                                                係 hai6：謂語，義同是。
                                                喺 hai2：表方位、時間，義同在。
                                                """)
                                        } icon: {
                                                Image(systemName: "info.circle").hidden()
                                        }
                                        Label {
                                                Text(verbatim: """
                                                例：我係曹阿瞞。
                                                例：我喺天后站落車。
                                                """)
                                        } icon: {
                                                Image(systemName: "checkmark.circle").foregroundColor(.green).hidden()
                                        }
                                }
                                .lineSpacing(5)

                                Section {
                                        Label {
                                                Text(verbatim: "區分「諗」同「冧」")
                                        } icon: {
                                                Image(systemName: "4.circle")
                                        }
                                        .font(.headline)
                                        Label {
                                                Text(verbatim: """
                                                諗 nam2：想、思考、覺得。
                                                冧 lam3：表示倒塌、倒下。
                                                """)
                                        } icon: {
                                                Image(systemName: "info.circle").hidden()
                                        }
                                        Label {
                                                Text(verbatim: """
                                                例：我諗緊今晚食咩。
                                                例：佢畀人㨃冧咗。
                                                """)
                                        } icon: {
                                                Image(systemName: "checkmark.circle").foregroundColor(.green).hidden()
                                        }
                                }
                                .lineSpacing(5)

                                Section {
                                        Label {
                                                Text(verbatim: "區分「咁」同「噉」")
                                        } icon: {
                                                Image(systemName: "5.circle")
                                        }
                                        .font(.headline)

                                        Label {
                                                Text(verbatim: """
                                                咁 gam3，音同「禁」。
                                                噉 gam2，音同「感」。
                                                """)
                                        } icon: {
                                                Image(systemName: "info.circle").hidden()
                                        }
                                        Label {
                                                Text(verbatim: """
                                                例：我生得咁靚仔。
                                                例：噉又未必。
                                                """)
                                        } icon: {
                                                Image(systemName: "checkmark.circle").foregroundColor(.green).hidden()
                                        }
                                }
                                .lineSpacing(5)

                                Section {
                                        Label {
                                                Text(verbatim: "區分 曬、晒、哂")
                                        } icon: {
                                                Image(systemName: "6.circle")
                                        }
                                        .font(.headline)

                                        Label {
                                                Text(verbatim: """
                                                曬 saai3：曬太陽。
                                                晒 saai3：助詞，全部、所有、完。
                                                哂 can2：譏笑。
                                                """)
                                        } icon: {
                                                Image(systemName: "info.circle").hidden()
                                        }
                                }
                                .lineSpacing(5)
                        }
                        Group {
                                Section {
                                        Label {
                                                HStack {
                                                        Text(verbatim: "用").fontWeight(.medium)
                                                        Text(verbatim: "个・得・噉。")
                                                        Text(verbatim: "避免").fontWeight(.medium)
                                                        Text(verbatim: "的・得・地")
                                                }
                                        } icon: {
                                                Image(systemName: "7.circle").font(.headline)
                                        }
                                        Label {
                                                Text(verbatim: """
                                                例：我个睇法。
                                                例：做得好。
                                                例：細細聲噉講話。
                                                """)
                                        } icon: {
                                                Image(systemName: "checkmark.circle").foregroundColor(.green).hidden()
                                        }
                                }
                                .lineSpacing(5)

                                Section {
                                        Label {
                                                HStack {
                                                        Text(verbatim: "用").fontWeight(.medium)
                                                        Text(verbatim: "啩、啊嘛。")
                                                        Text(verbatim: "避免").fontWeight(.medium)
                                                        Text(verbatim: "吧")
                                                }
                                        } icon: {
                                                Image(systemName: "8.circle").font(.headline)
                                        }
                                        Label {
                                                Text(verbatim: "下個禮拜會出啩。")
                                        } icon: {
                                                Image(systemName: "checkmark.circle").foregroundColor(.green)
                                        }
                                        Label {
                                                Text(verbatim: "毋係啊嘛，真係冇？")
                                        } icon: {
                                                Image(systemName: "checkmark.circle").foregroundColor(.green)
                                        }
                                        Label {
                                                Text(verbatim: "下個禮拜會出吧。")
                                        } icon: {
                                                Image(systemName: "xmark.circle").foregroundColor(.red)
                                        }
                                        Label {
                                                Text(verbatim: "毋係吧，真係冇？")
                                        } icon: {
                                                Image(systemName: "xmark.circle").foregroundColor(.red)
                                        }
                                }
                                Section {
                                        Label {
                                                HStack {
                                                        Text(verbatim: "用").fontWeight(.medium)
                                                        Text(verbatim: "使。")
                                                        Text(verbatim: "避免").fontWeight(.medium)
                                                        Text(verbatim: "駛、洗")
                                                }
                                        } icon: {
                                                Image(systemName: "9.circle").font(.headline)
                                        }
                                        Label {
                                                Text(verbatim: "毋使驚")
                                        } icon: {
                                                Image(systemName: "checkmark.circle").foregroundColor(.green)
                                        }
                                        Label {
                                                Text(verbatim: "毋駛驚")
                                        } icon: {
                                                Image(systemName: "xmark.circle").foregroundColor(.red)
                                        }
                                        Label {
                                                Text(verbatim: "毋洗驚")
                                        } icon: {
                                                Image(systemName: "xmark.circle").foregroundColor(.red)
                                        }
                                }
                        }
                        Group {
                                Section {
                                        Label {
                                                HStack {
                                                        Text(verbatim: "推薦").fontWeight(.medium)
                                                        Text(verbatim: "而家／而今。")
                                                        Text(verbatim: "避免").fontWeight(.medium)
                                                        Text(verbatim: "宜家")
                                                }
                                        } icon: {
                                                Image(systemName: "10.circle").font(.headline)
                                        }
                                        Label {
                                                Text(verbatim: "我而家食緊飯。")
                                        } icon: {
                                                Image(systemName: "checkmark.circle").foregroundColor(.green)
                                        }
                                        Label {
                                                Text(verbatim: "我宜家食緊飯。")
                                        } icon: {
                                                Image(systemName: "xmark.circle").foregroundColor(.red)
                                        }
                                }
                        }
                }
                .listStyle(.insetGrouped)
                .navigationTitle("title.expressions")
                .navigationBarTitleDisplayMode(.inline)
        }
}

@available(iOS 14.0, *)
struct ExpressionsView_Previews: PreviewProvider {
        static var previews: some View {
                ExpressionsView()
        }
}
