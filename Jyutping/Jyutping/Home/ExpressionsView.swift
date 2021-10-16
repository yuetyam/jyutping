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
                                                Text(verbatim: "唔用〔您、您們〕。「您」係北京方言用字，好少見於其他漢語。如果要用敬語，粵語一般用「閣下」")
                                        } icon: {
                                                Image(systemName: "exclamationmark.circle").foregroundColor(.orange)
                                        }
                                        Label {
                                                Text(verbatim: "唔推薦用「妳」，冇必要畫蛇添足")
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
                                                Text(verbatim: "係 hai6：謂語，義同系、是。\n喺 hai2：表方位、時間，義同在。")
                                        } icon: {
                                                Image(systemName: "info.circle").hidden()
                                        }
                                        Label {
                                                Text(verbatim: "例：我係曹阿瞞。\n例：我喺天后站落車。")
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
                                                Text(verbatim: "諗 nam2：想、思考、覺得。\n冧 lam3：表示倒塌、倒下。")
                                        } icon: {
                                                Image(systemName: "info.circle").hidden()
                                        }
                                        Label {
                                                Text(verbatim: "例：我諗緊今晚食咩。\n例：佢畀人㨃冧咗。")
                                        } icon: {
                                                Image(systemName: "checkmark.circle").foregroundColor(.green).hidden()
                                        }
                                }
                                .lineSpacing(5)

                                Section {
                                        Label {
                                                Text(verbatim: "區分 曬、晒、哂")
                                        } icon: {
                                                Image(systemName: "5.circle")
                                        }
                                        .font(.headline)

                                        Label {
                                                Text(verbatim: "曬 saai3：曬太陽。\n晒 saai3：助詞，全部、所有、完。\n哂 can2：譏笑。")
                                        } icon: {
                                                Image(systemName: "info.circle").hidden()
                                        }
                                }
                                .lineSpacing(5)
                        }
                        Group {
                                Section {
                                        Label {
                                                Text(verbatim: "個／嘅・得・噉")
                                        } icon: {
                                                Image(systemName: "6.circle")
                                        }
                                        .font(.headline)
                                        Label {
                                                Text(verbatim: "避免 的・得・地")
                                        } icon: {
                                                Image(systemName: "exclamationmark.circle").foregroundColor(.orange)
                                        }
                                        Label {
                                                Text(verbatim: "例：我個細佬／我嘅細佬。\n例：做得好。\n例：細細聲噉講話。")
                                        } icon: {
                                                Image(systemName: "checkmark.circle").foregroundColor(.green)
                                        }
                                }
                                .lineSpacing(5)

                                Section {
                                        Label {
                                                Text(verbatim: "用：啩、啊嘛。  避免：吧")
                                        } icon: {
                                                Image(systemName: "7.circle")
                                        }
                                        .font(.headline)

                                        Label {
                                                Text(verbatim: "例：下個禮拜會出啩。")
                                        } icon: {
                                                Image(systemName: "checkmark.circle").foregroundColor(.green)
                                        }
                                        Label {
                                                Text(verbatim: "例：唔係啊嘛，真係冇？")
                                        } icon: {
                                                Image(systemName: "checkmark.circle").foregroundColor(.green)
                                        }
                                        Label {
                                                Text(verbatim: "誤：下個禮拜會出吧。")
                                        } icon: {
                                                Image(systemName: "xmark.circle").foregroundColor(.red)
                                        }
                                        Label {
                                                Text(verbatim: "誤：唔係吧，真係冇？")
                                        } icon: {
                                                Image(systemName: "xmark.circle").foregroundColor(.red)
                                        }
                                }
                                Section {
                                        Label {
                                                Text(verbatim: "用：使。  避免：駛、洗")
                                        } icon: {
                                                Image(systemName: "8.circle")
                                        }
                                        .font(.headline)

                                        Label {
                                                Text(verbatim: "例：唔使驚")
                                        } icon: {
                                                Image(systemName: "checkmark.circle").foregroundColor(.green)
                                        }
                                        Label {
                                                Text(verbatim: "誤：唔駛驚")
                                        } icon: {
                                                Image(systemName: "xmark.circle").foregroundColor(.red)
                                        }
                                        Label {
                                                Text(verbatim: "誤：唔洗驚")
                                        } icon: {
                                                Image(systemName: "xmark.circle").foregroundColor(.red)
                                        }
                                }
                        }
                        Group {
                                Section {
                                        Label {
                                                Text(verbatim: "推薦：而家／而今。  避免：宜家")
                                        } icon: {
                                                Image(systemName: "9.circle")
                                        }
                                        .font(.headline)

                                        Label {
                                                Text(verbatim: "例：我而家食緊飯。")
                                        } icon: {
                                                Image(systemName: "checkmark.circle").foregroundColor(.green)
                                        }
                                        Label {
                                                Text(verbatim: "誤：我宜家食緊飯。")
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
