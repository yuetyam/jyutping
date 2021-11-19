enum KeyboardEvent: Hashable {
        case none,
             key(KeySeat),
             space,
             backspace,
             newLine,
             shift,
             switchTo(KeyboardIdiom),
             switchInputMethod,
             shadowKey(String),
             shadowBackspace
}

struct KeySeat: Hashable {

        let primary: KeyElement
        let children: [KeyElement]

        init(primary: KeyElement, children: [KeyElement] = []) {
                self.primary = primary
                self.children = children
        }

        var hasChildren: Bool { !children.isEmpty }

        static let period: KeySeat = {
                let period: KeyElement = KeyElement(".")
                let comma: KeyElement = KeyElement(",")
                let questionMark: KeyElement = KeyElement("?")
                let exclamationMark: KeyElement = KeyElement("!")
                return KeySeat(primary: period, children: [period, comma, questionMark, exclamationMark])
        }()
        static let cantoneseComma: KeySeat = {
                let comma: KeyElement = KeyElement("，")
                let period: KeyElement = KeyElement("。")
                let questionMark: KeyElement = KeyElement("？")
                let exclamationMark: KeyElement = KeyElement("！")
                return KeySeat(primary: comma, children: [comma, period, questionMark, exclamationMark])
        }()
        static let separator: KeySeat = KeySeat(primary: KeyElement("'", footer: "分隔"))
}

struct KeyElement: Hashable {

        let text: String
        let header: String?
        let footer: String?

        init(_ text: String, header: String? = nil, footer: String? = nil) {
                self.text = text
                self.header = header
                self.footer = footer
        }
}
