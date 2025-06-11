import SwiftUI

struct PresetConstant {

        static let toolBarHeight: CGFloat = 56

        /// CandidateBoard top-right collapse button
        static let collapseWidth: CGFloat = 44

        /// CandidateBoard top-right collapse button
        static let collapseHeight: CGFloat = 44

        /// KeyView corner radius
        static let keyCornerRadius: CGFloat = 7

        /// Large size KeyView corner radius
        static let largeKeyCornerRadius: CGFloat = 7

        static let halfWidth: String = "半寬"
        static let fullWidth: String = "全寬"

        static let spaceKeyLongPressHint: AttributedString = "← →"

        /// 10-Key Keyboard
        static let defaultSidebarTexts: [String] = ["，", "。", "？", "！", "、", "：", "／", "…", "……", "~", "～"]

        /// 10-Key Numeric Keyboard
        static let symbolSidebarTexts: [String] = ["+", "-", "*", "/", "=", "%", ":", "@", "#", ",", "~", "≈"]

        /// Display KeyText
        static let strokeKeyMap: [String: String] = [
                "w": "⼀",
                "s": "⼁",
                "a": "⼃",
                "d": "⼂",
                "z": "乛",
                "x": "＊",

                "j": "⼀",
                "k": "⼁",
                "l": "⼃",
                "u": "⼂",
                "i": "乛",
                "o": "＊",

                "1": "⼀",
                "2": "⼁",
                "3": "⼃",
                "4": "⼂",
                "5": "乛",
                "6": "＊"
        ]
}
