import SwiftUI

#if os(macOS)
import AppKit

final class AppDelegate: NSObject, NSApplicationDelegate {
        func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
                return true
        }
}

@main
struct ContainerApp: App {

        @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

        var body: some Scene {
                WindowGroup {
                        if #available(macOS 13.0, *) {
                                MacContentView()
                        } else {
                                MacContentView_macOS12()
                        }
                }
                .windowToolbarStyle(.unifiedCompact)
        }
}

#else

@main
struct ContainerApp: App {
        var body: some Scene {
                WindowGroup {
                        IOSContentView()
                }
        }
}

#endif
