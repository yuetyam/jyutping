import Foundation

struct PresetConstant {
        static let HelveticaNeue: String = "Helvetica Neue"
        static let PingFangHK: String = "PingFang HK"
        static let Menlo: String = "Menlo"
        static let latinQueue: [String] = ["SF Pro", "Inter", "Google Sans Flex", "Roboto"]
        static let primaryCJKVQueue: [String] = ["Shanggu Sans", "ChiuKong Gothic CL", "LXGW XiHei CL", "Source Han Sans K", "Noto Sans CJK KR", "Sarasa Gothic CL"]
        static let systemCJKVQueue: [String] = ["PingFang HK", "PingFang MO", "PingFang SC", "PingFang TC"]
        static let supplementaryCJKVQueue: [String] = ["Chiron Hei HK", "Source Han Sans HC", "Noto Sans CJK HK", "Noto Sans HK"]
        static let fallbackCJKVList: [String] = ["Plangothic P1", "Plangothic P2", "MiSans L3"]

        static let halfWidth: String = "半寬"
        static let fullWidth: String = "全寬"

        static let optionsViewTexts: [Int : String] = [
                0 : String(localized: "OptionsView.CharacterStandard.Traditional"),
                1 : String(localized: "OptionsView.CharacterStandard.TraditionalHongKong"),
                2 : String(localized: "OptionsView.CharacterStandard.TraditionalTaiwan"),
                3 : String(localized: "OptionsView.CharacterStandard.Simplified"),
                4 : String(localized: "OptionsView.CharacterForm.HalfWidth"),
                5 : String(localized: "OptionsView.CharacterForm.FullWidth"),
                6 : String(localized: "OptionsView.PunctuationForm.Cantonese"),
                7 : String(localized: "OptionsView.PunctuationForm.English"),
                8 : String(localized: "OptionsView.InputMethodMode.Cantonese"),
                9 : String(localized: "OptionsView.InputMethodMode.ABC")
        ]

        static let systemABCKeyboardLayout: String = "com.apple.keylayout.ABC"
        static let bundleIdentifier: String = "org.jyutping.inputmethod.Jyutping"
        static let connectionName: String = "org.jyutping.inputmethod.Jyutping_Connection"
}
