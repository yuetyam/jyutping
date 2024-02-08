#if os(iOS)

import SwiftUI

@available(iOS 17.0, *)
struct CangjieReverseLookupView15PM: View {
        @State private var inputText: String = ""
        var body: some View {
                List {
                        Section {
                                VStack(spacing: 16) {
                                        HStack {
                                                Spacer()
                                                Text(verbatim: "倉頡反查粵拼")
                                                        .lineLimit(1)
                                                        .minimumScaleFactor(0.5)
                                                        .font(.system(size: 50))
                                                Spacer()
                                        }
                                        .padding(.vertical, 26)
                                        HStack(spacing: 0) {
                                                Spacer()
                                                Text(verbatim: "先輸入 ")
                                                Text(verbatim: "v")
                                                        .monospaced()
                                                        .foregroundStyle(Color.black)
                                                Text(verbatim: " 再輸入倉頡碼")
                                                Spacer()
                                        }
                                        .font(.system(size: 31))
                                        HStack(spacing: 0) {
                                                Spacer()
                                                Text(verbatim: "候選詞會提示對應嘅粵拼")
                                                Spacer()
                                        }
                                        .font(.title)
                                }
                                .foregroundStyle(Color.white)
                                .padding(.bottom, 26)
                                .padding(.vertical, 62)
                        }
                        .listRowBackground(Color.orange)

                        Section {
                                TextField("Input Text Field", text: $inputText)
                        }
                }
        }
}

@available(iOS 17.0, *)
#Preview {
        CangjieReverseLookupView15PM()
}

#endif
