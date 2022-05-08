import SwiftUI

struct MacExpressionsView: View {
        var body: some View {
                ScrollView {
                        LazyVStack(spacing: 16) {
                                HStack {
                                        VStack(alignment: .leading, spacing: 10) {
                                                Text(verbatim: "第二人稱代詞").font(.masterHeadline)
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
                                        Spacer()
                                }
                                .block()
                                HStack {
                                        VStack(alignment: .leading, spacing: 10) {
                                                Text(verbatim: "第三人稱代詞").font(.masterHeadline)
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
                                                        Text(verbatim: "佢 亦作 渠、𠍲、其")
                                                } icon: {
                                                        Image(systemName: "info.circle").foregroundColor(.primary)
                                                }
                                        }
                                        Spacer()
                                }
                                .block()
                                HStack {
                                        VStack(alignment: .leading, spacing: 10) {
                                                Text("區分 **係** 同 **喺**").font(.masterHeadline)
                                                HStack(spacing: 16) {
                                                        Text(verbatim: "係")
                                                        HStack(spacing: 4) {
                                                                Text(verbatim: "hai6").font(.body)
                                                                Speaker("hai6")
                                                        }
                                                        Text(verbatim: "謂語，義同是。")
                                                }
                                                HStack(spacing: 16) {
                                                        Text(verbatim: "喺")
                                                        HStack(spacing: 4) {
                                                                Text(verbatim: "hai2").font(.body)
                                                                Speaker("hai2")
                                                        }
                                                        Text(verbatim: "表方位、時間，義同在。")
                                                }
                                                HStack(spacing: 44) {
                                                        HStack(spacing: 4) {
                                                                Text(verbatim: "例：我係曹阿瞞。")
                                                                Speaker("我係曹阿瞞。")
                                                        }
                                                        HStack(spacing: 4) {
                                                                Text(verbatim: "例：我喺天后站落車。")
                                                                Speaker("我喺天后站落車。")
                                                        }
                                                }
                                        }
                                        Spacer()
                                }
                                .block()
                                HStack {
                                        VStack(alignment: .leading, spacing: 10) {
                                                Text("區分 **諗** 同 **冧**").font(.masterHeadline)
                                                HStack(spacing: 16) {
                                                        Text(verbatim: "諗")
                                                        HStack(spacing: 4) {
                                                                Text(verbatim: "nam2").font(.body)
                                                                Speaker("nam2")
                                                        }
                                                        Text(verbatim: "想、思考、覺得。")
                                                }
                                                HStack(spacing: 16) {
                                                        Text(verbatim: "冧")
                                                        HStack(spacing: 4) {
                                                                Text(verbatim: "lam3").font(.body)
                                                                Speaker("lam3")
                                                        }
                                                        Text(verbatim: "表示倒塌、倒下。")
                                                }
                                                HStack(spacing: 44) {
                                                        HStack(spacing: 4) {
                                                                Text(verbatim: "例：我諗緊今晚食咩。")
                                                                Speaker("我諗緊今晚食咩。")
                                                        }
                                                        HStack(spacing: 4) {
                                                                Text(verbatim: "例：佢畀人㨃冧咗。")
                                                                Speaker("佢畀人㨃冧咗。")
                                                        }
                                                }
                                        }
                                        Spacer()
                                }
                                .block()

                                HStack {
                                        VStack(alignment: .leading, spacing: 10) {
                                                Text("區分 **咁** 同 **噉**").font(.masterHeadline)
                                                HStack(spacing: 16) {
                                                        Text(verbatim: "咁")
                                                        HStack(spacing: 4) {
                                                                Text(verbatim: "gam3").font(.body)
                                                                Speaker("gam3")
                                                        }
                                                        Text(verbatim: "音同「禁」。")
                                                }
                                                HStack(spacing: 16) {
                                                        Text(verbatim: "噉")
                                                        HStack(spacing: 4) {
                                                                Text(verbatim: "gam2").font(.body)
                                                                Speaker("gam2")
                                                        }
                                                        Text(verbatim: "音同「感」。")
                                                }
                                                HStack(spacing: 44) {
                                                        HStack(spacing: 4) {
                                                                Text(verbatim: "例：我生得咁靚仔。")
                                                                Speaker("我生得咁靚仔。")
                                                        }
                                                        HStack(spacing: 4) {
                                                                Text(verbatim: "例：噉又未必。")
                                                                Speaker("gam2 又未必。")
                                                        }
                                                }
                                        }
                                        Spacer()
                                }
                                .block()

                                HStack {
                                        VStack(alignment: .leading, spacing: 10) {
                                                HStack(spacing: 44) {
                                                        Text("推薦 **嘅／個、得、噉**")
                                                        Text("避免 **的、得、地**")
                                                }
                                                .font(.masterHeadline)

                                                HStack(spacing: 28) {
                                                        HStack(spacing: 4) {
                                                                Text(verbatim: "例：我嘅細佬／我個細佬。")
                                                                Speaker("我個細佬。")
                                                        }
                                                        HStack(spacing: 4) {
                                                                Text(verbatim: "例：講得好！")
                                                                Speaker("講得好！")
                                                        }
                                                        HStack(spacing: 4) {
                                                                Text(verbatim: "例：細細聲噉講話。")
                                                                Speaker("細細聲gam2講話。")
                                                        }
                                                }
                                        }
                                        Spacer()
                                }
                                .block()

                                HStack {
                                        VStack(alignment: .leading, spacing: 10) {
                                                HStack(spacing: 44) {
                                                        Text("推薦 **啩、啊嘛**")
                                                        Text("避免 **吧**")
                                                }
                                                .font(.masterHeadline)

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
                                        Spacer()
                                }
                                .block()
                        }
                        .padding(32)
                }
                .font(.master)
                .textSelection(.enabled)
                .navigationTitle("title.expressions")
        }
}


private extension Font {

        @available(macOS 12.0, *)
        static let master: Font = Font.custom(primaryFontName, size: 13, relativeTo: .body)

        @available(macOS 12.0, *)
        static let masterHeadline: Font = Font.custom(primaryFontName, size: 15, relativeTo: .title3)

        private static let primaryFontName: String = {
                #if os(iOS)
                return "PingFang HK"
                #else
                let fontName: String = {
                        let preferredList: [String] = ["ChiuKong Gothic CL", "Source Han Sans K", "Noto Sans CJK KR"]
                        for name in preferredList {
                                if let font = NSFont(name: name, size: 13) {
                                        return name
                                }
                        }
                        return "PingFang HK"
                }()
                return fontName
                #endif
        }()
}

