#if os(iOS)

import SwiftUI

@available(iOS 16.0, *)
struct DarkModeView8P: View {
        @State private var inputText: String = ""
        var body: some View {
                List {
                        VStack(spacing: 16) {
                                HStack {
                                        Spacer()
                                        Text(verbatim: "深色模式")
                                                .lineLimit(1)
                                                .minimumScaleFactor(0.5)
                                                .font(.system(size: 44))
                                                .foregroundStyle(Color.accentColor)
                                        Spacer()
                                }
                                .padding(.vertical)
                                HStack(spacing: 0) {
                                        Spacer()
                                        Text(verbatim: "鍵盤介面乾淨企理")
                                        Spacer()
                                }
                                .font(.system(size: 26))
                                HStack(spacing: 0) {
                                        Spacer()
                                        Text(verbatim: "與系統融爲一體")
                                        Spacer()
                                }
                                .font(.system(size: 26))
                                HStack(spacing: 0) {
                                        Spacer()
                                        Text(verbatim: "渾然天成")
                                        Spacer()
                                }
                                .font(.system(size: 26))
                        }
                        .padding(.bottom)
                        .padding(.vertical)

                        Section {
                                TextField("Input Text Field", text: $inputText)
                        }
                }
        }
}

@available(iOS 16.0, *)
#Preview {
        DarkModeView8P()
}

#endif
