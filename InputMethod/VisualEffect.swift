import SwiftUI

struct VisualEffectView: NSViewRepresentable {
        func makeNSView(context: Self.Context) -> NSView {
                let view = NSVisualEffectView()
                view.material = .sidebar
                view.blendingMode = .behindWindow
                view.state = .active
                return view
        }
        func updateNSView(_ nsView: NSView, context: Context) { }
}

struct HUDVisualEffect: NSViewRepresentable {
        func makeNSView(context: Self.Context) -> NSView {
                let view = NSVisualEffectView()
                view.material = .hudWindow
                view.blendingMode = .behindWindow
                view.state = .active
                return view
        }
        func updateNSView(_ nsView: NSView, context: Context) { }
}

extension View {
        func applyVisualEffect() -> some View {
                return background(VisualEffectView())
        }
        /*
        func hudVisualEffect() -> some View {
                return background(HUDVisualEffect())
        }
        func roundedVisualEffect() -> some View {
                return background(
                        VisualEffectView()
                                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                                .shadow(radius: 3)
                )
        }
        */
        func roundedHUDVisualEffect() -> some View {
                return background(
                        HUDVisualEffect()
                                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                                .shadow(radius: 3)
                )
        }
}
