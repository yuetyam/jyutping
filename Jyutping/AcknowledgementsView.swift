import SwiftUI

struct AcknowledgementsView: View {
        var body: some View {
                ZStack {
                        GlobalBackgroundColor().edgesIgnoringSafeArea(.all)
                        ScrollView {
                                LinkButton(url: URL(string: "https://github.com/ddddxxx/SwiftyOpenCC")!,
                                           content: MessageView(icon: "briefcase",
                                                                text: Text("SwiftyOpenCC"),
                                                                symbol: Image(systemName: "safari")))
                                        .padding(.vertical)
                                        .fillBackground()
                                        .padding()
                                
                                LinkButton(url: URL(string: "https://github.com/rime/rime-cantonese")!,
                                           content: MessageView(icon: "book",
                                                                text: Text("rime-cantonese"),
                                                                symbol: Image(systemName: "safari")))
                                        .padding(.vertical)
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
