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
                                MacContentView_macOS13().background(VisualEffect())
                        } else {
                                MacContentView().background(VisualEffect())
                        }
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
