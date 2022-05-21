import SwiftUI


#if os(macOS)
import AppKit
class AppDelegate: NSObject, NSApplicationDelegate {
        func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
                return true
        }
}
#endif


@main
struct ContainerApp: App {

        #if os(macOS)
        @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
        #endif

        var body: some Scene {
                WindowGroup {
                        #if os(iOS)
                        IOSContentView()
                        #else
                        MacContentView()
                        #endif
                }
        }
}
