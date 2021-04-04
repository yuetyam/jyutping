import SwiftUI
import AVFoundation
import JyutpingProvider

struct JyutpingView: View {

        private let placeholder: String = NSLocalizedString("Search for Jyutping", comment: "")
        @State private var inputText: String = String()

        private let specials: String =  #"。，；？！、：～`’“（）〈〉《》「」『』〔〕〖〗【】⋯•"#
        private var rawCantonese: String { inputText.filter { !$0.isASCII && !specials.contains($0) } }
        private var jyutpings: [String] { JyutpingProvider.search(for: rawCantonese) }

        private let speakerImageName: String = {
                if #available(iOS 14, *) {
                        return "speaker.wave.2"
                } else {
                        return "speaker.2"
                }
        }()

        var body: some View {
                NavigationView {
                        ZStack {
                                GlobalBackgroundColor().edgesIgnoringSafeArea(.all)
                                ScrollView {
                                        HStack {
                                                Image(systemName: "magnifyingglass").opacity(0.5).padding(.leading, 8)
                                                EnhancedTextField(placeholder: placeholder, text: $inputText, returnKey: .search)
                                                        .padding(.vertical, 10)
                                                        .frame(maxHeight: 42)
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
                                                } else {
                                                        VStack {
                                                                HStack {
                                                                        Text(rawCantonese).font(.headline)
                                                                        Spacer()
                                                                        Button(action: {
                                                                                speak(rawCantonese)
                                                                        }) {
                                                                                Image(systemName: speakerImageName)
                                                                        }
                                                                        .foregroundColor(.blue)
                                                                }
                                                                .padding(.horizontal)
                                                                
                                                                ForEach(jyutpings) { jyutping in
                                                                        Divider()
                                                                        HStack {
                                                                                Text(jyutping)
                                                                                        .font(.system(.body, design: .monospaced))
                                                                                        .fixedSize(horizontal: false, vertical: true)
                                                                                Spacer()
                                                                                Button(action: {
                                                                                        speak(jyutping)
                                                                                }) {
                                                                                        Image(systemName: speakerImageName)
                                                                                }
                                                                                .foregroundColor(.blue)
                                                                        }
                                                                        .padding(.horizontal)
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
        
        private let synthesizer: AVSpeechSynthesizer = AVSpeechSynthesizer()
        private func speak(_ text: String) {
                let utterance: AVSpeechUtterance = AVSpeechUtterance(string: text)
                utterance.voice = AVSpeechSynthesisVoice(language: "zh-HK")
                synthesizer.speak(utterance)
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
                        LinkView(iconName: "doc.text.magnifyingglass",
                                 text: Text("粵音資料集叢"),
                                 footnote: Text("jyut.net"),
                                 symbolName: "safari",
                                 url: URL(string: "https://jyut.net")!)
                                .fillBackground()
                                .padding(.horizontal)

                        LinkView(iconName: "doc.text.magnifyingglass",
                                 text: Text("粵典"),
                                 footnote: Text("words.hk"),
                                 symbolName: "safari",
                                 url: URL(string: "https://words.hk")!)
                                .fillBackground()
                                .padding(.horizontal)

                        LinkView(iconName: "doc.text.magnifyingglass",
                                 text: Text("粵語審音配詞字庫"),
                                 footnote: Text("humanum.arts.cuhk.edu.hk/Lexis/lexi-can"),
                                 symbolName: "safari",
                                 url: URL(string: "https://humanum.arts.cuhk.edu.hk/Lexis/lexi-can")!)
                                .fillBackground()
                                .padding(.horizontal)

                        LinkView(iconName: "doc.text.magnifyingglass",
                                 text: Text("泛粵大典"),
                                 footnote: Text("www.jyutdict.org"),
                                 symbolName: "safari",
                                 url: URL(string: "https://www.jyutdict.org")!)
                                .fillBackground()
                                .padding(.horizontal)

                        LinkView(iconName: "doc.text.magnifyingglass",
                                 text: Text("羊羊粵語"),
                                 footnote: Text("shyyp.net/hant"),
                                 symbolName: "safari",
                                 url: URL(string: "https://shyyp.net/hant")!)
                                .fillBackground()
                                .padding(.horizontal)
                }
        }
}

struct JyutpingWebsitesView: View {
        var body: some View {
                VStack {
                        LinkView(iconName: "link.circle",
                                 text: Text("Jyutping"),
                                 footnote: Text("www.jyutping.org"),
                                 symbolName: "safari",
                                 url: URL(string: "https://www.jyutping.org")!)
                                .fillBackground()
                                .padding(.horizontal)

                        LinkView(iconName: "link.circle",
                                 text: Text("Jyutping - LSHK"),
                                 footnote: Text("www.lshk.org/jyutping"),
                                 symbolName: "safari",
                                 url: URL(string: "https://www.lshk.org/jyutping")!)
                                .fillBackground()
                                .padding(.horizontal)

                        LinkView(iconName: "link.circle",
                                 text: Text("Learn Jyutping"),
                                 footnote: Text("www.youtube.com/channel/UCcmAegX-cgcOOconZIwqynw"),
                                 symbolName: "safari",
                                 url: URL(string: "https://www.youtube.com/channel/UCcmAegX-cgcOOconZIwqynw")!)
                                .fillBackground()
                                .padding(.horizontal)

                        LinkView(iconName: "link.circle",
                                 text: Text("Jyutping"),
                                 footnote: Text("www.iso10646hk.net/jp"),
                                 symbolName: "safari",
                                 url: URL(string: "https://www.iso10646hk.net/jp")!)
                                .fillBackground()
                                .padding(.horizontal)
                }
        }
}
