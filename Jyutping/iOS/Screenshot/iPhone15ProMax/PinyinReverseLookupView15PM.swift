#if os(iOS)

import SwiftUI

@available(iOS 17.0, *)
struct PinyinReverseLookupView15PM: View {
        @State private var inputText: String = ""
        var body: some View {
                List {
                        VStack(spacing: 16) {
                                HStack {
                                        Spacer()
                                        Text(verbatim: "普通話拼音反查粵拼")
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
                                        Text(verbatim: "r")
                                                .font(.system(size: 30, design: .monospaced))
                                                .foregroundStyle(Color.accentColor)
                                        Text(verbatim: " 再輸入普通話拼音")
                                        Spacer()
                                }
                                .font(.system(size: 26))
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

@available(iOS 17.0, *)
#Preview {
        PinyinReverseLookupView15PM()
}

#endif
