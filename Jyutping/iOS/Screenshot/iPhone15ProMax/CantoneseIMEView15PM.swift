#if os(iOS)

import SwiftUI

@available(iOS 17.0, *)
struct CantoneseIMEView15PM: View {
        @State private var inputText: String = ""
        var body: some View {
                List {
                        // TODO: Re-implement with ZStack
                        VStack(spacing: 16) {
                                HStack {
                                        Spacer()
                                        Text(verbatim: "粵語輸入法")
                                                .lineLimit(1)
                                                .minimumScaleFactor(0.5)
                                                .font(.system(size: 44))
                                                .foregroundStyle(Color.accentColor)
                                        Spacer()
                                }
                                .padding(.vertical, 24)
                                HStack(spacing: 0) {
                                        Spacer()
                                        Text(verbatim: "我手寫我口")
                                        Spacer()
                                }
                                .font(.system(size: 26))
                                HStack(spacing: 0) {
                                        Spacer()
                                        Text(verbatim: "粵語拼音")
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
                .listSectionSpacing(.custom(70))
        }
}

@available(iOS 17.0, *)
#Preview {
        CantoneseIMEView15PM()
}

#endif
