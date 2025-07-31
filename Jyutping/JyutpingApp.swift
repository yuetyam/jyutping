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
                NSApp.windows.forEach { window in
                        window.tabbingMode = .disallowed
                        window.titlebarAppearsTransparent = true
                }
        }
}

struct VisualEffectView: NSViewRepresentable {
        func makeNSView(context: Self.Context) -> NSView {
                let view = NSVisualEffectView()
                view.material = .hudWindow
                view.blendingMode = .behindWindow
                view.state = .active
                return view
        }
        func updateNSView(_ nsView: NSView, context: Context) { }
}

@main
struct JyutpingApp: App {

        @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

        var body: some Scene {
                WindowGroup {
                        if #available(macOS 15.0, *) {
                                MacContentView().containerBackground(for: .window) { VisualEffectView() }
                        } else if #available(macOS 13.0, *) {
                                MacContentView().background(VisualEffectView())
                        } else {
                                MacContentViewMonterey().background(VisualEffectView())
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
