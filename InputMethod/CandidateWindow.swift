import SwiftUI

/// NSPanel hosting MotherBoard for Candidates and Options
@MainActor
final class CandidateWindow: NSPanel {

        /// Create a NSPanel with a specified WindowLevel
        private init(frame: CGRect? = nil, level: NSWindow.Level?) {
                let frame: CGRect = frame ?? CGRect(origin: NSEvent.mouseLocation, size: .zero)
                super.init(contentRect: frame, styleMask: [.borderless, .nonactivatingPanel], backing: .buffered, defer: true)
                self.level = level ?? NSWindow.Level(Int(CGShieldingWindowLevel()))
                isFloatingPanel = true
                worksWhenModal = true
                hidesOnDeactivate = false
                isReleasedWhenClosed = true
                collectionBehavior = .moveToActiveSpace
                isMovable = true
                isMovableByWindowBackground = true
                tabbingMode = .disallowed
                isOpaque = false
                hasShadow = false
                backgroundColor = .clear
        }

        /// Primary NSPanel for CandidateBoard and OptionsView
        static let shared: CandidateWindow = CandidateWindow(level: nil)
}

@MainActor
final class SettingsWindow: NSPanel {
        private init(frame: CGRect? = nil, level: NSWindow.Level?) {
                let frame: CGRect = frame ?? CGRect(origin: NSEvent.mouseLocation, size: .zero)
                super.init(contentRect: frame, styleMask: [.titled, .closable, .resizable, .fullSizeContentView], backing: .buffered, defer: true)
                self.level = level ?? NSWindow.Level(Int(CGShieldingWindowLevel()))
                isFloatingPanel = true
                worksWhenModal = true
                hidesOnDeactivate = false
                isReleasedWhenClosed = false
                collectionBehavior = .moveToActiveSpace
                isMovable = true
                isMovableByWindowBackground = true
                tabbingMode = .disallowed
                title = String(localized: "PreferencesView.Window.Title")
                toolbarStyle = .unifiedCompact
        }
        static let shared: SettingsWindow = SettingsWindow(level: nil)
}
