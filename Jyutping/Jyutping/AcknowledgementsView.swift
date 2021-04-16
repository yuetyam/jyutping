import SwiftUI

struct AcknowledgementsView: View {
        var body: some View {
                ZStack {
                        GlobalBackgroundColor().edgesIgnoringSafeArea(.all)
                        ScrollView {
                                LinkView(iconName: "book",
                                         text: Text("Rime Cantonese"),
                                         footnote: Text("© CanCLID. CC BY 4.0"),
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
                                LinkView(iconName: "textformat",
                                         text: Text("Source Han Sans"),
                                         footnote: Text("© Adobe. OFL 1.1"),
                                         symbolName: "safari",
                                         url: URL(string: "https://github.com/adobe-fonts/source-han-sans")!)
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
