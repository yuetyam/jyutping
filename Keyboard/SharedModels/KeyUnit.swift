import SwiftUI
import CommonExtensions
import CoreIME

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
        let extras: [Extra]

        init(_ text: String, extras: [Extra] = []) {
                self.text = text
                self.extras = extras
        }

        init(virtual: VirtualInputKey) {
                self.init(virtual.text)
        }

        static func == (lhs: KeyElement, rhs: KeyElement) -> Bool {
                return lhs.text == rhs.text
        }
        func hash(into hasher: inout Hasher) {
                hasher.combine(text)
        }

        var isTextSingular: Bool { text.count == 1 }
}

struct KeyUnit: Hashable {

        let primary: KeyElement
        let members: [KeyElement]

        var isExpansible: Bool { members.count > 1 }
}
