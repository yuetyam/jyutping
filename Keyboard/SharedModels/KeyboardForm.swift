import SwiftUI

enum KeyboardForm: Int {

        /// Expanded Candidate page
        case candidateBoard

        /// 10-key digit keypad with an additional “dot” key
        case decimalPad

        /// Candidate detail page
        case detailInspecting

        /// Button page for copy, cut, clear, etc.
        case editingPanel

        /// Emoji keyboard
        case emojiBoard

        /// KeyboardLayout picking page
        case layoutPicker

        /// 10-key digit keypad
        case numberPad

        /// Numbers and symbols
        case numeric

        /// Not a real view
        case placeholder

        /// Main keyboard; alphabetic; letters or 9-key (T9)
        case primary

        /// Keyboard settings page
        case settings

        /// Extra symbols
        case symbolic

        /// 10-key keypad-style digit keyboard with a symbol sidebar and some other keys
        case tailoredNumbers

        /// 9-key (T9) Stroke keyboard for reverse lookup
        case tailoredStroke
}

extension UIKeyboardType {
        var keyboardForm: KeyboardForm {
                switch self {
                case .default:               .primary
                case .asciiCapable:          .primary
                case .numbersAndPunctuation: .numeric
                case .URL:                   .primary
                case .numberPad:             .numberPad
                case .phonePad:              .numeric
                case .namePhonePad:          .primary
                case .emailAddress:          .primary
                case .decimalPad:            .decimalPad
                case .twitter:               .primary
                case .webSearch:             .primary
                case .asciiCapableNumberPad: .primary
                case .alphabet:              .primary
                @unknown default:            .primary
                }
        }
        var inputMethodMode: InputMethodMode {
                switch self {
                case .default:               .cantonese
                case .asciiCapable:          .cantonese
                case .numbersAndPunctuation: .abc
                case .URL:                   .abc
                case .numberPad:             .abc
                case .phonePad:              .abc
                case .namePhonePad:          .abc
                case .emailAddress:          .abc
                case .decimalPad:            .abc
                case .twitter:               .cantonese
                case .webSearch:             .cantonese
                case .asciiCapableNumberPad: .abc
                case .alphabet:              .cantonese
                @unknown default:            .cantonese
                }
        }
}

extension KeyboardForm {

        /// Main keyboard; alphabetic; letters or 9-key (T9)
        var isPrimary: Bool { self == .primary }

        /// 10-key keypad-style digit keyboard with a symbol sidebar and some other keys
        var isTailoredNumbers: Bool { self == .tailoredNumbers }

        /// 9-key (T9) Stroke keyboard for reverse lookup
        var isTailoredStroke: Bool { self == .tailoredStroke }

        /// 10-key digit keypad with an additional “dot” key
        var isDecimalPad: Bool { self == .decimalPad }

        /// Should stay buffering, should keep the bufferText
        var isBufferable: Bool {
                switch self {
                case .primary,
                .candidateBoard,
                .detailInspecting,
                .tailoredStroke: true
                default: false
                }
        }

        /// Phone, PhoneOnPad, PadFloating
        var compactTransformKeyTex: String {
                switch self {
                case .primary   : "ABC"
                case .numeric,
                .tailoredNumbers: "123"
                case .symbolic  : "#+="
                default         : "???"
                }
        }
        var padTransformKeyText: String {
                switch self {
                case .primary : "ABC"
                case .numeric : ".?123"
                case .symbolic: "#+="
                default       : "???"
                }
        }
}
