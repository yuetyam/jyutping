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
        let keys: [KeyElement]

        init(primary: KeyElement, keys: [KeyElement] = []) {
                self.primary = primary
                self.keys = keys
        }

        static let periodSeat: KeySeat = KeySeat(primary: .period, keys: [.comma, .dotCOM, .dotORG, .dotIO])
}

struct KeyElement: Hashable {

        let text: String
        let header: String?
        let footer: String?
        let alignments: (header: Alignment, footer: Alignment)

        init(text: String,
             header: String? = nil,
             footer: String? = nil,
             alignments: (header: Alignment, footer: Alignment) = (header: .right, footer: .center)) {
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
        static let dotCOM: KeyElement = KeyElement(text: ".com")
        static let dotORG: KeyElement = KeyElement(text: ".org")
        static let dotIO: KeyElement = KeyElement(text: ".io")
}

enum Alignment {
        case center,
             left,
             right
}
