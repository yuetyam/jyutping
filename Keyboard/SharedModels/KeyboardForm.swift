import SwiftUI

enum KeyboardForm: Int {
        case alphabetic
        case candidateBoard
        case decimalPad
        case editingPanel
        case emojiBoard
        case numberPad
        case numeric
        case placeholder
        case settings
        case symbolic
        case tenKeyNumeric
        case tenKeyStroke
}

extension UIKeyboardType {
        var keyboardForm: KeyboardForm {
                switch self {
                case .default:               .alphabetic
                case .asciiCapable:          .alphabetic
                case .numbersAndPunctuation: .numeric
                case .URL:                   .alphabetic
                case .numberPad:             .numberPad
                case .phonePad:              .numeric
                case .namePhonePad:          .alphabetic
                case .emailAddress:          .alphabetic
                case .decimalPad:            .decimalPad
                case .twitter:               .alphabetic
                case .webSearch:             .alphabetic
                case .asciiCapableNumberPad: .alphabetic
                case .alphabet:              .alphabetic
                @unknown default:            .alphabetic
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

        /// Should stay buffering, should keep the bufferText
        var isBufferable: Bool {
                switch self {
                case .alphabetic, .candidateBoard, .tenKeyStroke: true
                default: false
                }
        }

        /// Phone, PhoneOnPad, PadFloating
        var compactTransformKeyTex: String {
                switch self {
                case .alphabetic: "ABC"
                case .numeric,
                .tenKeyNumeric  : "123"
                case .symbolic  : "#+="
                default         : "???"
                }
        }
        var padTransformKeyText: String {
                switch self {
                case .alphabetic: "ABC"
                case .numeric   : ".?123"
                case .symbolic  : "#+="
                default         : "???"
                }
        }
}

enum QwertyForm: Int {

        /// Alphabetic, English
        case abc

        /// Alphabetic, Cantonese 粵拼全鍵盤
        case jyutping

        /// Cantonese Triple-Stroke 粵拼三拼
        case tripleStroke

        /// 普通話拼音
        case pinyin

        /// 倉頡或速成
        case cangjie

        /// 筆畫
        case stroke

        /// 拆字、兩分反查. 例如 木 + 木 = 林: mukmuk
        case structure
}
