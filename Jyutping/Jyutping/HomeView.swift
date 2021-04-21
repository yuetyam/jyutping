import SwiftUI

struct HomeView: View {

        private let placeholder: String = NSLocalizedString("Type here to test keyboards", comment: "")
        @State private var cacheText: String = ""

        /*
        private var isJyutpingKeyboardEnabled: Bool {
                guard let keyboards: [String] = UserDefaults.standard.object(forKey: "AppleKeyboards") as? [String] else { return false }
                return keyboards.contains("im.cantonese.CantoneseIM.Keyboard")
        }
        */

        var body: some View {
                NavigationView {
                        ZStack {
                                GlobalBackgroundColor().edgesIgnoringSafeArea(.all)
                                ScrollView {
                                        EnhancedTextField(placeholder: placeholder, text: $cacheText)
                                                .padding(10)
                                                .fillBackground()
                                                .padding()
                                        /*
                                        if !isJyutpingKeyboardEnabled {
                                                GuideView()
                                        }
                                        */
                                        GuideView()

                                        TonesInput().padding(.top)
                                        CangjieReverseLookup()
                                        PinyinReverseLookup()
                                        PeriodShortcut().padding(.bottom, 50)
                                }
                                .navigationBarTitle(Text("Home"))
                        }
                }
                .navigationViewStyle(StackNavigationViewStyle())
        }
}

struct HomeView_Previews: PreviewProvider {
        static var previews: some View {
                HomeView()
        }
}

private struct GuideView: View {

        private let enableKeyboard: Text = Text("•  Jump to ") + Text("Settings").fontWeight(.medium) + Text("\n") +
                Text("•  Tap ") + Text("Keyboards").fontWeight(.medium) + Text("\n") +
                Text("•  Turn on ") + Text("Jyutping").fontWeight(.medium) + Text("\n") +
                Text("•  Turn on ") + Text("Allow Full Access").fontWeight(.medium)

        var body: some View {
                VStack {
                        HStack {
                                Text("How to enable this Keyboard").font(.headline)
                                Spacer()
                        }
                        HStack {
                                enableKeyboard
                                        .lineSpacing(5)
                                        .fixedSize(horizontal: false, vertical: true)
                                Spacer()
                        }
                        .padding(.vertical, 5)
                }
                .padding()
                .fillBackground()
                .padding()

                Button(action: {
                        if let url: URL = URL(string: UIApplication.openSettingsURLString) {
                                UIApplication.shared.open(url)
                        }
                }) {
                        HStack{
                                Spacer()
                                Text("Go to ") + Text("Settings").fontWeight(.medium)
                                Spacer()
                        }
                }
                .padding()
                .fillBackground()
                .padding()
        }
}
private struct TonesInput: View {
        /*
        v = 1 陰平， vv = 4 陽平
        x = 2 陰上， xx = 5 陽上
        q = 3 陰去， qq = 6 陽去
        */
        private let content: String = NSLocalizedString("v = 1 陰平， vv = 4 陽平\nx = 2 陰上， xx = 5 陽上\nq = 3 陰去， qq = 6 陽去", comment: "")
        var body: some View {
                VStack {
                        HStack {
                                Text("Tones Input").font(.headline)
                                Spacer()
                        }
                        HStack {
                                Text(content)
                                        .font(.system(.callout, design: .monospaced))
                                        .lineSpacing(5)
                                        .fixedSize(horizontal: false, vertical: true)
                                Spacer()
                        }
                        .padding(.vertical, 5)
                }
                .padding()
                .fillBackground()
                .padding()
        }
}
private struct CangjieReverseLookup: View {
        private let content: String = NSLocalizedString("以 v 開始，再輸入倉頡碼即可\n例如輸入 vdam 就會出「查」等\n候選詞會帶顯示對應嘅粵拼", comment: "")
        var body: some View {
                VStack {
                        HStack {
                                Text("Lookup Jyutping with Cangjie").font(.headline)
                                Spacer()
                        }
                        HStack {
                                Text(content)
                                        .lineSpacing(6)
                                        .fixedSize(horizontal: false, vertical: true)
                                Spacer()
                        }
                        .padding(.vertical, 6)
                }
                .padding()
                .fillBackground()
                .padding()
        }
}
private struct PinyinReverseLookup: View {
        private let content: String = NSLocalizedString("以 r 開始，再輸入普拼即可\n例如輸入 rcha 就會出「查」等\n候選詞會帶顯示對應嘅粵拼", comment: "")
        var body: some View {
                VStack {
                        HStack {
                                Text("Lookup Jyutping with Pinyin").font(.headline)
                                Spacer()
                        }
                        HStack {
                                Text(content)
                                        .lineSpacing(6)
                                        .fixedSize(horizontal: false, vertical: true)
                                Spacer()
                        }
                        .padding(.vertical, 6)
                }
                .padding()
                .fillBackground()
                .padding()
        }
}
private struct PeriodShortcut: View {
        private let content: String = NSLocalizedString("Double tapping the space bar will insert a period followed by a space", comment: "")
        var body: some View {
                VStack {
                        HStack {
                                Text("Period (Full Stop) Shortcut").font(.headline)
                                Spacer()
                        }
                        HStack {
                                Text(content)
                                        .lineSpacing(6)
                                        .fixedSize(horizontal: false, vertical: true)
                                Spacer()
                        }
                        .padding(.vertical, 6)
                }
                .padding()
                .fillBackground()
                .padding()
        }
}
