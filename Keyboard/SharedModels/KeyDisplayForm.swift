enum KeyDisplayForm: Int, CaseIterable {

        /// Static standby state
        case normal = 1

        /// Reacted colors with KeyTextPreview off
        case reflecting = 2

        /// KeyTextPreview bubble
        case previewing = 3

        /// Long-press bubble
        case expanding = 4

        /// Static standby state
        var isNormal: Bool { self == .normal }

        /// Reacted colors with KeyTextPreview off
        var isReflecting: Bool { self == .reflecting }

        /// KeyTextPreview bubble
        var isPreviewing: Bool { self == .previewing }

        /// Long-press bubble
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
