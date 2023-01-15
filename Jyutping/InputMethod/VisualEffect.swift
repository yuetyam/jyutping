import SwiftUI

struct VisualEffect: NSViewRepresentable {
        // https://developer.apple.com/forums/thread/694837
        func makeNSView(context: Self.Context) -> NSView {
                let view = NSVisualEffectView()
                view.state = NSVisualEffectView.State.active
                return view
        }
        func updateNSView(_ nsView: NSView, context: Context) { }
}

extension View {
        func visualEffect() -> some View {
                return self.background(VisualEffect())
        }
        func roundedVisualEffect() -> some View {
                return self.background(
                        VisualEffect()
                                .cornerRadius(8)
                                .shadow(radius: 4)
                )
        }
}
