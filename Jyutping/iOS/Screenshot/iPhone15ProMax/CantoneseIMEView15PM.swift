#if os(iOS)

import SwiftUI

@available(iOS 17.0, *)
struct CantoneseIMEView15PM: View {
        @State private var inputText: String = ""
        var body: some View {
                List {
                        Section {
                                VStack(spacing: 16) {
                                        HStack {
                                                Spacer()
                                                Text(verbatim: "粵語輸入法")
                                                        .lineLimit(1)
                                                        .minimumScaleFactor(0.5)
                                                        .font(.system(size: 50))
                                                Spacer()
                                        }
                                        .padding(.vertical, 26)
                                        HStack(spacing: 0) {
                                                Spacer()
                                                Text(verbatim: "我手寫我口")
                                                Spacer()
                                        }
                                        .font(.title)
                                        HStack(spacing: 0) {
                                                Spacer()
                                                Text(verbatim: "粵語拼音")
                                                Spacer()
                                        }
                                        .font(.title)
                                }
                                .foregroundStyle(Color.white)
                                .padding(.bottom, 26)
                                .padding(.vertical, 64)
                        }
                        .listRowBackground(Color.accentColor)

                        Section {
                                TextField("Input Text Field", text: $inputText)
                        }
                }
        }
}

@available(iOS 17.0, *)
#Preview {
        CantoneseIMEView15PM()
}

#endif
