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
                                                .padding(8)
                                                .fillBackground()
                                                .padding()
                                        /*
                                        if !isJyutpingKeyboardEnabled {
                                                GuideView()
                                        }
                                        */
                                        GuideView()

                                        InputTones().padding(.top)
                                        CangjieReverseLookup()
                                        PinyinReverseLookup().padding(.bottom, 50)
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
                                enableKeyboard.fixedSize(horizontal: false, vertical: true)
                                Spacer()
                        }
                        .padding(.vertical, 4)
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
private struct InputTones: View {
        private let content: String = """
                v = 1 陰平， vv = 4 陽平
                x = 2 陰上， xx = 5 陽上
                q = 3 陰去， qq = 6 陽去
                """
        var body: some View {
                VStack {
                        HStack {
                                Text("聲調輸入").font(.headline)
                                Spacer()
                        }
                        HStack {
                                Text(content)
                                        .font(.system(.body, design: .monospaced))
                                        .fixedSize(horizontal: false, vertical: true)
                                Spacer()
                        }
                        .padding(.vertical, 4)
                }
                .padding()
                .fillBackground()
                .padding()
        }
}
private struct CangjieReverseLookup: View {
        private let content: String = """
                以 v 開始，再輸入倉頡碼即可
                例如輸入 vdam 就會出「查」等
                候選詞會帶顯示對應嘅粵拼
                """
        var body: some View {
                VStack {
                        HStack {
                                Text("用倉頡反查粵拼").font(.headline)
                                Spacer()
                        }
                        HStack {
                                Text(content).fixedSize(horizontal: false, vertical: true)
                                Spacer()
                        }
                        .padding(.vertical, 4)
                }
                .padding()
                .fillBackground()
                .padding()
        }
}
private struct PinyinReverseLookup: View {
        private let content: String = """
                以 r 開始，再輸入普拼即可
                例如輸入 rcha 就會出「查」等
                候選詞會帶顯示對應嘅粵拼
                """
        var body: some View {
                VStack {
                        HStack {
                                Text("用普通話拼音反查粵拼").font(.headline)
                                Spacer()
                        }
                        HStack {
                                Text(content).fixedSize(horizontal: false, vertical: true)
                                Spacer()
                        }
                        .padding(.vertical, 4)
                }
                .padding()
                .fillBackground()
                .padding()
        }
}
