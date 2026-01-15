extension Converter {

        /// Convert the given letter VirtualInputKey to a Cangjie root character
        /// - Parameter key: Letter VirtualInputKey [a-z]
        /// - Returns: Cangjie root / radical character
        public static func cangjie(of key: VirtualInputKey) -> Character? {
                return cangjieKeyMap[key]
        }
        private static let cangjieKeyMap: [VirtualInputKey: Character] = [
                VirtualInputKey.letterA: "日",
                VirtualInputKey.letterB: "月",
                VirtualInputKey.letterC: "金",
                VirtualInputKey.letterD: "木",
                VirtualInputKey.letterE: "水",
                VirtualInputKey.letterF: "火",
                VirtualInputKey.letterG: "土",
                VirtualInputKey.letterH: "竹",
                VirtualInputKey.letterI: "戈",
                VirtualInputKey.letterJ: "十",
                VirtualInputKey.letterK: "大",
                VirtualInputKey.letterL: "中",
                VirtualInputKey.letterM: "一",
                VirtualInputKey.letterN: "弓",
                VirtualInputKey.letterO: "人",
                VirtualInputKey.letterP: "心",
                VirtualInputKey.letterQ: "手",
                VirtualInputKey.letterR: "口",
                VirtualInputKey.letterS: "尸",
                VirtualInputKey.letterT: "廿",
                VirtualInputKey.letterU: "山",
                VirtualInputKey.letterV: "女",
                VirtualInputKey.letterW: "田",
                VirtualInputKey.letterX: "難",
                VirtualInputKey.letterY: "卜",
                VirtualInputKey.letterZ: "重"
        ]
}
