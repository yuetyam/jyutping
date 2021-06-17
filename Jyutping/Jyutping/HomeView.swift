import SwiftUI

struct HomeView: View {

        private let placeholder: String = NSLocalizedString("Text Field", comment: "")
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
                                if #available(iOS 14.0, *) {
                                        GlobalBackgroundColor().ignoresSafeArea()
                                } else {
                                        GlobalBackgroundColor().edgesIgnoringSafeArea(.all)
                                }
                                ScrollView {
                                        EnhancedTextField(placeholder: placeholder, text: $cacheText)
                                                .padding(10)
                                                .fillBackground()
                                                .padding()
                                        GuideView()
                                        TonesInput().padding(.top)
                                        CangjieReverseLookup()
                                        StrokeReverseLookup()
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

        private let dotText: Text = Text("•")
        private let line_0: Text = Text("Jump to ") + Text("Settings").fontWeight(.medium)
        private let line_1: Text = Text("Tap ") + Text("Keyboards").fontWeight(.medium)
        private let line_2: Text = Text("Turn on ") + Text("Jyutping").fontWeight(.medium)
        private let line_3: Text = Text("Turn on ") + Text("Allow Full Access").fontWeight(.medium)
        private let accessibilityText: Text = Text("How to enable this Keyboard. Step one: jump to Settings, step two: select Keyboards, step three: turn on Jyutping, step four: turn on Allow Full Access")

        var body: some View {
                VStack {
                        HStack {
                                Text("How to enable this Keyboard").font(.headline)
                                Spacer()
                        }
                        VStack(spacing: 5){
                                HStack {
                                        dotText
                                        line_0
                                        Spacer()
                                }
                                HStack {
                                        dotText
                                        line_1
                                        Spacer()
                                }
                                HStack {
                                        dotText
                                        line_2
                                        Spacer()
                                }
                                HStack {
                                        dotText
                                        line_3
                                        Spacer()
                                }
                        }
                        .padding(.vertical, 5)
                }
                .padding()
                .fillBackground()
                .accessibilityElement()
                .accessibility(label: accessibilityText)
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
                                        .font(.system(.body, design: .monospaced))
                                        .lineSpacing(5)
                                        .fixedSize(horizontal: true, vertical: false)
                                Spacer()
                        }
                        .padding(.vertical, 5)
                }
                .padding()
                .fillBackground()
                .contextMenu {
                        MenuCopyButton(content: content)
                }
                .padding()
        }
}
private struct CangjieReverseLookup: View {
        var body: some View {
                VStack {
                        HStack {
                                Text("Lookup Jyutping with Cangjie").font(.headline)
                                Spacer()
                        }
                        HStack {
                                Text("以 v 開始，再輸入倉頡碼即可。例如輸入 vdam 就會出「查」等。候選詞會帶顯示對應嘅粵拼。").lineSpacing(6)
                                Spacer()
                        }
                        .padding(.vertical, 6)
                }
                .padding()
                .fillBackground()
                .padding()
        }
}
private struct StrokeReverseLookup: View {
        var body: some View {
                VStack {
                        HStack {
                                Text("Lookup Jyutping with Stroke").font(.headline)
                                Spacer()
                        }
                        HStack {
                                Text("以 x 開始，再輸入筆畫碼即可。例如輸入 xwsad 就會出「木」等。候選詞會帶顯示對應嘅粵拼。").lineSpacing(6)
                                Spacer()
                        }
                        .padding(.vertical, 6)
                        VStack {
                                HStack {
                                        Text("w = 橫(waang)")
                                        Spacer()
                                }
                                HStack {
                                        Text("s = 豎(syu)")
                                        Spacer()
                                }
                                HStack {
                                        Text("a = 撇")
                                        Spacer()
                                }
                                HStack {
                                        Text("d = 點(dim)")
                                        Spacer()
                                }
                                HStack {
                                        Text("z = 折(zit)")
                                        Spacer()
                                }
                        }
                        .font(.system(.body, design: .monospaced))
                        .lineSpacing(6)
                }
                .padding()
                .fillBackground()
                .padding()
        }
}
private struct PinyinReverseLookup: View {
        var body: some View {
                VStack {
                        HStack {
                                Text("Lookup Jyutping with Pinyin").font(.headline)
                                Spacer()
                        }
                        HStack {
                                Text("以 r 開始，再輸入普通話拼音即可。例如輸入 rcha 就會出「查」等。候選詞會帶顯示對應嘅粵拼。").lineSpacing(6)
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
        var body: some View {
                VStack {
                        HStack {
                                Text("Period (Full Stop) Shortcut").font(.headline)
                                Spacer()
                        }
                        HStack {
                                Text("Double tapping the space bar will insert a period followed by a space").lineSpacing(6)
                                Spacer()
                        }
                        .padding(.vertical, 6)
                }
                .padding()
                .fillBackground()
                .padding()
        }
}
