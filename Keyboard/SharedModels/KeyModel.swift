struct KeyElement: Hashable {

        let text: String
        let header: String?
        let footer: String?

        init(_ text: String, header: String? = nil, footer: String? = nil) {
                self.text = text
                self.header = header
                self.footer = footer
        }

        var isTextSingular: Bool {
                return text.count == 1
        }
}

struct KeyModel: Hashable {

        let primary: KeyElement
        let members: [KeyElement]

        var isExpansible: Bool {
                return members.count > 1
        }
}
