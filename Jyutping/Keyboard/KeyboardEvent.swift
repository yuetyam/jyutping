enum KeyboardEvent: Hashable {
        case none,
             key(KeySeat),
             space,
             backspace,
             newLine,
             shift,
             switchTo(KeyboardLayout),
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
                let period: KeyElement = KeyElement(text: ".")
                let comma: KeyElement = KeyElement(text: ",")
                let questionMark: KeyElement = KeyElement(text: "?")
                let exclamationMark: KeyElement = KeyElement(text: "!")
                return KeySeat(primary: period, children: [period, comma, questionMark, exclamationMark])
        }()
        static let cantoneseComma: KeySeat = {
                let comma: KeyElement = KeyElement(text: "，")
                let period: KeyElement = KeyElement(text: "。")
                let questionMark: KeyElement = KeyElement(text: "？")
                let exclamationMark: KeyElement = KeyElement(text: "！")
                let separator: KeyElement = KeyElement(text: "\u{0027}", header: "分隔")
                return KeySeat(primary: comma, children: [comma, period, questionMark, exclamationMark, separator])
        }()
}

struct KeyElement: Hashable {

        let text: String
        let header: String?
        let footer: String?
        let alignments: (header: Alignment, footer: Alignment)

        init(text: String,
             header: String? = nil,
             footer: String? = nil,
             alignments: (header: Alignment, footer: Alignment) = (header: .center, footer: .center)) {
                self.text = text
                self.header = header
                self.footer = footer
                self.alignments = alignments
        }

        static func == (lhs: KeyElement, rhs: KeyElement) -> Bool {
                return lhs.text == rhs.text &&
                        lhs.header == rhs.header &&
                        lhs.footer == rhs.footer
        }
        func hash(into hasher: inout Hasher) {
                hasher.combine(text)
                hasher.combine(header)
                hasher.combine(footer)
        }
}

enum Alignment {
        case center,
             left,
             right
}
