#if os(iOS)

import SwiftUI

// For iPhone 15 Pro Max

@available(iOS 17.0, *)
struct SchemeView: View {
        @State private var inputText: String = ""
        var body: some View {
                List {
                        VStack(spacing: 16) {
                                HStack {
                                        Spacer()
                                        Text(verbatim: "粵語拼音")
                                                .lineLimit(1)
                                                .minimumScaleFactor(0.5)
                                                .font(.system(size: 44))
                                                .foregroundStyle(Color.accentColor)
                                        Spacer()
                                }
                                .padding(.vertical)
                                HStack(spacing: 0) {
                                        Spacer()
                                        Text(verbatim: "採用「香港語言學學會粵語")
                                        Spacer()
                                }
                                .font(.system(size: 26))
                                HStack(spacing: 0) {
                                        Spacer()
                                        Text(verbatim: "拼音方案(粵拼/Jyutping)」")
                                        Spacer()
                                }
                                .font(.system(size: 26))
                                HStack(spacing: 0) {
                                        Spacer()
                                        Text(verbatim: "兼容各種習慣拼寫串法")
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
                .listSectionSpacing(.custom(70))

        }
}

@available(iOS 17.0, *)
#Preview {
        SchemeView()
}

#endif
