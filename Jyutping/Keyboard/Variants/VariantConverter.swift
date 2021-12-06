struct VariantConverter {

        static func convert(text: String, to variant: Logogram) -> String {
                switch variant {
                case .traditional:
                        return text
                case .hongkong:
                        let converted: [Character] = text.map({ hongkongVariants[$0] ?? $0 })
                        return String(converted)
                case .taiwan:
                        let converted: [Character] = text.map({ taiwanVariants[$0] ?? $0 })
                        return String(converted)
                case .simplified:
                        return text
                }
        }


private static let hongkongVariants: [Character: Character] = [
"僞": "偽",
"兌": "兑",
"叄": "叁",
"只": "只",
"啓": "啓",
"喫": "吃",
"囪": "囱",
"妝": "妝",
"媼": "媪",
"嬀": "媯",
"悅": "悦",
"慍": "愠",
"戶": "户",
"挩": "捝",
"搵": "揾",
"擡": "抬",
"敓": "敚",
"敘": "敍",
"柺": "枴",
"梲": "棁",
"棱": "稜",
"榲": "榅",
"檯": "枱",
"氳": "氲",
"涗": "涚",
"溫": "温",
"溼": "濕",
"潙": "溈",
"潨": "潀",
"熅": "煴",
"爲": "為",
"癡": "痴",
"皁": "皂",
"祕": "秘",
"稅": "税",
"竈": "灶",
"糉": "粽",
"縕": "緼",
"纔": "才",
"脣": "唇",
"脫": "脱",
"膃": "腽",
"臥": "卧",
"臺": "台",
"菸": "煙",
"蒕": "蒀",
"蔥": "葱",
"蔿": "蒍",
"蘊": "藴",
"蛻": "蜕",
"衆": "眾",
"衛": "衞",
"覈": "核",
"說": "説",
"踊": "踴",
"轀": "輼",
"醞": "醖",
"鉢": "缽",
"鉤": "鈎",
"銳": "鋭",
"鍼": "針",
"閱": "閲",
"鰮": "鰛"
]


private static let taiwanVariants: [Character: Character] = [
"僞": "偽",
"啓": "啟",
"喫": "吃",
"嫺": "嫻",
"嬀": "媯",
"峯": "峰",
"幺": "么",
"擡": "抬",
"棱": "稜",
"檐": "簷",
"污": "汙",
"泄": "洩",
"潙": "溈",
"潨": "潀",
"爲": "為",
"牀": "床",
"痹": "痺",
"癡": "痴",
"皁": "皂",
"着": "著",
"睾": "睪",
"祕": "秘",
"竈": "灶",
"糉": "粽",
"繮": "韁",
"纔": "才",
"羣": "群",
"脣": "唇",
"蔘": "參",
"蔿": "蒍",
"衆": "眾",
"裏": "裡",
"覈": "核",
"踊": "踴",
"鉢": "缽",
"鍼": "針",
"鮎": "鯰",
"麪": "麵",
"齶": "顎"
]


}

