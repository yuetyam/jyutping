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
                        MacContentView().background(VisualEffect())
                }
                .windowToolbarStyle(.unifiedCompact)
        }
}

private struct VisualEffect: NSViewRepresentable {
        // https://developer.apple.com/forums/thread/694837
        func makeNSView(context: Self.Context) -> NSView {
                let view = NSVisualEffectView()
                view.state = NSVisualEffectView.State.active
                return view
        }
        func updateNSView(_ nsView: NSView, context: Context) { }
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
