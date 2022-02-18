import SwiftUI

struct SettingsView: View {

        @State var shapeSelection: Int = 0
        @State var punctuationSelection: Int = 0
        @State var emojiStateSelection: Int = 0

        var body: some View {
                VStack {
                        HStack {
                                Text(verbatim: "1.").font(.serialNumber)
                                Text(verbatim: "退出").font(.candidate)
                                Spacer()
                        }
                        HStack {
                                Text(verbatim: "2.").font(.serialNumber)
                                Text(verbatim: "傳統漢字").font(.candidate)
                                Spacer()
                                Image(systemName: "checkmark").font(.title3).foregroundColor(.blue)
                        }
                        HStack {
                                Text(verbatim: "3.").font(.serialNumber)
                                Text(verbatim: "傳統漢字・香港").font(.candidate)
                                Spacer()
                        }
                        HStack {
                                Text(verbatim: "4.").font(.serialNumber)
                                Text(verbatim: "傳統漢字・臺灣").font(.candidate)
                                Spacer()
                        }
                        HStack {
                                Text(verbatim: "5.").font(.serialNumber)
                                Text(verbatim: "简化字").font(.candidate)
                                Spacer()
                        }
                        HStack {
                                Text(verbatim: "6.").font(.serialNumber)
                                Picker("Shape", selection: $shapeSelection) {
                                        Text(verbatim: "半形數字").tag(0)
                                        Text(verbatim: "全形數字").tag(1)
                                }
                                .labelsHidden()
                                .pickerStyle(.segmented)
                                Spacer()
                        }
                        HStack {
                                Text(verbatim: "7.").font(.serialNumber)
                                Picker("Punctuation", selection: $punctuationSelection) {
                                        Text(verbatim: "粵文句讀。").tag(0)
                                        Text(verbatim: "英文標點 .").tag(1)
                                }
                                .labelsHidden()
                                .pickerStyle(.segmented)
                                Spacer()
                        }
                }
                .padding()
                .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
        }
}
