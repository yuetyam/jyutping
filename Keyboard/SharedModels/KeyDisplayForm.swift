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

        /// Determines the key's display form from its interaction state and preview preference.
        ///
        /// Long-press expansion takes precedence, keeping the alternative selector visible even when the finger slides outside the button and its pressed state ends.
        /// Otherwise, an interacting key previews its text or reflects the press through its appearance; an inactive key is normal.
        ///
        /// - Parameters:
        ///   - isInteracting: Whether the key is currently being interacted with, such as its button being pressed.
        ///   - isLongPressEngaged: Whether the long-press alternative selector has been activated.
        ///   - isPreviewEnabled: Whether an ordinary interaction shows a text preview.
        /// - Returns: The responsive display form.
        static func responsive(isInteracting: Bool, isLongPressEngaged: Bool = false, isPreviewEnabled: Bool = true) -> KeyDisplayForm {
                switch (isInteracting, isLongPressEngaged, isPreviewEnabled) {
                case (_, true, _): .expanding
                case (true, false, true): .previewing
                case (true, false, false): .reflecting
                default: .normal
                }
        }
}
