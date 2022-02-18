/// Virtual KeyCode
struct KeyCode {

        /// Letter [a-z]
        struct Alphabet {
                static let VK_A: UInt16 = 0x0
                static let VK_B: UInt16 = 0xb
                static let VK_C: UInt16 = 0x8
                static let VK_D: UInt16 = 0x2
                static let VK_E: UInt16 = 0xe
                static let VK_F: UInt16 = 0x3
                static let VK_G: UInt16 = 0x5
                static let VK_H: UInt16 = 0x4
                static let VK_I: UInt16 = 0x22
                static let VK_J: UInt16 = 0x26
                static let VK_K: UInt16 = 0x28
                static let VK_L: UInt16 = 0x25
                static let VK_M: UInt16 = 0x2e
                static let VK_N: UInt16 = 0x2d
                static let VK_O: UInt16 = 0x1f
                static let VK_P: UInt16 = 0x23
                static let VK_Q: UInt16 = 0xc
                static let VK_R: UInt16 = 0xf
                static let VK_S: UInt16 = 0x1
                static let VK_T: UInt16 = 0x11
                static let VK_U: UInt16 = 0x20
                static let VK_V: UInt16 = 0x9
                static let VK_W: UInt16 = 0xd
                static let VK_X: UInt16 = 0x7
                static let VK_Y: UInt16 = 0x10
                static let VK_Z: UInt16 = 0x6
        }

        /// Letter [a-z]
        static let alphabetSet: Set<UInt16> = [
                Alphabet.VK_A,
                Alphabet.VK_B,
                Alphabet.VK_C,
                Alphabet.VK_D,
                Alphabet.VK_E,
                Alphabet.VK_F,
                Alphabet.VK_G,
                Alphabet.VK_H,
                Alphabet.VK_I,
                Alphabet.VK_J,
                Alphabet.VK_K,
                Alphabet.VK_L,
                Alphabet.VK_M,
                Alphabet.VK_N,
                Alphabet.VK_O,
                Alphabet.VK_P,
                Alphabet.VK_Q,
                Alphabet.VK_R,
                Alphabet.VK_S,
                Alphabet.VK_T,
                Alphabet.VK_U,
                Alphabet.VK_V,
                Alphabet.VK_W,
                Alphabet.VK_X,
                Alphabet.VK_Y,
                Alphabet.VK_Z,
        ]

        /// [0-9]
        struct Number {
                static let VK_KEY_0: UInt16 = 0x1d
                static let VK_KEY_1: UInt16 = 0x12
                static let VK_KEY_2: UInt16 = 0x13
                static let VK_KEY_3: UInt16 = 0x14
                static let VK_KEY_4: UInt16 = 0x15
                static let VK_KEY_5: UInt16 = 0x17
                static let VK_KEY_6: UInt16 = 0x16
                static let VK_KEY_7: UInt16 = 0x1a
                static let VK_KEY_8: UInt16 = 0x1c
                static let VK_KEY_9: UInt16 = 0x19
        }

        /// [0-9]
        static let numberSet: Set<UInt16> = [
                Number.VK_KEY_0,
                Number.VK_KEY_1,
                Number.VK_KEY_2,
                Number.VK_KEY_3,
                Number.VK_KEY_4,
                Number.VK_KEY_5,
                Number.VK_KEY_6,
                Number.VK_KEY_7,
                Number.VK_KEY_8,
                Number.VK_KEY_9,
        ]

        struct Symbol {
                /// aka. grave accent. Below ESC.
                static let VK_BACKQUOTE    : UInt16 = 0x32

                /// \
                static let VK_BACKSLASH    : UInt16 = 0x2a
                static let VK_BRACKET_LEFT : UInt16 = 0x21
                static let VK_BRACKET_RIGHT: UInt16 = 0x1e
                static let VK_COMMA        : UInt16 = 0x2b
                static let VK_DOT          : UInt16 = 0x2f
                static let VK_EQUAL        : UInt16 = 0x18
                static let VK_MINUS        : UInt16 = 0x1b
                static let VK_QUOTE        : UInt16 = 0x27
                static let VK_SEMICOLON    : UInt16 = 0x29

                /// /
                static let VK_SLASH        : UInt16 = 0x2c
        }
        static let symbolSet: Set<UInt16> = [
                Symbol.VK_BACKQUOTE,
                Symbol.VK_BACKSLASH,
                Symbol.VK_BRACKET_LEFT,
                Symbol.VK_BRACKET_RIGHT,
                Symbol.VK_COMMA,
                Symbol.VK_DOT,
                Symbol.VK_EQUAL,
                Symbol.VK_MINUS,
                Symbol.VK_QUOTE,
                Symbol.VK_SEMICOLON,
                Symbol.VK_SLASH,
        ]

        struct Keypad {
                static let VK_KEYPAD_0       : UInt16 = 0x52
                static let VK_KEYPAD_1       : UInt16 = 0x53
                static let VK_KEYPAD_2       : UInt16 = 0x54
                static let VK_KEYPAD_3       : UInt16 = 0x55
                static let VK_KEYPAD_4       : UInt16 = 0x56
                static let VK_KEYPAD_5       : UInt16 = 0x57
                static let VK_KEYPAD_6       : UInt16 = 0x58
                static let VK_KEYPAD_7       : UInt16 = 0x59
                static let VK_KEYPAD_8       : UInt16 = 0x5b
                static let VK_KEYPAD_9       : UInt16 = 0x5c
                static let VK_KEYPAD_CLEAR   : UInt16 = 0x47

                /// Unknown
                static let VK_KEYPAD_COMMA   : UInt16 = 0x5f

                static let VK_KEYPAD_DOT     : UInt16 = 0x41
                static let VK_KEYPAD_ENTER   : UInt16 = 0x4c
                static let VK_KEYPAD_EQUAL   : UInt16 = 0x51
                static let VK_KEYPAD_MINUS   : UInt16 = 0x4e
                static let VK_KEYPAD_MULTIPLY: UInt16 = 0x43
                static let VK_KEYPAD_PLUS    : UInt16 = 0x45
                static let VK_KEYPAD_SLASH   : UInt16 = 0x4b
        }
        static let keypadSet: Set<UInt16> = [
                Keypad.VK_KEYPAD_0,
                Keypad.VK_KEYPAD_1,
                Keypad.VK_KEYPAD_2,
                Keypad.VK_KEYPAD_3,
                Keypad.VK_KEYPAD_4,
                Keypad.VK_KEYPAD_5,
                Keypad.VK_KEYPAD_6,
                Keypad.VK_KEYPAD_7,
                Keypad.VK_KEYPAD_8,
                Keypad.VK_KEYPAD_9,
                Keypad.VK_KEYPAD_CLEAR,
                Keypad.VK_KEYPAD_COMMA,
                Keypad.VK_KEYPAD_DOT,
                Keypad.VK_KEYPAD_ENTER,
                Keypad.VK_KEYPAD_EQUAL,
                Keypad.VK_KEYPAD_MINUS,
                Keypad.VK_KEYPAD_MULTIPLY,
                Keypad.VK_KEYPAD_PLUS,
                Keypad.VK_KEYPAD_SLASH,
        ]

        struct Special {
                /// Backspace
                static let VK_BACKWARD_DELETE: UInt16 = 0x33
                static let VK_ENTER_POWERBOOK: UInt16 = 0x34
                static let VK_ESCAPE         : UInt16 = 0x35
                static let VK_FORWARD_DELETE : UInt16 = 0x75
                static let VK_HELP           : UInt16 = 0x72
                static let VK_RETURN         : UInt16 = 0x24
                static let VK_SPACE          : UInt16 = 0x31
                static let VK_TAB            : UInt16 = 0x30
                static let VK_PAGEUP  : UInt16 = 0x74
                static let VK_PAGEDOWN: UInt16 = 0x79
                static let VK_HOME    : UInt16 = 0x73
                static let VK_END     : UInt16 = 0x77
        }
        static let specialSet: Set<UInt16> = [
                Special.VK_BACKWARD_DELETE,
                Special.VK_ENTER_POWERBOOK,
                Special.VK_ESCAPE,
                Special.VK_FORWARD_DELETE,
                Special.VK_HELP,
                Special.VK_RETURN,
                Special.VK_SPACE,
                Special.VK_TAB,
                Special.VK_PAGEUP,
                Special.VK_PAGEDOWN,
                Special.VK_HOME,
                Special.VK_END,
        ]

        struct Arrow {
                static let VK_UP   : UInt16 = 0x7e
                static let VK_DOWN : UInt16 = 0x7d
                static let VK_LEFT : UInt16 = 0x7b
                static let VK_RIGHT: UInt16 = 0x7c
        }
        static let arrowSet: Set<UInt16> = [
                Arrow.VK_UP,
                Arrow.VK_DOWN,
                Arrow.VK_LEFT,
                Arrow.VK_RIGHT,
        ]

        struct Modifier {
                static let VK_CAPS_LOCK    : UInt16 = 0x39
                static let VK_COMMAND_LEFT : UInt16 = 0x37
                static let VK_COMMAND_RIGHT: UInt16 = 0x36
                static let VK_CONTROL_LEFT : UInt16 = 0x3b
                static let VK_CONTROL_RIGHT: UInt16 = 0x3e

                /// Function / Globe
                static let VK_FN           : UInt16 = 0x3f
                static let VK_OPTION_LEFT  : UInt16 = 0x3a
                static let VK_OPTION_RIGHT : UInt16 = 0x3d
                static let VK_SHIFT_LEFT   : UInt16 = 0x38
                static let VK_SHIFT_RIGHT  : UInt16 = 0x3c
        }
        static let modifierSet: Set<UInt16> = [
                Modifier.VK_CAPS_LOCK,
                Modifier.VK_COMMAND_LEFT,
                Modifier.VK_COMMAND_RIGHT,
                Modifier.VK_CONTROL_LEFT,
                Modifier.VK_CONTROL_RIGHT,
                Modifier.VK_FN,
                Modifier.VK_OPTION_LEFT,
                Modifier.VK_OPTION_RIGHT,
                Modifier.VK_SHIFT_LEFT,
                Modifier.VK_SHIFT_RIGHT,
        ]

        struct Function {
                /// Display brightness down
                static let VK_F1 : UInt16 = 0x7a

                /// Display brightness up
                static let VK_F2 : UInt16 = 0x78

                /// Mission Control
                static let VK_F3 : UInt16 = 0x63

                /// Spotlight / Launchpad
                static let VK_F4 : UInt16 = 0x76

                /// Dictation / Keyboard backlight down / None
                static let VK_F5 : UInt16 = 0x60

                /// Focus / Keyboard backlight up / None
                static let VK_F6 : UInt16 = 0x61

                /// Rewind
                static let VK_F7 : UInt16 = 0x62

                /// Play-Pause
                static let VK_F8 : UInt16 = 0x64

                /// Fast forward
                static let VK_F9 : UInt16 = 0x65

                /// Mute
                static let VK_F10: UInt16 = 0x6d

                /// Volume down
                static let VK_F11: UInt16 = 0x67

                /// Volume up
                static let VK_F12: UInt16 = 0x6f

                static let VK_F13: UInt16 = 0x69
                static let VK_F14: UInt16 = 0x6b
                static let VK_F15: UInt16 = 0x71
                static let VK_F16: UInt16 = 0x6a
                static let VK_F17: UInt16 = 0x40
                static let VK_F18: UInt16 = 0x4f
                static let VK_F19: UInt16 = 0x50
        }
        static let functionSet: Set<UInt16> = [
                Function.VK_F1,
                Function.VK_F2,
                Function.VK_F3,
                Function.VK_F4,
                Function.VK_F5,
                Function.VK_F6,
                Function.VK_F7,
                Function.VK_F8,
                Function.VK_F9,
                Function.VK_F10,
                Function.VK_F11,
                Function.VK_F12,
                Function.VK_F13,
                Function.VK_F14,
                Function.VK_F15,
                Function.VK_F16,
                Function.VK_F17,
                Function.VK_F18,
                Function.VK_F19,
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

                // is backspace?
                static let VK_PC_BS            : UInt16 = 0x33

                // Keypad DOT
                static let VK_PC_DEL           : UInt16 = 0x75

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

