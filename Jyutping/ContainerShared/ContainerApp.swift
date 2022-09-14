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
                        MacContentView()
                }
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
