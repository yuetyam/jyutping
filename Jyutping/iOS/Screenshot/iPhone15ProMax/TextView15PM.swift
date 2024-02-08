#if os(iOS)

import SwiftUI

@available(iOS 17.0, *)
struct TextView15PM: View {
        @State private var inputText: String = ""
        var body: some View {
                ZStack {
                        Color.white.ignoresSafeArea()
                        VStack(alignment: .leading, spacing: 18) {
                                Text(verbatim: "iOS")
                                Text(verbatim: "粵拼輸入法")
                                Text(verbatim: "更新")
                        }
                        .font(.system(size: 60, weight: .semibold))
                }
        }
}

@available(iOS 17.0, *)
#Preview {
        TextView15PM()
}

#endif
