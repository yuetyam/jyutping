#if os(iOS)

import SwiftUI

// For iPhone 15 Pro Max

@available(iOS 17.0, *)
struct CangjieReverseLookupView: View {
        @State private var inputText: String = ""
        var body: some View {
                List {
                        VStack(spacing: 16) {
                                HStack {
                                        Spacer()
                                        Text(verbatim: "用倉頡輸入反查粵拼")
                                                .lineLimit(1)
                                                .minimumScaleFactor(0.5)
                                                .font(.system(size: 50))
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
                .listSectionSpacing(.custom(70))

        }
}

#endif

@available(iOS 17.0, *)
#Preview {
        CangjieReverseLookupView()
}
