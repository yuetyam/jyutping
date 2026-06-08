import SwiftUI

struct PresetConstant {
        static let toolBarHeight: CGFloat = 56

        /// Default value for Button width and height
        static let buttonLength: CGFloat = 44
        static let buttonLengthXL: CGFloat = 50

        /// CandidateBoard top-right collapse button
        static let collapseWidth: CGFloat = 44

        /// CandidateBoard top-right collapse button
        static let collapseHeight: CGFloat = 44

        /// KeyView corner radius
        static let keyCornerRadius: CGFloat = 8

        /// Larger KeyView corner radius
        static let largeKeyCornerRadius: CGFloat = 10

        /// Largest KeyView corner radius
        static let ultraKeyCornerRadius: CGFloat = 12

        /// Highlighted selection view inside the key bubble preview (iPad)
        static let innerLargeKeyCornerRadius: CGFloat = 6

        static let halfWidth: String = "半寬"
        static let fullWidth: String = "全寬"
        static let separate: String = "分隔"
        static let reverseLookup: String = "反查"

        static let spaceKeyLongPressHint: AttributedString = "← →"

        /// Milliseconds in a day
        static let dayIntervalMilliseconds: Int64 = 86_400_000
}
