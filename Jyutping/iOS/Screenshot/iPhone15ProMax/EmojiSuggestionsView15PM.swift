#if os(iOS)

import SwiftUI

@available(iOS 17.0, *)
struct EmojiSuggestionsView15PM: View {
        @State private var inputText: String = ""
        var body: some View {
                List {
                        Section {
                                VStack(spacing: 16) {
                                        HStack {
                                                Spacer()
                                                Text(verbatim: "粵語 Emoji")
                                                        .lineLimit(1)
                                                        .minimumScaleFactor(0.5)
                                                        .font(.system(size: 50))
                                                        .foregroundStyle(Color.white)
                                                Spacer()
                                        }
                                        .padding(.vertical, 26)
                                        HStack(spacing: 0) {
                                                Spacer()
                                                Text(verbatim: "更契合粵語嘅 Emoji 建議").foregroundStyle(Color.white)
                                                Spacer()
                                        }
                                        .font(.title)
                                        HStack(spacing: 0) {
                                                Spacer()
                                                Text(verbatim: "輸入 daai cung 即出 🐅").foregroundStyle(Color.white)
                                                Spacer()
                                        }
                                        .font(.title)
                                }
                                .padding(.bottom, 26)
                                .padding(.vertical, 64)
                        }
                        .listRowBackground(Color.cyan)

                        Section {
                                TextField("Input Text Field", text: $inputText)
                        }
                }
        }
}

@available(iOS 17.0, *)
#Preview {
        EmojiSuggestionsView15PM()
}

#endif
