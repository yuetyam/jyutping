extension Converter {

        /// Convert the given letter InputEvent to a Cangjie root character
        /// - Parameter event: Letter InputEvent [a-z]
        /// - Returns: Cangjie root / radical character
        public static func cangjie(of event: InputEvent) -> Character? {
                return cangjieEventMap[event]
        }
        private static let cangjieEventMap: [InputEvent: Character] = [
                InputEvent.letterA: "日",
                InputEvent.letterB: "月",
                InputEvent.letterC: "金",
                InputEvent.letterD: "木",
                InputEvent.letterE: "水",
                InputEvent.letterF: "火",
                InputEvent.letterG: "土",
                InputEvent.letterH: "竹",
                InputEvent.letterI: "戈",
                InputEvent.letterJ: "十",
                InputEvent.letterK: "大",
                InputEvent.letterL: "中",
                InputEvent.letterM: "一",
                InputEvent.letterN: "弓",
                InputEvent.letterO: "人",
                InputEvent.letterP: "心",
                InputEvent.letterQ: "手",
                InputEvent.letterR: "口",
                InputEvent.letterS: "尸",
                InputEvent.letterT: "廿",
                InputEvent.letterU: "山",
                InputEvent.letterV: "女",
                InputEvent.letterW: "田",
                InputEvent.letterX: "難",
                InputEvent.letterY: "卜",
                InputEvent.letterZ: "重"
        ]
}
