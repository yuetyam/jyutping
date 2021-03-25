enum KeyboardEvent: Hashable {
        case key(KeySeat),
             space,
             backspace,
             newLine, // return, enter
             shift,
             switchInputMethod,
             switchTo(KeyboardLayout),

             shadowKey(String),
             shadowBackspace,
             none
}

struct KeySeat: Hashable {

        let primary: KeyElement
        let children: [KeyElement]

        init(primary: KeyElement, children: [KeyElement] = []) {
                self.primary = primary
                self.children = children
        }

        static let periodSeat: KeySeat = KeySeat(primary: .period, children: [.period, .comma, .questionMark, .exclamationMark])
        static let cantoneseCommaSeat: KeySeat = {
                // let separator: KeyElement = KeyElement(text: "\u{0027}", header: "分隔")
                return KeySeat(primary: .cantoneseComma, children: [.cantoneseComma, .cantonesePeriod, .cantoneseQuestionMark, .cantoneseExclamationMark])
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

        static let period: KeyElement = KeyElement(text: ".")
        static let comma: KeyElement = KeyElement(text: ",")
        static let questionMark: KeyElement = KeyElement(text: "?")
        static let exclamationMark: KeyElement = KeyElement(text: "!")

        static let cantonesePeriod: KeyElement = KeyElement(text: "。")
        static let cantoneseComma: KeyElement = KeyElement(text: "，")
        static let cantoneseQuestionMark: KeyElement = KeyElement(text: "？")
        static let cantoneseExclamationMark: KeyElement = KeyElement(text: "！")
}

enum Alignment {
        case center,
             left,
             right
}
