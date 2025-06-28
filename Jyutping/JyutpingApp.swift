import SwiftUI

#if os(macOS)

import AppKit

final class AppDelegate: NSObject, NSApplicationDelegate {
        func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
                return true
        }
        func applicationWillFinishLaunching(_ notification: Notification) {
                NSWindow.allowsAutomaticWindowTabbing = false
        }
        func applicationDidFinishLaunching(_ notification: Notification) {
                _ = NSApp.windows.map({ $0.tabbingMode = .disallowed })
        }
}

@main
struct JyutpingApp: App {

        @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

        var body: some Scene {
                WindowGroup {
                        if #available(macOS 13.0, *) {
                                MacContentView()
                        } else {
                                MacContentViewMonterey()
                        }
                }
                .windowToolbarStyle(.unifiedCompact)
                .commands {
                        CommandGroup(replacing: .appInfo) {
                                Button("MacMenu.App.About", systemImage: "info.circle") {
                                        NotificationCenter.default.post(name: .openAbout, object: nil)
                                }
                        }
                        CommandGroup(replacing: .newItem, addition: {})
                        CommandGroup(after: .windowArrangement) {
                                Button("MacMenu.Window.Search", systemImage: "magnifyingglass") {
                                        NotificationCenter.default.post(name: .focusSearch, object: nil)
                                }
                                .keyboardShortcut("k", modifiers: .command)
                        }
                }
        }
}

extension Notification.Name {
        static let openAbout = Notification.Name("JyutpingApp.Mac.Notification.Name.openAbout")
        static let focusSearch = Notification.Name("JyutpingApp.Mac.Notification.Name.focusSearch")
}

#else

@main
struct JyutpingApp: App {
        var body: some Scene {
                WindowGroup {
                        if #available(iOS 18.0, *) {
                                IOS18ContentView()
                        } else {
                                IOSContentView()
                        }
                }
        }
}

#endif
