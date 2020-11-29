import SwiftUI

struct JyutpingView: View {
        
        private let placeholdText: String = NSLocalizedString("Search for Jyutping", comment: "")
        
        @State private var inputText: String = String()
        
        private let specials: String = #"abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ_0123456789-:;.,?~!@#$%^&*/\<>{}[]()+=`'"’“•。，；？！、：～（）〈〉《》「」『』〔〕〖〗【】"#
        private var rawCantonese: String { inputText.filter { !specials.contains($0) } }
        private var jyutpings: [String] { JyutpingProvider.search(for: rawCantonese) }
        
        var body: some View {
                NavigationView {
                        ZStack {
                                GlobalBackgroundColor().edgesIgnoringSafeArea(.all)
                                ScrollView {
                                        HStack {
                                                Image(systemName: "magnifyingglass").opacity(0.5).padding(.leading, 8)
                                                EnhancedTextField(placeholder: placeholdText, text: $inputText, returnKey: .search)
                                                        .padding(.vertical, 8)
                                                        .frame(maxHeight: 38)
                                        }
                                        .fillBackground()
                                        .padding()
                                        
                                        if !inputText.isEmpty {
                                                if jyutpings.isEmpty {
                                                        HStack {
                                                                Text("No results.") + Text("\n") + Text("Common Cantonese words only.").font(.footnote)
                                                                Spacer()
                                                        }
                                                        .padding()
                                                        .fillBackground()
                                                        .padding(.horizontal)
                                                        .fixedSize(horizontal: false, vertical: true)
                                                } else {
                                                        VStack {
                                                                HStack {
                                                                        Text(rawCantonese).font(.headline)
                                                                }
                                                                
                                                                ForEach(jyutpings) { jyutping in
                                                                        Divider()
                                                                        HStack {
                                                                                Text(jyutping)
                                                                                        .font(.system(.body, design: .monospaced))
                                                                                        .fixedSize(horizontal: false, vertical: true)
                                                                                Spacer()
                                                                        }.padding(.horizontal)
                                                                }
                                                        }
                                                        .padding(.vertical)
                                                        .fillBackground()
                                                        .padding(.horizontal)
                                                }
                                        }
                                        
                                        JyutpingTable().padding(.top, 30)
                                        
                                        HStack {
                                                Text("Search on other places (websites)").font(.headline)
                                                Spacer()
                                        }
                                        .padding(.horizontal, 16)
                                        .padding(.top, 40)
                                        
                                        SearchWebsitesView()
                                        
                                        HStack {
                                                Text("Jyutping resources").font(.headline)
                                                Spacer()
                                        }
                                        .padding(.horizontal, 16)
                                        .padding(.top, 40)
                                        
                                        JyutpingWebsitesView()
                                                .padding(.bottom, 100)
                                }
                                .foregroundColor(.primary)
                                .navigationBarTitle(Text("Jyutping"))
                        }
                }
                .navigationViewStyle(StackNavigationViewStyle())
        }
}

struct JyutpingView_Previews: PreviewProvider {
        static var previews: some View {
                JyutpingView()
        }
}

extension String: Identifiable {
        public var id: UUID {
                return UUID()
        }
}

private struct JyutpingTable: View {
        var body: some View {
                VStack {
                        NavigationLink(destination: InitialsTable()) {
                                HStack {
                                        Text("Jyutping Initials")
                                        Spacer()
                                        Image(systemName: "chevron.right").opacity(0.5)
                                }
                                .padding(.top)
                                .padding(.horizontal)
                        }
                        Divider()
                        NavigationLink(destination: FinalsTable()) {
                                HStack {
                                        Text("Jyutping Finals")
                                        Spacer()
                                        Image(systemName: "chevron.right").opacity(0.5)
                                }
                                .padding(.horizontal)
                        }
                        Divider()
                        NavigationLink(destination: TonesTable()) {
                                HStack {
                                        Text("Jyutping Tones")
                                        Spacer()
                                        Image(systemName: "chevron.right").opacity(0.5)
                                }
                                .padding(.horizontal)
                                .padding(.bottom)
                        }
                }
                .fillBackground()
                .padding()
        }
}

struct SearchWebsitesView: View {
        var body: some View {
                VStack {
                        LinkButton(url: URL(string: "https://jyut.net")!,
                                   content: MessageView(icon: "doc.text.magnifyingglass",
                                                        text: Text("粵音資料集叢"),
                                                        symbol: Image(systemName: "safari")))
                                .padding(.vertical)
                                .fillBackground()
                                .padding(.horizontal)
                        
                        LinkButton(url: URL(string: "https://words.hk")!,
                                   content: MessageView(icon: "doc.text.magnifyingglass",
                                                        text: Text("粵典"),
                                                        symbol: Image(systemName: "safari")))
                                .padding(.vertical)
                                .fillBackground()
                                .padding(.horizontal)
                        
                        LinkButton(url: URL(string: "https://humanum.arts.cuhk.edu.hk/Lexis/lexi-can")!,
                                   content: MessageView(icon: "doc.text.magnifyingglass",
                                                        text: Text("粵語審音配詞字庫"),
                                                        symbol: Image(systemName: "safari")))
                                .padding(.vertical)
                                .fillBackground()
                                .padding(.horizontal)
                        
                        LinkButton(url: URL(string: "https://www.jyutdict.org")!,
                                   content: MessageView(icon: "doc.text.magnifyingglass",
                                                        text: Text("泛粵大典"),
                                                        symbol: Image(systemName: "safari")))
                                .padding(.vertical)
                                .fillBackground()
                                .padding(.horizontal)
                        
                        LinkButton(url: URL(string: "https://shyyp.net/hant")!,
                                   content: MessageView(icon: "doc.text.magnifyingglass",
                                                        text: Text("羊羊粵語"),
                                                        symbol: Image(systemName: "safari")))
                                .padding(.vertical)
                                .fillBackground()
                                .padding(.horizontal)
                }
        }
}

struct JyutpingWebsitesView: View {
        var body: some View {
                VStack {
                        LinkButton(url: URL(string: "https://www.jyutping.org")!,
                                   content: MessageView(icon: "link.circle",
                                                        text: Text("粵拼 jyutping.org"),
                                                        symbol: Image(systemName: "safari")))
                                .padding(.vertical)
                                .fillBackground()
                                .padding(.horizontal)
                        
                        LinkButton(url: URL(string: "https://www.lshk.org/jyutping")!,
                                   content: MessageView(icon: "link.circle",
                                                        text: Text("LSHK Jyutping 粵拼"),
                                                        symbol: Image(systemName: "safari")))
                                .padding(.vertical)
                                .fillBackground()
                                .padding(.horizontal)
                        
                        LinkButton(url: URL(string: "https://www.youtube.com/channel/UCcmAegX-cgcOOconZIwqynw")!,
                                   content: MessageView(icon: "link.circle",
                                                        text: Text("粵拼教學 - YouTube"),
                                                        symbol: Image(systemName: "safari")))
                                .padding(.vertical)
                                .fillBackground()
                                .padding(.horizontal)
                        
                        LinkButton(url: URL(string: "http://www.iso10646hk.net/jp")!,
                                   content: MessageView(icon: "link.circle",
                                                        text: Text("粵拼 - iso10646hk.net"),
                                                        symbol: Image(systemName: "safari")))
                                .padding(.vertical)
                                .fillBackground()
                                .padding(.horizontal)
                        
                        LinkButton(url: URL(string: "https://www.jyut6.com")!,
                                   content: MessageView(icon: "link.circle",
                                                        text: Text("粵拼歌詞網"),
                                                        symbol: Image(systemName: "safari")))
                                .padding(.vertical)
                                .fillBackground()
                                .padding(.horizontal)
                }
        }
}
