import SwiftUI

struct AcknowledgementsView: View {
        var body: some View {
                ZStack {
                        GlobalBackgroundColor().edgesIgnoringSafeArea(.all)
                        ScrollView {
                                LinkView(iconName: "book",
                                         text: Text("rime-cantonese"),
                                         footnote: Text("© CanCLID. CC BY 4.0"), // CC: \u{1F16D}, BY: \u{1F16F}, iOS can't display these characters.
                                         symbolName: "safari",
                                         url: URL(string: "https://github.com/rime/rime-cantonese")!)
                                        .fillBackground()
                                        .padding()
                                LinkView(iconName: "briefcase",
                                         text: Text("OpenCC"),
                                         footnote: Text("© Carbo Kuo. Apache 2.0"),
                                         symbolName: "safari",
                                         url: URL(string: "https://github.com/BYVoid/OpenCC")!)
                                        .fillBackground()
                                        .padding(.horizontal)
                                LinkView(iconName: "briefcase",
                                         text: Text("BLAKE3"),
                                         footnote: Text("© nixberg. MIT License"),
                                         symbolName: "safari",
                                         url: URL(string: "https://github.com/nixberg/blake3-swift")!)
                                        .fillBackground()
                                        .padding()
                        }
                        .foregroundColor(.primary)
                        .navigationBarTitle(Text("Acknowledgements"), displayMode: .inline)
                }
        }
}

struct AcknowledgementsView_Previews: PreviewProvider {
        static var previews: some View {
                AcknowledgementsView()
        }
}
