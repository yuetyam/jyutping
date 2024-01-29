#if os(iOS)

import SwiftUI

@available(iOS 16.0, *)
struct CangjieReverseLookupView8P: View {
        @State private var inputText: String = ""
        var body: some View {
                List {
                        VStack(spacing: 16) {
                                HStack {
                                        Spacer()
                                        Text(verbatim: "倉頡反查粵拼")
                                                .lineLimit(1)
                                                .minimumScaleFactor(0.5)
                                                .font(.system(size: 44))
                                                .foregroundStyle(Color.accentColor)
                                        Spacer()
                                }
                                .padding(.vertical, 24)
                                HStack(spacing: 0) {
                                        Spacer()
                                        Text(verbatim: "先輸入 ")
                                        Text(verbatim: "v")
                                                .font(.system(size: 30, design: .monospaced))
                                                .foregroundStyle(Color.accentColor)
                                        Text(verbatim: "   再輸入倉頡碼")
                                        Spacer()
                                }
                                .font(.system(size: 27))
                                HStack(spacing: 0) {
                                        Spacer()
                                        Text(verbatim: "候選詞會提示對應嘅粵拼")
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
        CangjieReverseLookupView8P()
}

#endif
