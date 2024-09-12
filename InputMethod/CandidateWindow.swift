import SwiftUI

/// NSPanel hosting MotherBoard for Candidates and Options
@MainActor
final class CandidateWindow: NSPanel {

        /// Create a NSPanel with a specified WindowLevel
        init(frame: CGRect? = nil, level: NSWindow.Level?) {
                super.init(contentRect: frame ?? .zero, styleMask: [.borderless, .nonactivatingPanel], backing: .buffered, defer: true)
                self.level = level ?? NSWindow.Level(Int(CGShieldingWindowLevel()))
                isFloatingPanel = true
                worksWhenModal = true
                hidesOnDeactivate = false
                isReleasedWhenClosed = true
                collectionBehavior = .moveToActiveSpace
                isMovable = true
                isMovableByWindowBackground = true
                isOpaque = false
                hasShadow = false
                backgroundColor = .clear
        }
}
