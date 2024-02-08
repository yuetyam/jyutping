#if os(iOS)

import SwiftUI

@available(iOS 17.0, *)
struct DarkModeView15PM: View {
        @State private var inputText: String = ""
        var body: some View {
                List {
                        Section {
                                VStack(spacing: 16) {
                                        HStack {
                                                Spacer()
                                                Text(verbatim: "深色模式")
                                                        .lineLimit(1)
                                                        .minimumScaleFactor(0.5)
                                                        .font(.system(size: 50))
                                                        .foregroundStyle(Color.accentColor)
                                                Spacer()
                                        }
                                        .padding(.vertical, 26)
                                        HStack(spacing: 0) {
                                                Spacer()
                                                Text(verbatim: "鍵盤介面乾淨企理")
                                                Spacer()
                                        }
                                        HStack(spacing: 0) {
                                                Spacer()
                                                Text(verbatim: "與系統融爲一體")
                                                Spacer()
                                        }
                                        HStack(spacing: 0) {
                                                Spacer()
                                                Text(verbatim: "渾然天成")
                                                Spacer()
                                        }
                                }
                                .font(.system(size: 26))
                                .padding(.bottom, 26)
                                .padding(.vertical, 42)
                        }

                        Section {
                                TextField("Input Text Field", text: $inputText)
                        }
                }
        }
}

@available(iOS 17.0, *)
#Preview {
        DarkModeView15PM()
}

#endif
