#if os(iOS)

import SwiftUI

@available(iOS 17.0, *)
struct InputField15PM: View {
        @State private var inputText: String = ""
        var body: some View {
                List {
                        Section {
                                Color.clear.frame(height: 366)
                        }
                        Section {
                                TextField("Input Text Field", text: $inputText)
                        }
                }
        }
}

@available(iOS 17.0, *)
#Preview {
        InputField15PM()
}

#endif
