#if os(iOS)

import SwiftUI

@available(iOS 17.0, *)
struct PinyinReverseLookupView15PM: View {
        @State private var inputText: String = ""
        var body: some View {
                List {
                        Section {
                                VStack(spacing: 16) {
                                        HStack {
                                                Spacer()
                                                Text(verbatim: "普通話拼音反查粵拼")
                                                        .lineLimit(1)
                                                        .minimumScaleFactor(0.5)
                                                        .font(.system(size: 50))
                                                Spacer()
                                        }
                                        .padding(.vertical, 30)
                                        HStack(spacing: 0) {
                                                Spacer()
                                                Text(verbatim: "先輸入 ")
                                                        .lineLimit(1)
                                                        .minimumScaleFactor(0.5)
                                                Text(verbatim: "r")
                                                        .monospaced()
                                                        .foregroundStyle(Color.black)
                                                Text(verbatim: " 再輸入普通話拼音")
                                                        .lineLimit(1)
                                                        .minimumScaleFactor(0.5)
                                                Spacer()
                                        }
                                        .font(.title)
                                        HStack(spacing: 0) {
                                                Spacer()
                                                Text(verbatim: "候選詞會提示對應嘅粵拼")
                                                Spacer()
                                        }
                                        .font(.title)
                                }
                                .foregroundStyle(Color.white)
                                .padding(.bottom, 32)
                                .padding(.vertical, 64)
                        }
                        .listRowBackground(Color.green)

                        Section {
                                TextField("Input Text Field", text: $inputText)
                        }
                }
        }
}

@available(iOS 17.0, *)
#Preview {
        PinyinReverseLookupView15PM()
}

#endif
