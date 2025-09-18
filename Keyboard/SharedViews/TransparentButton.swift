import SwiftUI

struct TransparentButton: View {
        let width: CGFloat
        let height: CGFloat
        let action: () -> Void
        var body: some View {
                Button(action: action) {
                        Color.interactiveClear.frame(width: width, height: height)
                }
                .buttonStyle(.plain)
        }
}
