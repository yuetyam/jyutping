import SwiftUI

struct PresetConstant {

        static let toolBarHeight: CGFloat = 56

        /// CandidateBoard top-right collapse button
        static let collapseWidth: CGFloat = 44

        /// CandidateBoard top-right collapse button
        static let collapseHeight: CGFloat = 44

        static let halfWidth: String = "半寬"
        static let fullWidth: String = "全寬"

        static let spaceKeyLongPressHint: AttributedString = "← →"

        static let kGW: String = "gw"
        static let kDoubleGW: String = "gwgw"
        static let kKW: String = "kw"

        /// 10-Key Keyboard
        static let defaultSidebarTexts: [String] = ["，", "。", "？", "！", "…", "……", "、", "~", "～"]

        /// 10-Key Numeric Keyboard
        static let symbolSidebarTexts: [String] = ["+", "-", "*", "/", "=", ":", "%", "#", "@"]
}
