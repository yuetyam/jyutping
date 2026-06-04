enum KeyDisplayForm: Int, CaseIterable {

        case normal = 1
        case reflecting = 2
        case previewing = 3
        case expanding = 4

        var isNormal: Bool { self == .normal }
        var isReflecting: Bool { self == .reflecting }
        var isPreviewing: Bool { self == .previewing }
        var isExpanding: Bool { self == .expanding }

        static func responsive(isInteracting: Bool, isLongPressing: Bool = false, shouldPreview: Bool = true) -> KeyDisplayForm {
                switch (isInteracting, isLongPressing, shouldPreview) {
                case (true, true, _): .expanding
                case (true, false, true): .previewing
                case (true, _, false): .reflecting
                default: .normal
                }
        }
}
