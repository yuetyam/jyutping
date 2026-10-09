import SwiftUI
import CommonExtensions
import CoreIME

extension Alignment {

        /// Whether this is `.topLeading`, `.top`, or `.topTrailing`.
        var isTopEdge: Bool {
                switch self {
                case .topLeading, .top, .topTrailing: true
                default: false
                }
        }

        /// Whether this is `.bottomLeading`, `.bottom`, or `.bottomTrailing`.
        var isBottomEdge: Bool {
                switch self {
                case .bottomLeading, .bottom, .bottomTrailing: true
                default: false
                }
        }
}

/// Text for a key or long-press choice, with optional supplementary labels.
///
/// Equality and hashing use only `text`; supplementary labels do not affect identity.
struct KeyElement: Hashable {

        /// A supplementary label positioned relative to the element's main text.
        ///
        /// Depending on the key view, top- or bottom-aligned labels may also supply vertical-pull input.
        struct Extra {

                /// Supplementary text, such as an alternative symbol, width annotation, or Unicode code point.
                let text: String

                /// Placement of the supplementary label within the key or choice.
                let alignment: Alignment

                /// Creates a supplementary label with the given text and placement.
                ///
                /// - Parameters:
                ///   - text: The supplementary label's text.
                ///   - alignment: The label's position relative to the main text.
                init(_ text: String, alignment: Alignment) {
                        self.text = text
                        self.alignment = alignment
                }
        }

        /// Main text displayed by the key and used for input, subject to the key view's case handling.
        let text: String

        /// Supplementary labels in declaration order.
        let extras: [Extra]

        /// Creates an element with optional supplementary labels.
        ///
        /// - Parameters:
        ///   - text: The element's main text.
        ///   - extras: Supplementary labels and their placements. Defaults to no labels.
        init(_ text: String, extras: [Extra] = []) {
                self.text = text
                self.extras = extras
        }

        /// Creates an element from a virtual key's text, without supplementary labels.
        ///
        /// - Parameter virtual: The virtual key supplying the main text.
        init(virtual: VirtualInputKey) {
                self.init(virtual.text)
        }

        /// Compares the main text only, ignoring supplementary labels.
        static func == (lhs: KeyElement, rhs: KeyElement) -> Bool {
                return lhs.text == rhs.text
        }

        /// Hashes the main text only, matching the equality comparison.
        func hash(into hasher: inout Hasher) {
                hasher.combine(text)
        }

        /// Whether the main text contains exactly one Swift `Character`, used to choose label sizing.
        var isTextSingular: Bool { text.count == 1 }
}

/// A key's primary element and ordered choices for long-press selection.
///
/// Key views use `primary` for ordinary input and `members` for expanded selection.
/// Equality and hashing compare the primary text and ordered member texts, ignoring supplementary labels.
struct KeyUnit: Hashable {

        /// Element displayed and processed during ordinary input.
        let primary: KeyElement

        /// Choices for expanded selection, including the primary element when it should be selectable.
        ///
        /// Key views may reverse their visual order to match the expansion direction.
        let members: [KeyElement]

        /// Whether there is more than one member, allowing key views to offer expanded selection.
        var isExpansible: Bool { members.count > 1 }
}
