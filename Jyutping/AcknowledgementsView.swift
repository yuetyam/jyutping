import SwiftUI

struct AcknowledgementsView: View {
        var body: some View {
                ScrollView {
                        LinkButton(url: URL(string: "https://github.com/danielsaidi/KeyboardKit")!,
                                   content: MessageView(icon: "briefcase",
                                                        text: Text("KeyboardKit"),
                                                        symbol: Image(systemName: "safari")))
                                .padding(.vertical)
                                .overlay(RoundedRectangle(cornerRadius: 7).stroke(Color.secondary))
                                .padding()
                        
                        LinkButton(url: URL(string: "https://github.com/stephencelis/SQLite.swift")!,
                                   content: MessageView(icon: "briefcase",
                                                        text: Text("SQLite.swift"),
                                                        symbol: Image(systemName: "safari")))
                                .padding(.vertical)
                                .overlay(RoundedRectangle(cornerRadius: 7).stroke(Color.secondary))
                                .padding(.horizontal)
                        
                        LinkButton(url: URL(string: "https://github.com/rime/rime-cantonese")!,
                                   content: MessageView(icon: "book",
                                                        text: Text("rime-cantonese"),
                                                        symbol: Image(systemName: "safari")))
                                .padding(.vertical)
                                .overlay(RoundedRectangle(cornerRadius: 7).stroke(Color.secondary))
                                .padding()
                        
                }
                .foregroundColor(.primary)
                .navigationBarTitle(Text("Acknowledgements"), displayMode: .inline)
        }
}

struct AcknowledgementsView_Previews: PreviewProvider {
        static var previews: some View {
                AcknowledgementsView()
        }
}
