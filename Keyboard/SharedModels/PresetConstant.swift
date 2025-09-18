import SwiftUI

struct PresetConstant {

        static let toolBarHeight: CGFloat = 56

        /// Default value for Button width and height
        static let buttonLength: CGFloat = 44

        /// CandidateBoard top-right collapse button
        static let collapseWidth: CGFloat = 44

        /// CandidateBoard top-right collapse button
        static let collapseHeight: CGFloat = 44

        /// KeyView corner radius
        static let keyCornerRadius: CGFloat = 7

        /// Large size KeyView corner radius
        static let largeKeyCornerRadius: CGFloat = 8

        /// Highlighted selection view inside the key bubble preview
        static let innerLargeKeyCornerRadius: CGFloat = 5

        static let halfWidth: String = "半寬"
        static let fullWidth: String = "全寬"
        static let separate: String = "分隔"
        static let reverseLookup: String = "反查"

        static let spaceKeyLongPressHint: AttributedString = "← →"

        /// Display KeyText for Stroke keyboards
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
