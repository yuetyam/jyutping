#if os(iOS)

import SwiftUI

@available(iOS 17.0, *)
struct SchemeView15PM: View {
        @State private var inputText: String = ""
        var body: some View {
                List {
                        Section {
                                VStack(spacing: 16) {
                                        HStack {
                                                Spacer()
                                                Text(verbatim: "粵語拼音")
                                                        .lineLimit(1)
                                                        .minimumScaleFactor(0.5)
                                                        .font(.system(size: 50))
                                                Spacer()
                                        }
                                        .padding(.vertical, 26)
                                        HStack(spacing: 0) {
                                                Spacer()
                                                Text(verbatim: "採用「香港語言學學會粵語")
                                                Spacer()
                                        }
                                        HStack(spacing: 0) {
                                                Spacer()
                                                Text(verbatim: "拼音方案(粵拼/Jyutping)」")
                                                Spacer()
                                        }
                                        HStack(spacing: 0) {
                                                Spacer()
                                                Text(verbatim: "兼容各種習慣拼寫串法")
                                                Spacer()
                                        }
                                }
                                .font(.system(size: 26))
                                .foregroundStyle(Color.white)
                                .padding(.bottom, 26)
                                .padding(.vertical, 42)
                        }
                        .listRowBackground(Color.red)

                        Section {
                                TextField("Input Text Field", text: $inputText)
                        }
                }
        }
}

@available(iOS 17.0, *)
#Preview {
        SchemeView15PM()
}

#endif
