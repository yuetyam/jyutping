/// Virtual KeyCode from Mac OS X Carbon HIToolbox/Events.h
struct KeyCode {

        /// Letter [a-z]
        struct Alphabet {
                static let letterA: UInt16 = 0x0
                static let letterB: UInt16 = 0xb
                static let letterC: UInt16 = 0x8
                static let letterD: UInt16 = 0x2
                static let letterE: UInt16 = 0xe
                static let letterF: UInt16 = 0x3
                static let letterG: UInt16 = 0x5
                static let letterH: UInt16 = 0x4
                static let letterI: UInt16 = 0x22
                static let letterJ: UInt16 = 0x26
                static let letterK: UInt16 = 0x28
                static let letterL: UInt16 = 0x25
                static let letterM: UInt16 = 0x2e
                static let letterN: UInt16 = 0x2d
                static let letterO: UInt16 = 0x1f
                static let letterP: UInt16 = 0x23
                static let letterQ: UInt16 = 0xc
                static let letterR: UInt16 = 0xf
                static let letterS: UInt16 = 0x1
                static let letterT: UInt16 = 0x11
                static let letterU: UInt16 = 0x20
                static let letterV: UInt16 = 0x9
                static let letterW: UInt16 = 0xd
                static let letterX: UInt16 = 0x7
                static let letterY: UInt16 = 0x10
                static let letterZ: UInt16 = 0x6
        }

        /// Letter [a-z]
        static let alphabetSet: Set<UInt16> = [
                Alphabet.letterA,
                Alphabet.letterB,
                Alphabet.letterC,
                Alphabet.letterD,
                Alphabet.letterE,
                Alphabet.letterF,
                Alphabet.letterG,
                Alphabet.letterH,
                Alphabet.letterI,
                Alphabet.letterJ,
                Alphabet.letterK,
                Alphabet.letterL,
                Alphabet.letterM,
                Alphabet.letterN,
                Alphabet.letterO,
                Alphabet.letterP,
                Alphabet.letterQ,
                Alphabet.letterR,
                Alphabet.letterS,
                Alphabet.letterT,
                Alphabet.letterU,
                Alphabet.letterV,
                Alphabet.letterW,
                Alphabet.letterX,
                Alphabet.letterY,
                Alphabet.letterZ,
        ]

        /// Digit [0-9]
        struct Number {
                static let number0: UInt16 = 0x1d
                static let number1: UInt16 = 0x12
                static let number2: UInt16 = 0x13
                static let number3: UInt16 = 0x14
                static let number4: UInt16 = 0x15
                static let number5: UInt16 = 0x17
                static let number6: UInt16 = 0x16
                static let number7: UInt16 = 0x1a
                static let number8: UInt16 = 0x1c
                static let number9: UInt16 = 0x19
        }

        /// Digit [0-9]
        static let numberSet: Set<UInt16> = [
                Number.number0,
                Number.number1,
                Number.number2,
                Number.number3,
                Number.number4,
                Number.number5,
                Number.number6,
                Number.number7,
                Number.number8,
                Number.number9,
        ]

        struct Symbol {
                static let backslash   : UInt16 = 0x2a
                static let bracketLeft : UInt16 = 0x21
                static let bracketRight: UInt16 = 0x1e
                static let comma       : UInt16 = 0x2b
                static let equal       : UInt16 = 0x18
                /// Grave accent; Backtick; Backquote
                static let grave       : UInt16 = 0x32
                static let minus       : UInt16 = 0x1b
                /// Full-stop
                static let period      : UInt16 = 0x2f
                /// Apostrophe
                static let quote       : UInt16 = 0x27
                static let semicolon   : UInt16 = 0x29
                static let slash       : UInt16 = 0x2c
        }
        static let symbolSet: Set<UInt16> = [
                Symbol.backslash,
                Symbol.bracketLeft,
                Symbol.bracketRight,
                Symbol.comma,
                Symbol.equal,
                Symbol.minus,
                Symbol.grave,
                Symbol.period,
                Symbol.quote,
                Symbol.semicolon,
                Symbol.slash,
        ]

        struct Keypad {
                static let keypad0       : UInt16 = 0x52
                static let keypad1       : UInt16 = 0x53
                static let keypad2       : UInt16 = 0x54
                static let keypad3       : UInt16 = 0x55
                static let keypad4       : UInt16 = 0x56
                static let keypad5       : UInt16 = 0x57
                static let keypad6       : UInt16 = 0x58
                static let keypad7       : UInt16 = 0x59
                static let keypad8       : UInt16 = 0x5b
                static let keypad9       : UInt16 = 0x5c
                static let keypadClear   : UInt16 = 0x47
                /// Dot; Period; Full-stop
                static let keypadDecimal : UInt16 = 0x41
                static let keypadEnter   : UInt16 = 0x4c
                static let keypadEqual   : UInt16 = 0x51
                static let keypadMinus   : UInt16 = 0x4e
                static let keypadMultiply: UInt16 = 0x43
                static let keypadPlus    : UInt16 = 0x45
                static let keypadSlash   : UInt16 = 0x4b
        }
        static let keypadSet: Set<UInt16> = [
                Keypad.keypad0,
                Keypad.keypad1,
                Keypad.keypad2,
                Keypad.keypad3,
                Keypad.keypad4,
                Keypad.keypad5,
                Keypad.keypad6,
                Keypad.keypad7,
                Keypad.keypad8,
                Keypad.keypad9,
                Keypad.keypadClear,
                Keypad.keypadDecimal,
                Keypad.keypadEnter,
                Keypad.keypadEqual,
                Keypad.keypadMinus,
                Keypad.keypadMultiply,
                Keypad.keypadPlus,
                Keypad.keypadSlash,
        ]

        struct Special {
                /// Backspace
                static let backwardDelete: UInt16 = 0x33
                static let end           : UInt16 = 0x77
                static let escape        : UInt16 = 0x35
                static let forwardDelete : UInt16 = 0x75
                static let help          : UInt16 = 0x72
                static let home          : UInt16 = 0x73
                static let pageDown      : UInt16 = 0x79
                static let pageUp        : UInt16 = 0x74
                static let `return`      : UInt16 = 0x24
                static let space         : UInt16 = 0x31
                static let tab           : UInt16 = 0x30
        }
        static let specialSet: Set<UInt16> = [
                Special.backwardDelete,
                Special.end,
                Special.escape,
                Special.forwardDelete,
                Special.home,
                Special.help,
                Special.pageDown,
                Special.pageUp,
                Special.return,
                Special.space,
                Special.tab,
        ]

        struct Arrow {
                static let down : UInt16 = 0x7d
                static let left : UInt16 = 0x7b
                static let right: UInt16 = 0x7c
                static let up   : UInt16 = 0x7e
        }
        static let arrowSet: Set<UInt16> = [
                Arrow.down,
                Arrow.left,
                Arrow.right,
                Arrow.up,
        ]

        struct Modifier {
                static let capsLock    : UInt16 = 0x39
                static let commandLeft : UInt16 = 0x37
                static let commandRight: UInt16 = 0x36
                static let controlLeft : UInt16 = 0x3b
                static let controlRight: UInt16 = 0x3e
                /// Fn; Globe
                static let function    : UInt16 = 0x3f
                static let optionLeft  : UInt16 = 0x3a
                static let optionRight : UInt16 = 0x3d
                static let shiftLeft   : UInt16 = 0x38
                static let shiftRight  : UInt16 = 0x3c
        }
        static let modifierSet: Set<UInt16> = [
                Modifier.capsLock,
                Modifier.commandLeft,
                Modifier.commandRight,
                Modifier.controlLeft,
                Modifier.controlRight,
                Modifier.function,
                Modifier.optionLeft,
                Modifier.optionRight,
                Modifier.shiftLeft,
                Modifier.shiftRight,
        ]

        struct Function {
                /// Display brightness down
                static let f1 : UInt16 = 0x7a

                /// Display brightness up
                static let f2 : UInt16 = 0x78

                /// Mission Control
                static let f3 : UInt16 = 0x63

                /// Spotlight; Launchpad
                static let f4 : UInt16 = 0x76

                /// Dictation; Keyboard backlight down
                static let f5 : UInt16 = 0x60

                /// Focus; Keyboard backlight up
                static let f6 : UInt16 = 0x61

                /// Rewind
                static let f7 : UInt16 = 0x62

                /// Play-pause
                static let f8 : UInt16 = 0x64

                /// Fast forward
                static let f9 : UInt16 = 0x65

                /// Mute
                static let f10: UInt16 = 0x6d

                /// Volume down
                static let f11: UInt16 = 0x67

                /// Volume up
                static let f12: UInt16 = 0x6f

                static let f13: UInt16 = 0x69
                static let f14: UInt16 = 0x6b
                static let f15: UInt16 = 0x71
                static let f16: UInt16 = 0x6a
                static let f17: UInt16 = 0x40
                static let f18: UInt16 = 0x4f
                static let f19: UInt16 = 0x50
                static let f20: UInt16 = 0x5a
        }
        static let functionSet: Set<UInt16> = [
                Function.f1,
                Function.f2,
                Function.f3,
                Function.f4,
                Function.f5,
                Function.f6,
                Function.f7,
                Function.f8,
                Function.f9,
                Function.f10,
                Function.f11,
                Function.f12,
                Function.f13,
                Function.f14,
                Function.f15,
                Function.f16,
                Function.f17,
                Function.f18,
                Function.f19,
                Function.f20,
        ]

        @available(*, unavailable, message: "Unknown")
        struct Feature {
                static let VK_BRIGHTNESS_DOWN: UInt16 = 0x91
                static let VK_BRIGHTNESS_UP  : UInt16 = 0x90
                static let VK_DASHBOARD      : UInt16 = 0x82
                static let VK_EXPOSE_ALL     : UInt16 = 0xa0
                static let VK_LAUNCHPAD      : UInt16 = 0x83
                static let VK_MISSION_CONTROL: UInt16 = 0xa0
        }

        // https://en.wikipedia.org/wiki/IBM_PC_keyboard
        @available(*, unavailable)
        struct PCKey {
                static let VK_PC_APPLICATION   : UInt16 = 0x6e
                static let VK_PC_INSERT        : UInt16 = 0x72
                static let VK_PC_KEYPAD_NUMLOCK: UInt16 = 0x47
                static let VK_PC_PAUSE         : UInt16 = 0x71
                static let VK_PC_POWER         : UInt16 = 0x7f
                static let VK_PC_PRINTSCREEN   : UInt16 = 0x69
                static let VK_PC_SCROLLLOCK    : UInt16 = 0x6b
        }

        @available(*, unavailable)
        struct International {
                static let VK_DANISH_DOLLAR   : UInt16 = 0xa
                static let VK_DANISH_LESS_THAN: UInt16 = 0x32

                static let VK_FRENCH_DOLLAR     : UInt16 = 0x1e
                static let VK_FRENCH_EQUAL      : UInt16 = 0x2c
                static let VK_FRENCH_HAT        : UInt16 = 0x21
                static let VK_FRENCH_MINUS      : UInt16 = 0x18
                static let VK_FRENCH_RIGHT_PAREN: UInt16 = 0x1b

                static let VK_GERMAN_CIRCUMFLEX  : UInt16 = 0xa
                static let VK_GERMAN_LESS_THAN   : UInt16 = 0x32
                static let VK_GERMAN_PC_LESS_THAN: UInt16 = 0x80
                static let VK_GERMAN_QUOTE       : UInt16 = 0x18
                static let VK_GERMAN_A_UMLAUT    : UInt16 = 0x27
                static let VK_GERMAN_O_UMLAUT    : UInt16 = 0x29
                static let VK_GERMAN_U_UMLAUT    : UInt16 = 0x21

                static let VK_ITALIAN_BACKSLASH: UInt16 = 0xa
                static let VK_ITALIAN_LESS_THAN: UInt16 = 0x32

                static let VK_JIS_ATMARK       : UInt16 = 0x21
                static let VK_JIS_BRACKET_LEFT : UInt16 = 0x1e
                static let VK_JIS_BRACKET_RIGHT: UInt16 = 0x2a
                static let VK_JIS_COLON        : UInt16 = 0x27
                static let VK_JIS_DAKUON       : UInt16 = 0x21
                static let VK_JIS_EISUU        : UInt16 = 0x66
                static let VK_JIS_HANDAKUON    : UInt16 = 0x1e
                static let VK_JIS_HAT          : UInt16 = 0x18
                static let VK_JIS_KANA         : UInt16 = 0x68
                static let VK_JIS_KEYPAD_COMMA : UInt16 = 0x5f
                static let VK_JIS_PC_HAN_ZEN   : UInt16 = 0x32
                static let VK_JIS_UNDERSCORE   : UInt16 = 0x5e
                static let VK_JIS_YEN          : UInt16 = 0x5d

                static let VK_RUSSIAN_PARAGRAPH: UInt16 = 0xa
                static let VK_RUSSIAN_TILDE    : UInt16 = 0x32

                static let VK_SPANISH_LESS_THAN        : UInt16 = 0x32
                static let VK_SPANISH_ORDINAL_INDICATOR: UInt16 = 0xa

                static let VK_SWEDISH_LESS_THAN: UInt16 = 0x32
                static let VK_SWEDISH_SECTION  : UInt16 = 0xa

                static let VK_SWISS_LESS_THAN: UInt16 = 0x32
                static let VK_SWISS_SECTION  : UInt16 = 0xa

                static let VK_UK_SECTION: UInt16 = 0xa
        }
}
