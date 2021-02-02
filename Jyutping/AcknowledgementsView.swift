import SwiftUI

struct AcknowledgementsView: View {
        var body: some View {
                ZStack {
                        GlobalBackgroundColor().edgesIgnoringSafeArea(.all)
                        ScrollView {
                                LinkView(iconName: "briefcase",
                                         text: Text("SwiftyOpenCC"),
                                         footnote: Text("© 2017 DengXiang. MIT License"),
                                         symbolName: "safari",
                                         url: URL(string: "https://github.com/ddddxxx/SwiftyOpenCC")!)
                                        .fillBackground()
                                        .padding()

                                LinkView(iconName: "book",
                                         text: Text("rime-cantonese"),
                                         footnote: Text("© CanCLID. CC BY 4.0"), // CC: \u{1F16D}, BY: \u{1F16F}, iOS can't display these characters.
                                         symbolName: "safari",
                                         url: URL(string: "https://github.com/rime/rime-cantonese")!)
                                        .fillBackground()
                                        .padding(.horizontal)
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
