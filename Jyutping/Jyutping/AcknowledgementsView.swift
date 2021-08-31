import SwiftUI

@available(iOS 15.0, *)
struct AcknowledgementsView_iOS15: View {
        var body: some View {
                List {
                        Section {
                                LinkSafariView(url: URL(string: "https://github.com/rime/rime-cantonese")!) {
                                        FootnoteLabelView_iOS15(icon: "book", title: Text(verbatim: "Rime Cantonese"), footnote: "© CanCLID. CC BY 4.0")
                                }
                        }
                        Section {
                                LinkSafariView(url: URL(string: "https://github.com/BYVoid/OpenCC")!) {
                                        FootnoteLabelView_iOS15(icon: "briefcase", title: Text(verbatim: "OpenCC"), footnote: "© Carbo Kuo. Apache 2.0")
                                }
                        }
                }
                .navigationTitle("Acknowledgements")
                .navigationBarTitleDisplayMode(.inline)
        }
}


struct AcknowledgementsView: View {
        var body: some View {
                ZStack {
                        if #available(iOS 14.0, *) {
                                GlobalBackgroundColor().ignoresSafeArea()
                        } else {
                                GlobalBackgroundColor().edgesIgnoringSafeArea(.all)
                        }
                        ScrollView {
                                LinkView(iconName: "book",
                                         text: Text("Rime Cantonese"),
                                         footnote: Text("© CanCLID. CC BY 4.0"),
                                         symbolName: "safari",
                                         url: URL(string: "https://github.com/rime/rime-cantonese")!)
                                        .padding(.vertical, 8)
                                        .fillBackground()
                                        .padding()
                                LinkView(iconName: "briefcase",
                                         text: Text("OpenCC"),
                                         footnote: Text("© Carbo Kuo. Apache 2.0"),
                                         symbolName: "safari",
                                         url: URL(string: "https://github.com/BYVoid/OpenCC")!)
                                        .padding(.vertical, 8)
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
