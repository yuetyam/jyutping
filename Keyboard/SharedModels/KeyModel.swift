import SwiftUI

extension Alignment {
        var isTopEdge: Bool {
                switch self {
                case .topLeading, .top, .topTrailing: true
                default: false
                }
        }
        var isBottomEdge: Bool {
                switch self {
                case .bottomLeading, .bottom, .bottomTrailing: true
                default: false
                }
        }
}

struct KeyElement: Hashable {

        struct Extra {
                let text: String
                let alignment: Alignment
                init(_ text: String, alignment: Alignment) {
                        self.text = text
                        self.alignment = alignment
                }
        }

        let text: String
        let header: String?
        let footer: String?
        let extras: [Extra]

        init(_ text: String, header: String? = nil, footer: String? = nil, extras: [Extra] = []) {
                self.text = text
                self.header = header
                self.footer = footer
                self.extras = extras
        }

        static func == (lhs: KeyElement, rhs: KeyElement) -> Bool {
                return lhs.text == rhs.text
        }
        func hash(into hasher: inout Hasher) {
                hasher.combine(text)
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

typealias KeyUnit = KeyModel
