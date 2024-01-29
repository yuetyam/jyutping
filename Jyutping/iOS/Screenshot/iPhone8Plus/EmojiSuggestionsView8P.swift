#if os(iOS)

import SwiftUI

@available(iOS 16.0, *)
struct EmojiSuggestionsView8P: View {
        @State private var inputText: String = ""
        var body: some View {
                List {
                        VStack(spacing: 16) {
                                HStack {
                                        Spacer()
                                        Text(verbatim: "粵語 Emoji")
                                                .lineLimit(1)
                                                .minimumScaleFactor(0.5)
                                                .font(.system(size: 44))
                                                .foregroundStyle(Color.accentColor)
                                        Spacer()
                                }
                                .padding(.vertical, 24)
                                HStack(spacing: 0) {
                                        Spacer()
                                        Text(verbatim: "更符合粵語嘅 Emoji 建議")
                                        Spacer()
                                }
                                .font(.system(size: 26))
                                HStack(spacing: 0) {
                                        Spacer()
                                        Text(verbatim: "輸入 daai cung 即出 🐅")
                                        Spacer()
                                }
                                .font(.system(size: 26))
                        }
                        .padding(.bottom, 28)
                        .padding(.vertical, 24)

                        Section {
                                TextField("Input Text Field", text: $inputText)
                        }
                }
        }
}

@available(iOS 16.0, *)
#Preview {
        EmojiSuggestionsView8P()
}

#endif
