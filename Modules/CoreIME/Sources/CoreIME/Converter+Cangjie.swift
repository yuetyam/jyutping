extension Converter {

        /// Convert the given latin letter to a Cangjie root character
        /// - Parameter letter: Latin letter [a-z]
        /// - Returns: Cangjie root / radical character
        public static func cangjie(of letter: Character) -> Character? {
                return cangjieMap[letter]
        }
        private static let cangjieMap: [Character: Character] = [
                "a": "日",
                "b": "月",
                "c": "金",
                "d": "木",
                "e": "水",
                "f": "火",
                "g": "土",
                "h": "竹",
                "i": "戈",
                "j": "十",
                "k": "大",
                "l": "中",
                "m": "一",
                "n": "弓",
                "o": "人",
                "p": "心",
                "q": "手",
                "r": "口",
                "s": "尸",
                "t": "廿",
                "u": "山",
                "v": "女",
                "w": "田",
                "x": "難",
                "y": "卜",
                "z": "重"
        ]
}

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
