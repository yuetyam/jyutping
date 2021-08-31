import SwiftUI
import AVFoundation
import JyutpingProvider

@available(iOS 15.0, *)
struct JyutpingView_iOS15: View {

        private let placeholder: String = NSLocalizedString("Lookup Jyutping for Cantonese", comment: "")
        @State private var inputText: String = ""

        private var rawCantonese: String { inputText.filter({ !($0.isASCII || $0.isPunctuation || $0.isWhitespace) }) }
        private var jyutpings: [String] { JyutpingProvider.search(for: rawCantonese) }

        private let synthesizer: AVSpeechSynthesizer = AVSpeechSynthesizer()
        private func speak(_ text: String) {
                let utterance: AVSpeechUtterance = AVSpeechUtterance(string: text)
                utterance.voice = AVSpeechSynthesisVoice(language: "zh-HK")
                synthesizer.speak(utterance)
        }

        var body: some View {
                NavigationView {
                        List {
                                Section {
                                        HStack {
                                                Image(systemName: "magnifyingglass").opacity(0.5)
                                                EnhancedTextField(placeholder: placeholder,
                                                                  text: $inputText,
                                                                  returnKey: .search,
                                                                  autocorrection: .no,
                                                                  autocapitalization: UITextAutocapitalizationType.none)
                                        }
                                }
                                if (!inputText.isEmpty) && (jyutpings.isEmpty) {
                                        VStack(spacing: 8) {
                                                HStack {
                                                        Text("No Results.")
                                                        Spacer()
                                                }
                                                HStack {
                                                        Text("Common Cantonese words only.")
                                                                .font(.footnote)
                                                                .foregroundColor(.secondary)
                                                        Spacer()
                                                }
                                        }
                                } else if !inputText.isEmpty {
                                        Section {
                                                HStack {
                                                        Text(verbatim: rawCantonese)
                                                        Spacer()
                                                        Button(action: {
                                                                speak(rawCantonese)
                                                        }) {
                                                                Image(systemName: "speaker.wave.2")
                                                        }
                                                }
                                                ForEach(jyutpings) { jyutping in
                                                        HStack {
                                                                Text(verbatim: jyutping).font(.system(.body, design: .monospaced))
                                                                Spacer()
                                                                Button(action: {
                                                                        speak(jyutping)
                                                                }) {
                                                                        Image(systemName: "speaker.wave.2")
                                                                }
                                                        }
                                                }
                                        }
                                        .textSelection(.enabled)
                                }
                                Section {
                                        NavigationLink(destination: InitialsTable()) {
                                                Label("Jyutping Initials", systemImage: "tablecells")
                                        }
                                        NavigationLink(destination: FinalsTable()) {
                                                Label("Jyutping Finals", systemImage: "tablecells")
                                        }
                                        NavigationLink(destination: TonesTable()) {
                                                Label("Jyutping Tones", systemImage: "tablecells")
                                        }
                                }
                                .labelStyle(.titleOnly)
                                Section {
                                        LinkSafariView(url: URL(string: "https://jyut.net")!) {
                                                FootnoteLabelView_iOS15(icon: "doc.text.magnifyingglass", title: Text(verbatim: "粵音資料集叢"), footnote: "jyut.net")
                                        }
                                        LinkSafariView(url: URL(string: "https://words.hk")!) {
                                                FootnoteLabelView_iOS15(icon: "doc.text.magnifyingglass", title: Text(verbatim: "粵典"), footnote: "words.hk")
                                        }
                                        LinkSafariView(url: URL(string: "https://humanum.arts.cuhk.edu.hk/Lexis/lexi-can")!) {
                                                FootnoteLabelView_iOS15(icon: "doc.text.magnifyingglass", title: Text(verbatim: "粵語審音配詞字庫"), footnote: "humanum.arts.cuhk.edu.hk/Lexis/lexi-can")
                                        }
                                        LinkSafariView(url: URL(string: "https://www.jyutdict.org")!) {
                                                FootnoteLabelView_iOS15(icon: "doc.text.magnifyingglass", title: Text(verbatim: "泛粵大典"), footnote: "www.jyutdict.org")
                                        }
                                        LinkSafariView(url: URL(string: "https://shyyp.net/hant")!) {
                                                FootnoteLabelView_iOS15(icon: "doc.text.magnifyingglass", title: Text(verbatim: "羊羊粵語"), footnote: "shyyp.net/hant")
                                        }
                                } header: {
                                        Text("Search on other places (websites)")
                                }
                                Section {
                                        LinkSafariView(url: URL(string: "https://www.jyutping.org")!) {
                                                FootnoteLabelView_iOS15(title: Text("Jyutping"), footnote: "www.jyutping.org")
                                        }
                                        LinkSafariView(url: URL(string: "https://www.lshk.org/jyutping")!) {
                                                FootnoteLabelView_iOS15(title: Text("Jyutping - LSHK"), footnote: "www.lshk.org/jyutping")
                                        }
                                        LinkSafariView(url: URL(string: "https://www.youtube.com/channel/UCcmAegX-cgcOOconZIwqynw")!) {
                                                FootnoteLabelView_iOS15(title: Text("Learn Jyutping"), footnote: "www.youtube.com/channel/UCcmAegX-cgcOOconZIwqynw")
                                        }
                                } header: {
                                        Text("Jyutping Resources")
                                }
                                Section {
                                        LinkSafariView(url: URL(string: "https://resonate.hk")!) {
                                                FootnoteLabelView_iOS15(title: Text(verbatim: "迴響"), footnote: "resonate.hk")
                                        }
                                        LinkSafariView(url: URL(string: "https://hambaanglaang.hk")!) {
                                                FootnoteLabelView_iOS15(title: Text(verbatim: "冚唪唥粵文"), footnote: "hambaanglaang.hk")
                                        }
                                        LinkSafariView(url: URL(string: "https://www.hok6.com")!) {
                                                FootnoteLabelView_iOS15(title: Text(verbatim: "學識 Hok6"), footnote: "www.hok6.com")
                                        }
                                } header: {
                                        Text("Cantonese Resources")
                                }
                        }
                        .navigationTitle("Jyutping")
                }
                .navigationViewStyle(.stack)
        }
}


struct JyutpingView: View {

        private let placeholder: String = NSLocalizedString("Lookup Jyutping for Cantonese", comment: "")
        @State private var inputText: String = String()

        private var rawCantonese: String { inputText.filter({ !($0.isASCII || $0.isPunctuation || $0.isWhitespace) }) }
        private var jyutpings: [String] { JyutpingProvider.search(for: rawCantonese) }

        var body: some View {
                NavigationView {
                        ZStack {
                                if #available(iOS 14.0, *) {
                                        GlobalBackgroundColor().ignoresSafeArea()
                                } else {
                                        GlobalBackgroundColor().edgesIgnoringSafeArea(.all)
                                }
                                ScrollView {
                                        HStack {
                                                Image(systemName: "magnifyingglass").opacity(0.5)
                                                EnhancedTextField(placeholder: placeholder,
                                                                  text: $inputText,
                                                                  returnKey: .search,
                                                                  autocorrection: .no,
                                                                  autocapitalization: UITextAutocapitalizationType.none)
                                                        .padding(.vertical, 10)
                                        }
                                        .padding(.horizontal, 8)
                                        .fillBackground(cornerRadius: 8)
                                        .padding()

                                        if !inputText.isEmpty {
                                                if jyutpings.isEmpty {
                                                        VStack(spacing: 8) {
                                                                HStack {
                                                                        Text("No Results.")
                                                                        Spacer()
                                                                }
                                                                HStack {
                                                                        Text("Common Cantonese words only.")
                                                                                .font(.footnote)
                                                                                .foregroundColor(.secondary)
                                                                        Spacer()
                                                                }
                                                        }
                                                        .padding()
                                                        .fillBackground()
                                                        .padding(.horizontal)
                                                } else {
                                                        VStack {
                                                                HStack {
                                                                        Text(verbatim: rawCantonese).font(.headline)
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
                                                                                Text(verbatim: jyutping)
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
                                                Text("Jyutping Resources").font(.headline)
                                                Spacer()
                                        }
                                        .padding(.horizontal, 16)
                                        .padding(.top, 40)
                                        
                                        JyutpingWebsitesView()

                                        HStack {
                                                Text("Cantonese Resources").font(.headline)
                                                Spacer()
                                        }
                                        .padding(.horizontal, 16)
                                        .padding(.top, 40)

                                        CantoneseResourcesView()
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
        private let speakerImageName: String = {
                if #available(iOS 14, *) {
                        return "speaker.wave.2"
                } else {
                        return "speaker.2"
                }
        }()
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

private struct SearchWebsitesView: View {
        var body: some View {
                VStack {
                        LinkView(iconName: "doc.text.magnifyingglass",
                                 text: Text(verbatim: "粵音資料集叢"),
                                 footnote: Text(verbatim: "jyut.net"),
                                 symbolName: "safari",
                                 url: URL(string: "https://jyut.net")!)
                        Divider()
                        LinkView(iconName: "doc.text.magnifyingglass",
                                 text: Text(verbatim: "粵典"),
                                 footnote: Text(verbatim: "words.hk"),
                                 symbolName: "safari",
                                 url: URL(string: "https://words.hk")!)
                        Divider()
                        LinkView(iconName: "doc.text.magnifyingglass",
                                 text: Text(verbatim: "粵語審音配詞字庫"),
                                 footnote: Text(verbatim: "humanum.arts.cuhk.edu.hk/Lexis/lexi-can"),
                                 symbolName: "safari",
                                 url: URL(string: "https://humanum.arts.cuhk.edu.hk/Lexis/lexi-can")!)
                        Divider()
                        LinkView(iconName: "doc.text.magnifyingglass",
                                 text: Text(verbatim: "泛粵大典"),
                                 footnote: Text(verbatim: "www.jyutdict.org"),
                                 symbolName: "safari",
                                 url: URL(string: "https://www.jyutdict.org")!)
                        Divider()
                        LinkView(iconName: "doc.text.magnifyingglass",
                                 text: Text(verbatim: "羊羊粵語"),
                                 footnote: Text(verbatim: "shyyp.net/hant"),
                                 symbolName: "safari",
                                 url: URL(string: "https://shyyp.net/hant")!)
                }
                .padding(.vertical)
                .fillBackground()
                .padding(.horizontal)
        }
}

private struct JyutpingWebsitesView: View {
        var body: some View {
                VStack {
                        LinkView(iconName: "link.circle",
                                 text: Text("Jyutping"),
                                 footnote: Text(verbatim: "www.jyutping.org"),
                                 symbolName: "safari",
                                 url: URL(string: "https://www.jyutping.org")!)
                        Divider()
                        LinkView(iconName: "link.circle",
                                 text: Text("Jyutping - LSHK"),
                                 footnote: Text(verbatim: "www.lshk.org/jyutping"),
                                 symbolName: "safari",
                                 url: URL(string: "https://www.lshk.org/jyutping")!)
                        Divider()
                        LinkView(iconName: "link.circle",
                                 text: Text("Learn Jyutping"),
                                 footnote: Text(verbatim: "www.youtube.com/channel/UCcmAegX-cgcOOconZIwqynw"),
                                 symbolName: "safari",
                                 url: URL(string: "https://www.youtube.com/channel/UCcmAegX-cgcOOconZIwqynw")!)
                }
                .padding(.vertical)
                .fillBackground()
                .padding(.horizontal)
        }
}

private struct CantoneseResourcesView: View {
        var body: some View {
                VStack {
                        LinkView(iconName: "link.circle",
                                 text: Text("迴響"),
                                 footnote: Text(verbatim: "resonate.hk"),
                                 symbolName: "safari",
                                 url: URL(string: "https://resonate.hk")!)
                        Divider()
                        LinkView(iconName: "link.circle",
                                 text: Text("冚唪唥粵文"),
                                 footnote: Text(verbatim: "hambaanglaang.hk"),
                                 symbolName: "safari",
                                 url: URL(string: "https://hambaanglaang.hk")!)
                        Divider()
                        LinkView(iconName: "link.circle",
                                 text: Text("學識 Hok6"),
                                 footnote: Text(verbatim: "www.hok6.com"),
                                 symbolName: "safari",
                                 url: URL(string: "https://www.hok6.com")!)
                }
                .padding(.vertical)
                .fillBackground()
                .padding(.horizontal)
        }
}
